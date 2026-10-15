import 'package:flutter/material.dart';

class AircraftSymbolPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final wingPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final nosePaint = Paint()
      ..color = Colors.orangeAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Left Wing
    canvas.drawLine(
      Offset(center.dx - 45, center.dy),
      Offset(center.dx - 10, center.dy),
      wingPaint,
    );

    // Right Wing
    canvas.drawLine(
      Offset(center.dx + 10, center.dy),
      Offset(center.dx + 45, center.dy),
      wingPaint,
    );

    // Aircraft Body
    canvas.drawLine(
      Offset(center.dx, center.dy - 12),
      Offset(center.dx, center.dy + 12),
      wingPaint,
    );

    // Nose
    canvas.drawCircle(
      center,
      3,
      Paint()..color = Colors.orangeAccent,
    );

    // Center Marker
    canvas.drawCircle(
      center,
      8,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant AircraftSymbolPainter oldDelegate) {
    return false;
  }
}