import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_model.dart';
import '../services/csv_logger_service.dart';
import 'dart:async';

class LoggerState {
  final bool isLogging;
  final String? filePath;

  /// Time when logging started
  final DateTime? startTime;

  /// Number of telemetry samples recorded
  final int sampleCount;

  /// Estimated CSV file size (bytes)
  final int estimatedBytes;

  const LoggerState({
    this.isLogging = false,
    this.filePath,
    this.startTime,
    this.sampleCount = 0,
    this.estimatedBytes = 0,
  });

  Duration get duration {
    if (startTime == null) return Duration.zero;
    return DateTime.now().difference(startTime!);
  }

  LoggerState copyWith({
    bool? isLogging,
    String? filePath,
    DateTime? startTime,
    int? sampleCount,
    int? estimatedBytes,
  }) {
    return LoggerState(
      isLogging: isLogging ?? this.isLogging,
      filePath: filePath ?? this.filePath,
      startTime: startTime ?? this.startTime,
      sampleCount: sampleCount ?? this.sampleCount,
      estimatedBytes: estimatedBytes ?? this.estimatedBytes,
    );
  }
}

class LoggerNotifier extends Notifier<LoggerState> {
  final CsvLoggerService _logger = CsvLoggerService();
  Timer? _timer;

  @override
  LoggerState build() {
    return const LoggerState();
  }

  Future<void> startLogging() async {
    if (state.isLogging) return;

    try {
      final path = await _logger.startLogging();

      print("CSV Path: $path");

      state = state.copyWith(
        isLogging: true,
        filePath: path,
        startTime: DateTime.now(),
        sampleCount: 0,
        estimatedBytes: 0,
      );

      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          if (!state.isLogging) return;
          state = state.copyWith();
        },
      );

      print("Logger started successfully");
    } catch (e, stack) {
      print("LOGGER ERROR:");
      print(e);
      print(stack);
    }
  }

  Future<void> stopLogging() async {
    _timer?.cancel();

    await _logger.stopLogging();

    state = state.copyWith(
      isLogging: false,
      startTime: null,
    );
  }

  Future<void> logTelemetry(TelemetryModel data) async {
    if (!state.isLogging) return;

    await _logger.logTelemetry(data);

    const bytesPerRow = 170;

    state = state.copyWith(
      sampleCount: state.sampleCount + 1,
      estimatedBytes: state.estimatedBytes + bytesPerRow,
    );
  }
}

final loggerProvider =
    NotifierProvider<LoggerNotifier, LoggerState>(
  LoggerNotifier.new,
);
