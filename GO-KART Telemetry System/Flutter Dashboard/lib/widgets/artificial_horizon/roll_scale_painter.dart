import 'dart:math' as math;
import 'package:flutter/material.dart';

class RollScalePainter extends CustomPainter {
  final double roll;

  const RollScalePainter({
    required this.roll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw roll scale
    for (double angle = -60; angle <= 60; angle += 10) {
      final rad = (angle - 90) * math.pi / 180;

      final outer = Offset(
        center.dx + radius * math.cos(rad),
        center.dy + radius * math.sin(rad),
      );

      final inner = Offset(
        center.dx + (radius - (angle % 30 == 0 ? 14 : 8)) * math.cos(rad),
        center.dy + (radius - (angle % 30 == 0 ? 14 : 8)) * math.sin(rad),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = Colors.white
          ..strokeWidth = angle % 30 == 0 ? 3 : 2,
      );

      // Degree labels
      if (angle != 0 && angle % 30 == 0) {
        final label = angle.abs().toInt().toString();

        final tp = TextPainter(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        tp.layout();

        final labelRadius = radius - 28;

        final pos = Offset(
          center.dx +
              labelRadius * math.cos(rad) -
              tp.width / 2,
          center.dy +
              labelRadius * math.sin(rad) -
              tp.height / 2,
        );

        tp.paint(canvas, pos);
      }
    }

    // Orange roll pointer
    final pointer = Path();

    pointer.moveTo(center.dx, 10);
    pointer.lineTo(center.dx - 8, 24);
    pointer.lineTo(center.dx + 8, 24);
    pointer.close();

    canvas.drawPath(
      pointer,
      Paint()..color = Colors.orangeAccent,
    );
  }

  @override
  bool shouldRepaint(covariant RollScalePainter oldDelegate) {
    return oldDelegate.roll != roll;
  }
}