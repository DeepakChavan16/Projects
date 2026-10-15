import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedGauge extends StatelessWidget {
  final double speed;

  const SpeedGauge({
    super.key,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: [
        RadialAxis(
          minimum: 0,
          maximum: 120,
          interval: 20,
          startAngle: 135,
          endAngle: 45,
          showTicks: true,
          showLabels: true,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.15,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 40,
              color: Colors.green,
            ),
            GaugeRange(
              startValue: 40,
              endValue: 80,
              color: Colors.orange,
            ),
            GaugeRange(
              startValue: 80,
              endValue: 120,
              color: Colors.red,
            ),
          ],
          pointers: [
            NeedlePointer(
              value: speed,
              needleColor: Colors.cyanAccent,
              enableAnimation: true,
              animationDuration: 300,
            ),
          ],
          annotations: [
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.65,
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    speed.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "km/h",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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
}