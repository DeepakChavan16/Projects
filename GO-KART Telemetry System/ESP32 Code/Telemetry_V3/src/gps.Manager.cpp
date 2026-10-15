#include "gpsManager.h"
#include "config.h"
#include "telemetry.h"

#include <TinyGPS++.h>

HardwareSerial GPSSerial(2);
TinyGPSPlus gps;

bool gpsBegin()
{
    GPSSerial.begin(GPS_BAUD, SERIAL_8N1, GPS_RX_PIN, GPS_TX_PIN);

    Serial.println("GPS Initialized");

    return true;
}

void gpsLoop()
{
    // Read all incoming GPS data first
    while (GPSSerial.available())
    {
        gps.encode(GPSSerial.read());
    }

    // Check GPS Fix
    telemetry.gpsOK = gps.location.isValid();

    // Update only when a new location arrives
    if (gps.location.isUpdated())
    {
        telemetry.gps.latitude = gps.location.lat();
        telemetry.gps.longitude = gps.location.lng();

        // Update speed only if valid
        if (gps.speed.isValid())
        {
            telemetry.gps.speed = gps.speed.kmph();
        }
        else
        {
            telemetry.gps.speed = 0;
        }

        // Filter GPS drift when stationary
        if (telemetry.gps.speed < 2.0)
        {
            telemetry.gps.speed = 0.0;
        }

        telemetry.gps.satellites = gps.satellites.value();

        Serial.println("========== GPS ==========");

        Serial.print("Latitude : ");
        Serial.println(telemetry.gps.latitude, 6);

        Serial.print("Longitude: ");
        Serial.println(telemetry.gps.longitude, 6);

        Serial.print("Speed    : ");
        Serial.print(telemetry.gps.speed, 2);
        Serial.println(" km/h");

        Serial.print("Satellites: ");
        Serial.println(telemetry.gps.satellites);

        Serial.println("=========================");
    }
}