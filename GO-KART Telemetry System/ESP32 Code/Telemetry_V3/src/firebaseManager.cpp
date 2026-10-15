#include "wifiManager.h"
#include "firebaseManager.h"
#include "config.h"
#include "telemetry.h"

#include <FirebaseClient.h>
#include <ArduinoJson.h>
#include "ExampleFunctions.h"

//=====================================================
// Firebase Objects
//=====================================================

FirebaseApp app;

SSL_CLIENT ssl_client;

using AsyncClient = AsyncClientClass;
AsyncClient aClient(ssl_client);

RealtimeDatabase Database;

bool dbInitialized = false;

//=====================================================
// Debug verbosity
//=====================================================
// The library's isDebug() events (TLS/handshake/internal state strings)
// can be very chatty. Printing all of them over a 115200 baud Serial
// link adds real, measurable delay to every loop() iteration. Leave
// this OFF for normal running; flip to 1 temporarily if you need to
// see exactly what the library is doing internally (e.g. diagnosing a
// stuck connection).
//=====================================================
#define FIREBASE_VERBOSE_DEBUG 0

//=====================================================
// Upload / Async-slot state
//=====================================================
// FirebaseClient (Mobizt) processes ONE request at a time per AsyncClient
// "slot". Firing a second Database.set()/update() on the same aClient
// before the first one has finished causes the library to fail to
// allocate a new slot, which is reported back as:
//      "operation was cancelled"
//
// uploadBusy + uploadStartedAt below guard against that: we only ever
// have one outstanding request on aClient at a time, and we self-heal
// if a request never calls back (e.g. dropped Wi-Fi) via a timeout.
// uploadStartedAt is also reused to measure and print the real
// round-trip time of each upload, so we can tell whether "slow updates"
// are TLS/network latency (expected) vs something actually stuck.
//=====================================================

static bool uploadBusy = false;
static unsigned long uploadStartedAt = 0;
static const unsigned long UPLOAD_BUSY_TIMEOUT_MS = 8000; // safety watchdog

static void releaseUploadSlot(bool success)
{
    unsigned long elapsed = millis() - uploadStartedAt;
    Serial.printf("[FIREBASE] Upload round-trip: %lu ms (%s)\n",
                  elapsed, success ? "OK" : "ERROR");
    uploadBusy = false;
}

static bool acquireUploadSlot()
{
    if (uploadBusy)
    {
        // Self-heal: if a previous request never resolved (event dropped,
        // Wi-Fi hiccup, etc.) don't stay locked forever.
        if (millis() - uploadStartedAt > UPLOAD_BUSY_TIMEOUT_MS)
        {
            Serial.println("[FIREBASE] Previous upload timed out, releasing slot.");
            uploadBusy = false;
        }
        else
        {
            return false; // still genuinely busy, caller should skip this cycle
        }
    }

    uploadBusy = true;
    uploadStartedAt = millis();
    return true;
}

//=====================================================
// Async Callback
//=====================================================

void asyncCallback(AsyncResult &result)
{
    if (result.isEvent())
    {
        Serial.printf("[EVENT] %s\n", result.appEvent().message().c_str());
    }

#if FIREBASE_VERBOSE_DEBUG
    if (result.isDebug())
    {
        Serial.printf("[DEBUG] %s\n", result.debug().c_str());
    }
#endif

    if (result.isError())
    {
        Serial.println();
        Serial.println("========== FIREBASE ERROR ==========");
        Serial.print("Code : ");
        Serial.println(result.error().code());
        Serial.print("Message : ");
        Serial.println(result.error().message().c_str());
        Serial.println("====================================");

        // The request finished (with an error) - free the slot so the
        // next loop iteration can try again instead of staying locked out.
        releaseUploadSlot(false);
    }

    if (result.available())
    {
        Serial.println("[FIREBASE] Telemetry Uploaded");

        // The request completed successfully - free the slot.
        releaseUploadSlot(true);
    }
}

//--------------------------------------------------
// Initialize Firebase
//--------------------------------------------------

bool firebaseBegin()
{
    Serial.printf("\nFirebase Client : %s\n", FIREBASE_CLIENT_VERSION);

    UserAccount user(API_KEY);

    set_ssl_client_insecure_and_buffer(ssl_client);

    // Anonymous sign-up: UserAccount(API_KEY) with no email/password.
    signup(
        aClient,
        app,
        getAuth(user),
        auth_debug_print,
        "signupTask");

    return true;
}

//--------------------------------------------------
// Firebase Loop
//--------------------------------------------------

void firebaseLoop()
{
    app.loop();

    if (!dbInitialized && app.ready())
    {
        app.getApp<RealtimeDatabase>(Database);

        Database.url(DATABASE_URL);

        dbInitialized = true;

        Serial.println();
        Serial.println("=================================");
        Serial.println(" Firebase Connected");
        Serial.println("=================================");
    }
}

//--------------------------------------------------
// Firebase Ready
//--------------------------------------------------

bool firebaseReady()
{
    return wifiConnected() &&
           app.ready() &&
           dbInitialized;
}

//--------------------------------------------------
// Build the full telemetry JSON payload
//--------------------------------------------------
// Built with ArduinoJson (already a project dependency) and then handed
// to FirebaseClient as a single raw JSON object_t. This sidesteps the
// FirebaseClient JsonWriter::create() pitfall, where every call to
// writer.create(root, key, value) OVERWRITES the contents of `root`
// instead of appending to it (root only ever ends up holding the LAST
// field written to it, e.g. "fuelOK" or "timestamp") -- which was the
// root cause of only a single field ever reaching the database.
//--------------------------------------------------

static String buildTelemetryPayload()
{
    JsonDocument doc;

    // General
    doc["timestamp"] = millis();
    doc["firmware"] = FIRMWARE_NAME;

    // Engine
    doc["rpm"] = telemetry.rpm;
    doc["engineTemp"] = telemetry.engineTemp;
    doc["battery"] = telemetry.battery;
    doc["fuel"] = telemetry.fuel;

    // Orientation
    doc["pitch"] = telemetry.pitch;
    doc["roll"] = telemetry.roll;

    // Accelerometer
    doc["accelX"] = telemetry.accelX;
    doc["accelY"] = telemetry.accelY;
    doc["accelZ"] = telemetry.accelZ;

    // Gyroscope
    doc["gyroX"] = telemetry.gyroX;
    doc["gyroY"] = telemetry.gyroY;
    doc["gyroZ"] = telemetry.gyroZ;

    // G-Force
    doc["gForceX"] = telemetry.gForceX;
    doc["gForceY"] = telemetry.gForceY;
    doc["gForceZ"] = telemetry.gForceZ;
    doc["totalG"] = telemetry.totalG;

    // GPS (nested object)
    JsonObject gps = doc["gps"].to<JsonObject>();
    gps["latitude"] = telemetry.gps.latitude;
    gps["longitude"] = telemetry.gps.longitude;
    gps["speed"] = telemetry.gps.speed;
    gps["satellites"] = telemetry.gps.satellites;

    // Switches
    doc["brake"] = telemetry.brake;
    doc["frontKill"] = telemetry.frontKill;
    doc["rearKill"] = telemetry.rearKill;
    doc["emergencyKill"] = telemetry.emergencyKill;

    // Sensor health
    doc["gpsOK"] = telemetry.gpsOK;
    doc["imuOK"] = telemetry.imuOK;
    doc["tempOK"] = telemetry.tempOK;
    doc["rpmOK"] = telemetry.rpmOK;
    doc["batteryOK"] = telemetry.batteryOK;
    doc["fuelOK"] = telemetry.fuelOK;

    String payload;
    serializeJson(doc, payload);
    return payload;
}

//--------------------------------------------------
// Upload Telemetry (single atomic object write)
//--------------------------------------------------
// Writes the ENTIRE telemetry object in one PUT to FIREBASE_BASE_PATH
// ("/FormulaKart/Live/Kart01"), so the Flutter dashboard always sees a
// complete, consistent snapshot instead of partially-written fields.
//--------------------------------------------------

bool uploadTelemetry()
{
    if (!firebaseReady())
        return false;

    if (!acquireUploadSlot())
        return false; // previous upload still in flight - skip this cycle

    String payload = buildTelemetryPayload();
    object_t json(payload);

    Database.set<object_t>(
        aClient,
        FIREBASE_BASE_PATH,
        json,
        asyncCallback,
        "uploadTelemetryTask");

    return true;
}

//--------------------------------------------------
// Upload Heartbeat (lightweight PATCH - does not disturb other fields)
//--------------------------------------------------

bool uploadHeartbeat()
{
    if (!firebaseReady())
        return false;

    if (!acquireUploadSlot())
        return false;

    JsonDocument doc;
    doc["timestamp"] = millis();
    doc["firmware"] = FIRMWARE_NAME;

    String payload;
    serializeJson(doc, payload);
    object_t json(payload);

    Database.update<object_t>(
        aClient,
        FIREBASE_BASE_PATH,
        json,
        asyncCallback,
        "uploadHeartbeatTask");

    return true;
}

//--------------------------------------------------
// Upload GPS only (lightweight PATCH - does not disturb other fields)
//--------------------------------------------------

bool uploadGPS()
{
    if (!firebaseReady())
        return false;

    if (!acquireUploadSlot())
        return false;

    JsonDocument doc;
    JsonObject gps = doc["gps"].to<JsonObject>();
    gps["latitude"] = telemetry.gps.latitude;
    gps["longitude"] = telemetry.gps.longitude;
    gps["speed"] = telemetry.gps.speed;
    gps["satellites"] = telemetry.gps.satellites;

    String payload;
    serializeJson(doc, payload);
    object_t json(payload);

    Database.update<object_t>(
        aClient,
        FIREBASE_BASE_PATH,
        json,
        asyncCallback,
        "uploadGPSTask");

    return true;
}