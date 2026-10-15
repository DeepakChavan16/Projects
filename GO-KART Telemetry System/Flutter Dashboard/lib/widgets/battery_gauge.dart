import 'package:flutter/material.dart';

class BatteryGauge extends StatelessWidget {
  final double voltage;

  const BatteryGauge({
    super.key,
    required this.voltage,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (((voltage - 11.5) / (13.2 - 11.5)) * 100)
        .clamp(0.0, 100.0);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Icon(
            Icons.battery_full,
            size: 60,
            color: _color(voltage),
          ),

          const SizedBox(height: 12),

          Text(
            "${voltage.toStringAsFixed(1)} V",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 14,
              backgroundColor: Colors.grey.shade800,
              valueColor: AlwaysStoppedAnimation(_color(voltage)),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "${percent.toStringAsFixed(0)} %",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            _status(voltage),
            style: TextStyle(
              color: _color(voltage),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  static Color _color(double v) {
    if (v >= 12.8) return Colors.green;
    if (v >= 12.3) return Colors.yellow;
    if (v >= 11.8) return Colors.orange;
    return Colors.red;
  }

  static String _status(double v) {
    if (v >= 12.8) return "HEALTHY";
    if (v >= 12.3) return "NORMAL";
    if (v >= 11.8) return "LOW";
    return "CRITICAL";
  }
}
