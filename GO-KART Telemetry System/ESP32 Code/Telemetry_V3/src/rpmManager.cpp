#include <Arduino.h>
#include "rpmManager.h"
#include "config.h"
#include "telemetry.h"

volatile uint32_t pulseCount = 0;
unsigned long lastRPMTime = 0;

void IRAM_ATTR rpmISR()
{
    pulseCount++;
}

void rpmBegin()
{
    pinMode(RPM_PIN, INPUT_PULLUP);

    attachInterrupt(
        digitalPinToInterrupt(RPM_PIN),
        rpmISR,
        FALLING);

    Serial.println("RPM Manager Initialized");
}

void rpmLoop()
{   
    if (telemetry.rpm > 0)
    {
        telemetry.rpmOK = true;
    }
    else
    {
        telemetry.rpmOK = false;
    }

    if (millis() - lastRPMTime >= 1000)
    {   
        noInterrupts();
        uint32_t pulses = pulseCount;
        pulseCount = 0;
        interrupts();

        // 1 pulse per engine revolution
        telemetry.rpm = pulses * 60.0;

        lastRPMTime = millis();
    }
}

float getRPM()
{
    return telemetry.rpm;
}