import 'dart:math' as math;
import 'package:flutter/material.dart';

class HorizonPainter extends CustomPainter {
  final double pitch;
  final double roll;

  const HorizonPainter({
    required this.pitch,
    required this.roll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Circular clipping
    canvas.save();
    canvas.clipPath(
      Path()
        ..addOval(
          Rect.fromCircle(
            center: center,
            radius: radius,
          ),
        ),
    );

    // Move to center
    canvas.translate(center.dx, center.dy);

    // Rotate for roll
    canvas.rotate(roll * math.pi / 180);

    // Move for pitch
    canvas.translate(0, pitch * 4);

    // Sky
    final skyPaint = Paint()
      ..color = const Color(0xFF3F8CFF);

    canvas.drawRect(
      Rect.fromLTWH(
        -radius * 3,
        -radius * 3,
        radius * 6,
        radius * 3,
      ),
      skyPaint,
    );

    // Ground
    final groundPaint = Paint()
      ..color = const Color(0xFF8B5A2B);

    canvas.drawRect(
      Rect.fromLTWH(
        -radius * 3,
        0,
        radius * 6,
        radius * 3,
      ),
      groundPaint,
    );

    // Horizon line
    final horizonPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(-radius * 3, 0),
      Offset(radius * 3, 0),
      horizonPaint,
    );

    canvas.restore();

    // Outer bezel
    final bezel = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..color = const Color(0xFF555555);

    canvas.drawCircle(
      center,
      radius - 3,
      bezel,
    );

    // Inner bezel
    final inner = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black87;

    canvas.drawCircle(
      center,
      radius - 10,
      inner,
    );
  }

  @override
  bool shouldRepaint(HorizonPainter oldDelegate) {
    return oldDelegate.pitch != pitch ||
        oldDelegate.roll != roll;
  }
}