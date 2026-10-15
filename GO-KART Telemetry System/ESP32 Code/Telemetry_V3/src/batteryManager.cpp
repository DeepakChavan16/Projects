#include "batteryManager.h"

#include <Arduino.h>
#include "telemetry.h"

#define BATTERY_PIN 34

const float ADC_REF = 3.3;
const int ADC_MAX = 4095;

// Voltage Divider
const float R1 = 28000.0;
const float R2 = 10000.0;

void batteryBegin()
{
    analogReadResolution(12);
}

void batteryLoop()
{   
    telemetry.batteryOK =
    (telemetry.battery > 8.0 && telemetry.battery < 16.0);
    
    int adc = analogRead(BATTERY_PIN);

    float adcVoltage = (adc * ADC_REF) / ADC_MAX;

    float batteryVoltage = adcVoltage * ((R1 + R2) / R2);

    telemetry.battery = batteryVoltage;
}