import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureGauge extends StatelessWidget {
  final double temperature;

  const TemperatureGauge({
    super.key,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 20,
          maximum: 220,
          interval: 20,
          startAngle: 135,
          endAngle: 45,
          showTicks: true,
          showLabels: true,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.14,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          ranges: [
            GaugeRange(
              startValue: 20,
              endValue: 80,
              color: Colors.blue,
            ),
            GaugeRange(
              startValue: 80,
              endValue: 120,
              color: Colors.green,
            ),
            GaugeRange(
              startValue: 120,
              endValue: 160,
              color: Colors.lightGreen,
            ),
            GaugeRange(
              startValue: 160,
              endValue: 180,
              color: Colors.yellow,
            ),
            GaugeRange(
              startValue: 180,
              endValue: 200,
              color: Colors.orange,
            ),
            GaugeRange(
              startValue: 200,
              endValue: 220,
              color: Colors.red,
            ),
          ],
          pointers: [
            NeedlePointer(
              value: temperature,
              needleColor: Colors.redAccent,
              knobStyle: const KnobStyle(
                color: Colors.white,
              ),
            ),
          ],
          annotations: [
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.72,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${temperature.toStringAsFixed(0)} °C",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _status(temperature),
                    style: TextStyle(
                      color: _statusColor(temperature),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _status(double t) {
    if (t < 80) return "COLD";
    if (t < 160) return "NORMAL";
    if (t < 180) return "HIGH";
    if (t < 200) return "WARNING";
    return "CRITICAL";
  }

  static Color _statusColor(double t) {
    if (t < 80) return Colors.blue;
    if (t < 160) return Colors.green;
    if (t < 180) return Colors.yellow;
    if (t < 200) return Colors.orange;
    return Colors.red;
  }
}