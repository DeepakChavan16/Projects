import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/telemetry_model.dart';
import 'dashboard_card.dart';

class IMUPanel extends StatelessWidget {
  final TelemetryModel data;

  const IMUPanel({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final lateralG = data.accelX / 9.81;
    final longitudinalG = data.accelY / 9.81;
    final verticalG = data.accelZ / 9.81;
    final totalG = math.sqrt(
      lateralG * lateralG +
          longitudinalG * longitudinalG +
          verticalG * verticalG,
    );

    return DashboardCard(
      title: 'IMU & G-FORCE',
      compact: true,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _GForcePainter(
                    lateralG: lateralG,
                    longitudinalG: longitudinalG,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _metric('Lat G', lateralG, const Color(0xFF40E0D0)),
                _metric('Long G', longitudinalG, const Color(0xFF42A5F5)),
                _metric('Vert G', verticalG, const Color(0xFFAB47BC)),
                _metric('Total G', totalG, const Color(0xFF47E87A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, double value, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const Spacer(),
        Text(
          '${value.toStringAsFixed(2)} g',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

class _GForcePainter extends CustomPainter {
  final double lateralG;
  final double longitudinalG;

  const _GForcePainter({required this.lateralG, required this.longitudinalG});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.36;
    final ring = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final axis = Paint()
      ..color = Colors.white.withOpacity(0.25)
      ..strokeWidth = 1;
    for (final factor in [1 / 3, 2 / 3, 1.0]) {
      canvas.drawCircle(center, radius * factor, ring);
    }
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      axis,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      axis,
    );

    const limit = 1.5;
    final dot = Offset(
      center.dx + (lateralG.clamp(-limit, limit) / limit) * radius,
      center.dy - (longitudinalG.clamp(-limit, limit) / limit) * radius,
    );
    canvas.drawCircle(
      dot,
      13,
      Paint()
        ..color = const Color(0xFFFF5252).withOpacity(0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    canvas.drawCircle(dot, 8, Paint()..color = const Color(0xFFFF5252));
  }

  @override
  bool shouldRepaint(covariant _GForcePainter oldDelegate) =>
      oldDelegate.lateralG != lateralG ||
      oldDelegate.longitudinalG != longitudinalG;
}
