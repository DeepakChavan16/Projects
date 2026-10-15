import 'package:flutter/material.dart';

import 'rpm_gauge.dart';
import 'speed_gauge.dart';
import 'dashboard_card.dart';

class GaugesPanel extends StatelessWidget {
  final double rpm;
  final double speed;

  const GaugesPanel({
    super.key,
    required this.rpm,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Row(
        children: [
          Expanded(
            child: DashboardCard(
              title: "RPM",
              child: RPMGauge(rpm: rpm),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: DashboardCard(
              title: "SPEED",
              child: SpeedGauge(speed: speed),
            ),
          ),
        ],
      ),
    );
  }
}