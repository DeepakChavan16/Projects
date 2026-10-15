import 'package:flutter/material.dart';

import 'telemetry_graph.dart';

class GraphsPanel extends StatelessWidget {
  const GraphsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF202127), Color(0xFF18191F)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C8E8).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: Color(0xFF00C8E8),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'LIVE TELEMETRY GRAPHS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const _BufferBadge(),
              ],
            ),
            const SizedBox(height: 7),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: TelemetryGraph(
                      title: 'RPM',
                      color: Color(0xFFFF5252),
                      minY: 0,
                      maxY: 8000,
                      valueSelector: _rpm,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TelemetryGraph(
                      title: 'Speed',
                      color: Color(0xFF2196F3),
                      minY: 0,
                      maxY: 120,
                      valueSelector: _speed,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TelemetryGraph(
                      title: 'Engine Temp',
                      color: Color(0xFFFFA000),
                      minY: 0,
                      maxY: 150,
                      valueSelector: _temperature,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TelemetryGraph(
                      title: 'Battery',
                      color: Color(0xFF47E87A),
                      minY: 0,
                      maxY: 15,
                      valueSelector: _battery,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TelemetryGraph(
                      title: 'Fuel',
                      color: Color(0xFFFFC107),
                      minY: 0,
                      maxY: 100,
                      valueSelector: _fuel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double _rpm(dynamic telemetry) => telemetry.rpm as double;
  static double _speed(dynamic telemetry) => telemetry.gpsSpeed as double;
  static double _temperature(dynamic telemetry) => telemetry.engineTemp as double;
  static double _battery(dynamic telemetry) => telemetry.battery as double;
  static double _fuel(dynamic telemetry) => telemetry.fuel as double;
}

class _BufferBadge extends StatelessWidget {
  const _BufferBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF47E87A).withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF47E87A).withOpacity(0.22)),
      ),
      child: const Text(
        '60 SAMPLES',
        style: TextStyle(
          color: Color(0xFF47E87A),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
