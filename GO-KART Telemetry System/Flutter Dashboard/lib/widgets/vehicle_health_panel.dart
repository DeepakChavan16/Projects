import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_model.dart';

enum HealthLevel {
  normal,
  warning,
  critical,
}

class HealthState {
  final HealthLevel level;
  final String message;
  final ColorType color;

  const HealthState({
    required this.level,
    required this.message,
    required this.color,
  });
}

enum ColorType {
  green,
  yellow,
  red,
}

class HealthNotifier extends Notifier<HealthState> {
  @override
  HealthState build() {
    return const HealthState(
      level: HealthLevel.normal,
      message: "ALL SYSTEMS NORMAL",
      color: ColorType.green,
    );
  }

  void update(TelemetryModel data, bool esp32Online) {
    if (!esp32Online) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "ESP32 OFFLINE",
        color: ColorType.red,
      );
      return;
    }

    if (data.emergencyKill) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "EMERGENCY KILL ACTIVE",
        color: ColorType.red,
      );
      return;
    }

    if (data.engineTemp >= 110) {
      state = const HealthState(
        level: HealthLevel.critical,
        message: "ENGINE OVERHEATING",
        color: ColorType.red,
      );
      return;
    }

    if (data.battery <= 11.5) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "LOW BATTERY",
        color: ColorType.yellow,
      );
      return;
    }

    if (data.fuel <= 15) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "LOW FUEL",
        color: ColorType.yellow,
      );
      return;
    }

    if (data.satellites == 0) {
      state = const HealthState(
        level: HealthLevel.warning,
        message: "WAITING FOR GPS FIX",
        color: ColorType.yellow,
      );
      return;
    }

    state = const HealthState(
      level: HealthLevel.normal,
      message: "ALL SYSTEMS NORMAL",
      color: ColorType.green,
    );
  }
}

final healthProvider =
    NotifierProvider<HealthNotifier, HealthState>(
  HealthNotifier.new,
);