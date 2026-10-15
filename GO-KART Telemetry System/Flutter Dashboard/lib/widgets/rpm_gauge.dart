import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RPMGauge extends StatelessWidget {
  final double rpm;

  const RPMGauge({super.key, required this.rpm});

  @override
  Widget build(BuildContext context) {
    final value = rpm.clamp(0.0, 8000.0).toDouble();
    final color = value >= 7200
        ? const Color(0xFFFF5252)
        : value >= 6000
        ? const Color(0xFFFFA000)
        : const Color(0xFF47E87A);

    return Column(
      children: [
        Expanded(
          child: SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 8000,
                interval: 1000,
                startAngle: 135,
                endAngle: 45,
                canScaleToFit: true,
                showTicks: true,
                showLabels: true,
                minorTicksPerInterval: 4,
                axisLabelStyle: const GaugeTextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                axisLineStyle: const AxisLineStyle(
                  thickness: 0.12,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Color(0xFF30343C),
                ),
                ranges: [
                  GaugeRange(
                    startValue: 0,
                    endValue: 4500,
                    color: const Color(0xFF47E87A),
                    startWidth: 0.12,
                    endWidth: 0.12,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 4500,
                    endValue: 6000,
                    color: const Color(0xFFFFD740),
                    startWidth: 0.12,
                    endWidth: 0.12,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 6000,
                    endValue: 7200,
                    color: const Color(0xFFFFA000),
                    startWidth: 0.12,
                    endWidth: 0.12,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                  GaugeRange(
                    startValue: 7200,
                    endValue: 8000,
                    color: const Color(0xFFFF5252),
                    startWidth: 0.12,
                    endWidth: 0.12,
                    sizeUnit: GaugeSizeUnit.factor,
                  ),
                ],
                pointers: [
                  NeedlePointer(
                    value: value,
                    needleColor: color,
                    needleLength: 0.72,
                    needleStartWidth: 1,
                    needleEndWidth: 5,
                    enableAnimation: true,
                    animationDuration: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toStringAsFixed(0),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              'RPM',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
