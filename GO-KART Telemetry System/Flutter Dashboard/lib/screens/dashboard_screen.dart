import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/logger_provider.dart';
import '../providers/telemetry_provider.dart';
import '../widgets/bottom_dashboard.dart';
import '../widgets/graphs/graphs_panel.dart';
import '../widgets/telemetry_header.dart';
import '../widgets/top_dashboard.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetry = ref.watch(telemetryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: telemetry.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
        data: (_) {
          final logger = ref.watch(loggerProvider);

          return SafeArea(
            child: Column(
              children: [
                const TelemetryHeader(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight < 670) {
                        return const _WindowTooShortNotice();
                      }

                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 42,
                              child: _LoggingControls(
                                logger: logger,
                                onStart: () => ref
                                    .read(loggerProvider.notifier)
                                    .startLogging(),
                                onStop: () => ref
                                    .read(loggerProvider.notifier)
                                    .stopLogging(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(height: 235, child: const TopDashboard()),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 46,
                              child: _LoggerSummary(logger: logger),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 210,
                              child: const BottomDashboard(),
                            ),
                            const SizedBox(height: 8),
                            const Expanded(child: GraphsPanel()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LoggingControls extends StatelessWidget {
  final LoggerState logger;
  final Future<void> Function() onStart;
  final Future<void> Function() onStop;

  const _LoggingControls({
    required this.logger,
    required this.onStart,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final recording = logger.isLogging;
    final accent = recording
        ? const Color(0xFFFF5252)
        : const Color(0xFF47E87A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1D23),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          _ControlButton(
            icon: Icons.play_arrow_rounded,
            label: 'START LOGGING',
            color: const Color(0xFF47E87A),
            enabled: !recording,
            onPressed: onStart,
          ),
          const SizedBox(width: 8),
          _ControlButton(
            icon: Icons.stop_rounded,
            label: 'STOP LOGGING',
            color: const Color(0xFFFF5252),
            enabled: recording,
            onPressed: onStop,
          ),
          const SizedBox(width: 20),
          Icon(Icons.fiber_manual_record_rounded, color: accent, size: 16),
          const SizedBox(width: 6),
          Text(
            recording ? 'RECORDING' : 'READY TO RECORD',
            style: TextStyle(
              color: accent,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 22),
          Text(
            'Samples: ${logger.sampleCount}',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          if (logger.filePath != null)
            Flexible(
              child: Text(
                'File: ${_fileName(logger.filePath!)}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _fileName(String path) => path.split(RegExp(r'[\\/]+')).last;
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool enabled;
  final Future<void> Function() onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = enabled ? color : Colors.white24;

    return Material(
      color: displayColor.withOpacity(enabled ? 0.12 : 0.05),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: displayColor, size: 17),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: displayColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoggerSummary extends StatelessWidget {
  final LoggerState logger;

  const _LoggerSummary({required this.logger});

  @override
  Widget build(BuildContext context) {
    final recording = logger.isLogging;
    final statusColor = recording
        ? const Color(0xFFFF5252)
        : const Color(0xFF00C8E8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF202127), Color(0xFF191A20)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.16)),
      ),
      child: Row(
        children: [
          Icon(
            recording
                ? Icons.fiber_manual_record_rounded
                : Icons.save_alt_rounded,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'DATA LOGGER',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            recording ? 'RECORDING...' : 'STANDBY',
            style: TextStyle(
              color: statusColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 18),
          if (logger.filePath != null)
            Expanded(
              child: Text(
                _fileName(logger.filePath!),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            const Spacer(),
          _SummaryMetric(
            icon: Icons.analytics_outlined,
            label: 'SAMPLES',
            value: logger.sampleCount.toString(),
            color: const Color(0xFF00E5FF),
          ),
          const SizedBox(width: 24),
          _SummaryMetric(
            icon: Icons.timer_outlined,
            label: 'SESSION',
            value: _formatDuration(logger.duration),
            color: const Color(0xFFAB47BC),
          ),
        ],
      ),
    );
  }

  String _fileName(String path) => path.split(RegExp(r'[\\/]+')).last;

  String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 6),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WindowTooShortNotice extends StatelessWidget {
  const _WindowTooShortNotice();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Maximize the dashboard window to view the complete race layout.',
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}
