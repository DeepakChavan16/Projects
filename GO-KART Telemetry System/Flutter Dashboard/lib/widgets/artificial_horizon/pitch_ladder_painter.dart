import 'dart:math' as math;
import 'package:flutter/material.dart';

class PitchLadderPainter extends CustomPainter {
  final double pitch;
  final double roll;

  const PitchLadderPainter({
    required this.pitch,
    required this.roll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();

    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(
            center: center,
            radius: radius - 10,
          ),
        ),
    );

    canvas.translate(center.dx, center.dy);

    canvas.rotate(roll * math.pi / 180);

    canvas.translate(0, pitch * 4);

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    const double spacing = 18;

    for (int deg = -30; deg <= 30; deg += 10) {
      if (deg == 0) continue;

      final y = -deg * spacing / 10;

      // Pitch line
      canvas.drawLine(
        const Offset(-35, 0),
        const Offset(35, 0),
        linePaint,
      );

      canvas.save();
      canvas.translate(0, y);

      canvas.drawLine(
        const Offset(-35, 0),
        const Offset(35, 0),
        linePaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: "${deg.abs()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(-55, -7),
      );

      textPainter.paint(
        canvas,
        Offset(42, -7),
      );

      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(PitchLadderPainter oldDelegate) {
    return oldDelegate.pitch != pitch ||
        oldDelegate.roll != roll;
  }
}