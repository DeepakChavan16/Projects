#include "imuManager.h"

#include <Wire.h>
#include <MPU6050.h>
#include <math.h>

#include "telemetry.h"

MPU6050 mpu;

bool imuAvailable = false;

void imuBegin()
{
    Serial.println("Initializing MPU6050...");

    Wire.begin(21,22);

    mpu.initialize();

mpu.initialize();

imuAvailable = true;

Serial.println("MPU6050 Connected");

imuAvailable = true;

    Serial.println("MPU6050 Connected");

    imuAvailable = true;
}

void imuLoop()
{
    telemetry.imuOK = imuAvailable;

    if (!imuAvailable)
        return;

    int16_t ax, ay, az;
    int16_t gx, gy, gz;

    mpu.getMotion6(
        &ax,
        &ay,
        &az,
        &gx,
        &gy,
        &gz);

    //---------------------------------------
    // Raw Accelerometer -> G Force
    //---------------------------------------

   telemetry.gForceX = ax / 16384.0;
telemetry.gForceY = ay / 16384.0;
telemetry.gForceZ = az / 16384.0;

telemetry.accelX = telemetry.gForceX;
telemetry.accelY = telemetry.gForceY;
telemetry.accelZ = telemetry.gForceZ;

telemetry.totalG = sqrt(
    telemetry.gForceX * telemetry.gForceX +
    telemetry.gForceY * telemetry.gForceY +
    telemetry.gForceZ * telemetry.gForceZ);

    //---------------------------------------
    // Gyroscope
    //---------------------------------------

    telemetry.gyroX = gx / 131.0;
    telemetry.gyroY = gy / 131.0;
    telemetry.gyroZ = gz / 131.0;

    //---------------------------------------
    // Roll
    //---------------------------------------

    telemetry.roll =
        atan2(
            telemetry.accelY,
            telemetry.accelZ)
        * 180.0 / PI;

    //---------------------------------------
    // Pitch
    //---------------------------------------

    telemetry.pitch =
        atan2(
            -telemetry.accelX,
            sqrt(
                telemetry.accelY * telemetry.accelY +
                telemetry.accelZ * telemetry.accelZ))
        * 180.0 / PI;

    //---------------------------------------
    // Total G Force
    //---------------------------------------

    telemetry.totalG =
        sqrt(
            telemetry.accelX * telemetry.accelX +
            telemetry.accelY * telemetry.accelY +
            telemetry.accelZ * telemetry.accelZ);
}