import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FuelGauge extends StatelessWidget {
  final double fuel;

  const FuelGauge({
    super.key,
    required this.fuel,
  });

  @override
  Widget build(BuildContext context) {
    final value = fuel.clamp(0.0, 100.0);
    final liters = (value / 100) * 5.0;

    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 100,
          startAngle: 135,
          endAngle: 45,
          interval: 20,

          axisLineStyle: const AxisLineStyle(
            thickness: 0.14,
            thicknessUnit: GaugeSizeUnit.factor,
          ),

          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 20,
              color: Colors.red,
            ),
            GaugeRange(
              startValue: 20,
              endValue: 40,
              color: Colors.orange,
            ),
            GaugeRange(
              startValue: 40,
              endValue: 75,
              color: Colors.yellow,
            ),
            GaugeRange(
              startValue: 75,
              endValue: 100,
              color: Colors.green,
            ),
          ],

          pointers: [
            NeedlePointer(
              value: value,
              needleColor: Colors.redAccent,
              knobStyle: const KnobStyle(
                color: Colors.white,
              ),
            ),
          ],

          annotations: [
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.70,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    "${value.toStringAsFixed(0)} %",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  Text(
                    "${liters.toStringAsFixed(1)} L",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _status(value),
                    style: TextStyle(
                      color: _color(value),
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

  static Color _color(double fuel) {
    if (fuel >= 75) return Colors.green;
    if (fuel >= 40) return Colors.yellow;
    if (fuel >= 20) return Colors.orange;
    return Colors.red;
  }

  static String _status(double fuel) {
    if (fuel >= 75) return "FULL";
    if (fuel >= 40) return "NORMAL";
    if (fuel >= 20) return "LOW";
    return "RESERVE";
  }
}