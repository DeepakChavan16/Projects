#include "switchManager.h"

#include "sensorManager.h"

#include "gpsManager.h"
#include "rpmManager.h"
#include "tempManager.h"
#include "batteryManager.h"
#include "fuelManager.h"
#include "imuManager.h"

void sensorBegin()
{
    gpsBegin();
    rpmBegin();
    tempBegin();
    batteryBegin();
    fuelBegin();
    imuBegin();
    switchBegin();
}

void sensorLoop()
{
    gpsLoop();
    rpmLoop();
    tempLoop();
    batteryLoop();
    fuelLoop();
    imuLoop();
    switchLoop();
}