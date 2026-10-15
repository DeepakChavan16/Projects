#include "fuelManager.h"

#include <Arduino.h>
#include "config.h"
#include "telemetry.h"

// Calibrated with the user's working fuel-gauge sketch.
static constexpr int EMPTY_ADC = 97;
static constexpr int FULL_ADC = 0;
static constexpr int FUEL_SAMPLE_COUNT = 20;
static constexpr unsigned long FUEL_SAMPLE_INTERVAL_MS = 100;

void fuelBegin()
{
    analogReadResolution(12);
    analogSetPinAttenuation(FUEL_PIN, ADC_11db);
}

void fuelLoop()
{
    static unsigned long lastSampleAt = 0;
    const unsigned long now = millis();
    if (now - lastSampleAt < FUEL_SAMPLE_INTERVAL_MS)
        return;
    lastSampleAt = now;

    // Average samples without delay() so GPS and Firebase background work
    // can continue running on every main-loop iteration.
    uint32_t total = 0;
    for (int i = 0; i < FUEL_SAMPLE_COUNT; ++i)
        total += analogRead(FUEL_PIN);

    const int adc = total / FUEL_SAMPLE_COUNT;
    int fuel = map(adc, EMPTY_ADC, FULL_ADC, 0, 100);

    if (fuel < 0) fuel = 0;
    if (fuel > 100) fuel = 100;

    telemetry.fuel = fuel;
    telemetry.fuelOK = true;
}
