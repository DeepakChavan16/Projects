import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_model.dart';
import 'connection_provider.dart';
import 'logger_provider.dart';
import 'gps_provider.dart';
import 'health_provider.dart';

final telemetryProvider = StreamProvider<TelemetryModel>((ref) {
  final databaseRef = FirebaseDatabase.instance.ref('FormulaKart/Live/Kart01');
  final speedFilter = _GpsSpeedFilter();

  return databaseRef.onValue.map((event) {
    final value = event.snapshot.value;
    if (value == null) {
      throw Exception("No telemetry data found.");
    }
    final root = Map<String, dynamic>.from(value as Map);
    final rawTelemetry = TelemetryModel.fromMap(root);
    final telemetry = rawTelemetry.copyWith(
      gpsSpeed: speedFilter.filter(
        rawTelemetry.gpsSpeed,
        satellites: rawTelemetry.satellites,
      ),
    );

    ref.read(gpsTrackProvider.notifier).addPoint(
          telemetry.latitude,
          telemetry.longitude,
        );
    ref.read(connectionProvider.notifier).packetReceived();

    final connection = ref.read(connectionProvider);
    ref.read(healthProvider.notifier).update(
          telemetry,
          connection.esp32Online,
        );

    // Logging must never hold up the live dashboard update.
    unawaited(ref.read(loggerProvider.notifier).logTelemetry(telemetry));
    return telemetry;
  });
});

class _GpsSpeedFilter {
  static const _stationaryThreshold = 3.0;
  static const _requiredMovingSamples = 2;

  double _lastSpeed = 0;
  int _movingSamples = 0;

  double filter(double rawSpeed, {required int satellites}) {
    if (satellites < 6 || rawSpeed < _stationaryThreshold) {
      _movingSamples = 0;
      _lastSpeed = 0;
      return 0;
    }

    _movingSamples++;
    if (_movingSamples < _requiredMovingSamples) return 0;

    // Prevent one noisy GPS sample from producing a large speed jump.
    _lastSpeed = _lastSpeed == 0 ? rawSpeed : _lastSpeed * 0.35 + rawSpeed * 0.65;
    return _lastSpeed;
  }
}
