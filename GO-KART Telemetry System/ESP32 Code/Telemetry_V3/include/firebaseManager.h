#ifndef FIREBASE_MANAGER_H
#define FIREBASE_MANAGER_H

#include <Arduino.h>

bool firebaseBegin();
void firebaseLoop();

bool firebaseReady();

// Returns true only if a new upload was actually QUEUED this call.
// Returns false if Firebase isn't ready yet OR a previous upload is
// still in flight (this is what prevents overlapping async requests,
// which is what caused "operation was cancelled").
bool uploadHeartbeat();
bool uploadGPS();
bool uploadTelemetry();

#endif