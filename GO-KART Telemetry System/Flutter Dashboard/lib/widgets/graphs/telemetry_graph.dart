import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/telemetry_provider.dart';
import 'graph_card.dart';
import 'live_line_chart.dart';

class TelemetryGraph extends ConsumerStatefulWidget {
  final String title;
  final Color color;
  final double minY;
  final double maxY;
  final double Function(dynamic telemetry) valueSelector;

  const TelemetryGraph({
    super.key,
    required this.title,
    required this.color,
    required this.minY,
    required this.maxY,
    required this.valueSelector,
  });

  @override
  ConsumerState<TelemetryGraph> createState() => _TelemetryGraphState();
}

class _TelemetryGraphState extends ConsumerState<TelemetryGraph> {
  static const int _maximumHistoryPoints = 60;

  final List<double> history = [];
  int? _lastTimestamp;

  String get _unit {
    final name = widget.title.toUpperCase();

    if (name.contains('RPM')) {
      return 'rpm';
    }
    if (name.contains('SPEED')) {
      return 'km/h';
    }
    if (name.contains('TEMP')) {
      return '°C';
    }
    if (name.contains('BATTERY')) {
      return 'V';
    }
    if (name.contains('FUEL')) {
      return '%';
    }

    return '';
  }

  String _formattedValue(double value) {
    final name = widget.title.toUpperCase();

    if (name.contains('RPM') || name.contains('FUEL')) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final telemetryAsync = ref.watch(telemetryProvider);

    return telemetryAsync.when(
      loading: () => GraphCard(
        title: widget.title,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, _) => GraphCard(
        title: widget.title,
        child: Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      ),
      data: (telemetry) {
        final value = widget.valueSelector(telemetry);
        final hasNewPacket = _lastTimestamp != telemetry.timestamp;
        final valueChanged =
            history.isEmpty || (history.last - value).abs() > 0.001;

        if (hasNewPacket || valueChanged) {
          history.add(value);
          _lastTimestamp = telemetry.timestamp;

          if (history.length > _maximumHistoryPoints) {
            history.removeAt(0);
          }
        }

        return GraphCard(
          title: widget.title,
          child: Stack(
            children: [
              LiveLineChart(
                values: history,
                lineColor: widget.color,
                minY: widget.minY,
                maxY: widget.maxY,
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15161B).withOpacity(0.88),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.color.withOpacity(0.32),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _formattedValue(value),
                          style: TextStyle(
                            color: widget.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' $_unit',
                          style: TextStyle(
                            color: widget.color.withOpacity(0.72),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 4,
                bottom: 2,
                child: Text(
                  'ROLLING ${history.length}/$_maximumHistoryPoints',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
