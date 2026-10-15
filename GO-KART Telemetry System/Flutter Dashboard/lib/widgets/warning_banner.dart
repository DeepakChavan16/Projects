import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/health_provider.dart';

class WarningBanner extends ConsumerWidget {
  const WarningBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final health = ref.watch(healthProvider);

    IconData icon;
    Color color;

    switch (health.level) {
      case HealthLevel.normal:
        color = const Color(0xFF00C853);
        icon = Icons.check_circle;
        break;

      case HealthLevel.warning:
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
        break;

      case HealthLevel.critical:
        color = Colors.redAccent;
        icon = Icons.error;
        break;
    }

    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              health.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              health.level.name.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}