#include <Arduino.h>

#include "config.h"
#include "telemetry.h"
#include "wifiManager.h"
#include "firebaseManager.h"
#include "sensorManager.h"

void setup()
{
    Serial.begin(115200);

    Serial.println();
    Serial.println("=================================");
    Serial.println("    FKDC TELEMETRY SYSTEM V3");
    Serial.println("=================================");

    wifiBegin();
    firebaseBegin();
    sensorBegin();
}

void loop()
{
    static unsigned long lastTelemetryUpload = 0;
    static unsigned long sensorPrint = 0;

    // 1. Critical background tasks (must run continuously without delay)
    wifiLoop();
    firebaseLoop();
    sensorLoop();

    // 2. Debug Serial Print (Every 1000ms)
    if (millis() - sensorPrint >= 1000)
    {
        sensorPrint = millis();

        Serial.println("=================================");
        Serial.print("RPM           : "); Serial.println(telemetry.rpm);
        Serial.print("Engine Temp   : "); Serial.print(telemetry.engineTemp); Serial.println(" °C");
        Serial.print("Battery       : "); Serial.print(telemetry.battery); Serial.println(" V");
        Serial.print("Fuel          : "); Serial.print(telemetry.fuel); Serial.println(" %");

        Serial.print("Latitude      : "); Serial.println(telemetry.gps.latitude, 6);
        Serial.print("Longitude     : "); Serial.println(telemetry.gps.longitude, 6);
        Serial.print("Kart Speed    : "); Serial.print(telemetry.gps.speed); Serial.println(" km/h");
        Serial.print("Satellites    : "); Serial.println(telemetry.gps.satellites);

        Serial.print("Pitch / Roll  : "); Serial.print(telemetry.pitch); Serial.print(" / "); Serial.println(telemetry.roll);
        Serial.print("Total G       : "); Serial.println(telemetry.totalG);

        Serial.print("Brake         : "); Serial.println(telemetry.brake ? "PRESSED" : "RELEASED");
        Serial.print("Emergency Kill: "); Serial.println(telemetry.emergencyKill ? "ON" : "OFF");
        Serial.println("=================================");
    }

    // 3. Firebase Async Upload (Every 1000ms to allow SSL async cycle to finish)
    if (firebaseReady() && (millis() - lastTelemetryUpload >= 1000))
    {
        lastTelemetryUpload = millis();

        bool ok = uploadTelemetry();

        Serial.print("[FIREBASE] Telemetry Dispatch = ");
        Serial.println(ok ? "QUEUED / SUCCESS" : "SKIPPED (BUSY)");
    }
}