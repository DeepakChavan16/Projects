#ifndef TELEMETRY_H
#define TELEMETRY_H

struct GPSData
{
    double latitude;
    double longitude;
    double speed;
    int satellites;
};

struct TelemetryData
{
    GPSData gps;

    float rpm;
    float engineTemp;

    float battery;
    float fuel;

    // Accelerometer (m/s²)
float accelX;
float accelY;
float accelZ;

// Gyroscope (rad/s)
float gyroX;
float gyroY;
float gyroZ;


// G-Force
float gForceX;
float gForceY;
float gForceZ;
float totalG;

// Orientation
float pitch;
float roll;

    bool brake;
    bool frontKill;
    bool rearKill;
    bool emergencyKill;

    // Sensor Health
    bool gpsOK;
    bool imuOK;
    bool tempOK;
    bool rpmOK;
    bool batteryOK;
    bool fuelOK;
};

extern TelemetryData telemetry;

#endif