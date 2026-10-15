import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/logger_provider.dart';

class LoggerStatistics extends ConsumerWidget {
  const LoggerStatistics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(loggerProvider);
    final isRecording = logger.isLogging;

    final statusColor = isRecording
        ? const Color(0xFFFF5252)
        : const Color(0xFF00C8E8);

    final statusText = isRecording ? 'RECORDING' : 'READY TO RECORD';

    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF202127),
            Color(0xFF18191F),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isRecording
                  ? Icons.fiber_manual_record_rounded
                  : Icons.save_alt_rounded,
              color: statusColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DATA LOGGER',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const Spacer(),
          _metric(
            icon: Icons.analytics_outlined,
            label: 'SAMPLES',
            value: logger.sampleCount.toString(),
            color: const Color(0xFF00E5FF),
          ),
          const SizedBox(width: 42),
          _metric(
            icon: Icons.timer_outlined,
            label: 'SESSION TIME',
            value: _formatDuration(logger.duration),
            color: const Color(0xFFAB47BC),
          ),
        ],
      ),
    );
  }

  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 23),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(duration.inHours)}:'
        '${twoDigits(duration.inMinutes.remainder(60))}:'
        '${twoDigits(duration.inSeconds.remainder(60))}';
  }
}