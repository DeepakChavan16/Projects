#include "tempManager.h"
#include "telemetry.h"
#include "config.h"

#include <max6675.h>

// Pins (already discussed earlier)
const int thermoSO = 19;
const int thermoCS = 5;
const int thermoSCK = 18;

MAX6675 thermocouple(thermoSCK, thermoCS, thermoSO);

void tempBegin()
{
    delay(500);   // Allow MAX6675 to stabilize
}

void tempLoop()
{
    float temp = thermocouple.readCelsius();

    if (!isnan(temp))
    {
        telemetry.engineTemp = temp;
        telemetry.tempOK = true;
    }
    else
    {
        telemetry.tempOK = false;
    }
    // Accept only valid temperature readings
    if (!isnan(temp) && temp > -20 && temp < 1000)
    {
        telemetry.engineTemp = temp;
    }
}