import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_model.dart';

enum HealthLevel { normal, warning, critical }

class HealthState {
  final HealthLevel level;
  final String message;

  const HealthState({
    required this.level,
    required this.message,
  });
}

class HealthNotifier extends Notifier<HealthState> {
  @override
  HealthState build() {
    return const HealthState(
      level: HealthLevel.normal,
      message: "ALL SYSTEMS NORMAL",
    );
  }

  void update(TelemetryModel data, bool esp32Online) {
    if (!esp32Online) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "ESP32 OFFLINE",
      );
      return;
    }

    if (data.emergencyKill) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "EMERGENCY KILL ACTIVE",
      );
      return;
    }

    if (data.engineTemp >= 110) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "ENGINE OVERHEATING",
      );
      return;
    }

    if (data.battery <= 11.5) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "LOW BATTERY",
      );
      return;
    }

    if (data.fuel <= 15) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "LOW FUEL",
      );
      return;
    }

    if (data.satellites == 0) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "WAITING FOR GPS FIX",
      );
      return;
    }

    state = const HealthState(
      level: HealthLevel.normal,
      message: "ALL SYSTEMS NORMAL",
    );
  }
}

final healthProvider =
    NotifierProvider<HealthNotifier, HealthState>(
  HealthNotifier.new,
);