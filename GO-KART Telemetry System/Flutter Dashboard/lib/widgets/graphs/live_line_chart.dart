import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LiveLineChart extends StatelessWidget {
  final List<double> values;
  final Color lineColor;
  final double minY;
  final double maxY;

  const LiveLineChart({
    super.key,
    required this.values,
    required this.lineColor,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    final chartValues =
        values.length == 1 ? [values.first, values.first] : values;

    final spots = List.generate(
      chartValues.length,
      (index) => FlSpot(
        index.toDouble(),
        chartValues[index],
      ),
    );

    return Stack(
      children: [
        LineChart(
          LineChartData(
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: (maxY - minY) / 5,
              verticalInterval: 10,
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
            ),
            titlesData: const FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                ),
              ),
            ),
            lineBarsData: [
              // Soft glow behind the main trace.
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.24,
                color: lineColor.withOpacity(0.18),
                barWidth: 9,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
              ),

              // Main telemetry trace.
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.24,
                color: lineColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: lineColor.withOpacity(0.13),
                ),
              ),
            ],
          ),
        ),

        if (values.length < 2)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF15161B).withOpacity(0.88),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: lineColor.withOpacity(0.24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.show_chart_rounded,
                    color: lineColor.withOpacity(0.72),
                    size: 16,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'WAITING FOR LIVE DATA',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
