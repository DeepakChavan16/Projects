#include <Arduino.h>

#include "switchManager.h"
#include "telemetry.h"

// Pin Definitions
#define BRAKE_PIN          27
#define FRONT_KILL_PIN     25
#define EMERGENCY_KILL_PIN 26
#define REAR_KILL_PIN      33

void switchBegin()
{
    pinMode(BRAKE_PIN, INPUT_PULLUP);

    pinMode(FRONT_KILL_PIN, INPUT_PULLUP);

    pinMode(EMERGENCY_KILL_PIN, INPUT_PULLUP);

    pinMode(REAR_KILL_PIN, INPUT_PULLUP);
}

void switchLoop()
{
    telemetry.brake = !digitalRead(BRAKE_PIN);

    telemetry.frontKill = !digitalRead(FRONT_KILL_PIN);

    telemetry.emergencyKill = !digitalRead(EMERGENCY_KILL_PIN);

    telemetry.rearKill = !digitalRead(REAR_KILL_PIN);
}