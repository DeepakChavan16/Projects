import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/telemetry_provider.dart';
import 'graph_card.dart';
import 'live_line_chart.dart';

class RpmGraph extends ConsumerStatefulWidget {
  const RpmGraph({super.key});

  @override
  ConsumerState<RpmGraph> createState() => _RpmGraphState();
}

class _RpmGraphState extends ConsumerState<RpmGraph> {
  final List<double> history = [];

  @override
  Widget build(BuildContext context) {
    final telemetryAsync = ref.watch(telemetryProvider);

    return telemetryAsync.when(
      loading: () => const GraphCard(
        title: "RPM",
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      error: (e, _) => GraphCard(
        title: "RPM",
        child: Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),

      data: (telemetry) {
        final rpm = telemetry.rpm.toDouble();

        if (history.isEmpty || history.last != rpm) {
          history.add(rpm);

          if (history.length > 60) {
            history.removeAt(0);
          }
        }

        return GraphCard(
          title: "RPM",
          child: LiveLineChart(
            values: history,
            lineColor: Colors.red,
            minY: 0,
            maxY: 8000,
          ),
        );
      },
    );
  }
}