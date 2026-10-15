import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionState {
  final bool esp32Online;
  final bool firebaseConnected;

  final int packetCount;
  final double packetRate;
  final double lastPacketSeconds;

  const ConnectionState({
    this.esp32Online = false,
    this.firebaseConnected = true,
    this.packetCount = 0,
    this.packetRate = 0,
    this.lastPacketSeconds = 0,
  });

  ConnectionState copyWith({
    bool? esp32Online,
    bool? firebaseConnected,
    int? packetCount,
    double? packetRate,
    double? lastPacketSeconds,
  }) {
    return ConnectionState(
      esp32Online: esp32Online ?? this.esp32Online,
      firebaseConnected:
          firebaseConnected ?? this.firebaseConnected,
      packetCount: packetCount ?? this.packetCount,
      packetRate: packetRate ?? this.packetRate,
      lastPacketSeconds:
          lastPacketSeconds ?? this.lastPacketSeconds,
    );
  }
}

class ConnectionNotifier extends Notifier<ConnectionState> {
  DateTime? _lastPacketTime;
  Timer? _timer;

  @override
  ConnectionState build() {
    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateConnection(),
    );

    ref.onDispose(() {
      _timer?.cancel();
    });

    return const ConnectionState();
  }

  void packetReceived() {
    final now = DateTime.now();

    double hz = state.packetRate;

    if (_lastPacketTime != null) {
      final diff =
          now.difference(_lastPacketTime!).inMilliseconds;

      if (diff > 0) {
        hz = 1000 / diff;
      }
    }

    _lastPacketTime = now;

    state = state.copyWith(
      esp32Online: true,
      firebaseConnected: true,
      packetCount: state.packetCount + 1,
      packetRate: hz,
      lastPacketSeconds: 0,
    );
  }

  void _updateConnection() {
    if (_lastPacketTime == null) return;

    final elapsed =
        DateTime.now().difference(_lastPacketTime!).inMilliseconds /
            1000;

    state = state.copyWith(
      lastPacketSeconds: elapsed,
      esp32Online: elapsed < 15,
    );
  }

  void setFirebaseConnected(bool value) {
    state = state.copyWith(
      firebaseConnected: value,
    );
  }

  void resetSession() {
    _lastPacketTime = null;

    state = state.copyWith(
      esp32Online: false,
      packetCount: 0,
      packetRate: 0,
      lastPacketSeconds: 0,
    );
  }
}

final connectionProvider =
    NotifierProvider<ConnectionNotifier, ConnectionState>(
  ConnectionNotifier.new,
);