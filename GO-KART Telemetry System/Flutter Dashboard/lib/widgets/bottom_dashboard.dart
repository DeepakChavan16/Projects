import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/telemetry_provider.dart';
import 'artificial_horizon/artificial_horizon.dart';
import 'dashboard_card.dart';
import 'gps_live_map.dart';
import 'imu_panel.dart';

class BottomDashboard extends ConsumerWidget {
  const BottomDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(telemetryProvider).asData?.value;

    if (data == null) return const SizedBox.shrink();

    return SizedBox.expand(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: 'ARTIFICIAL HORIZON',
              compact: true,
              child: ArtificialHorizon(pitch: data.pitch, roll: data.roll),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: DashboardCard(
              title: 'LIVE GPS MAP',
              compact: true,
              child: const GpsLiveMap(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(flex: 4, child: IMUPanel(data: data)),
        ],
      ),
    );
  }
}
