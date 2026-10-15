import 'dart:math' as math;
import 'package:flutter/material.dart';

class ArtificialHorizon extends StatelessWidget {
  final double pitch;
  final double roll;

  const ArtificialHorizon({
    super.key,
    required this.pitch,
    required this.roll,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: roll),
        duration: const Duration(milliseconds: 40),
        curve: Curves.easeOutCubic,
        builder: (context, animatedRoll, _) {
          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: pitch),
            duration: const Duration(milliseconds: 40),
            curve: Curves.easeOutCubic,
            builder: (context, animatedPitch, _) {
              return AspectRatio(
                aspectRatio: 1,
                child: CustomPaint(
                  painter: _ArtificialHorizonPainter(
                    pitch: animatedPitch,
                    roll: animatedRoll,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ArtificialHorizonPainter extends CustomPainter {
  final double pitch;
  final double roll;

  _ArtificialHorizonPainter({
    required this.pitch,
    required this.roll,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    final instrumentRect = Rect.fromCircle(center: center, radius: radius);
    final danger =
    roll.abs() > 25 || pitch.abs() > 15;
    final clipPath = Path()..addOval(instrumentRect);

    // Soft blue glow outside the instrument.
    canvas.drawCircle(
      center,
      radius + 4,
      Paint()
        ..color = danger
        ? Colors.red.withOpacity(0.22)
        : const Color(0xFF42A5F5).withOpacity(0.12)
    ..maskFilter = const MaskFilter.blur(
      BlurStyle.normal,
      8,
    ),
);

    // Moving sky, ground, horizon, and pitch ladder.
    canvas.save();
    canvas.clipPath(clipPath);
    canvas.translate(center.dx, center.dy);
    canvas.rotate(roll * math.pi / 180);
    canvas.translate(0, pitch * 1.6);

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF62A5E0),
          Color(0xFF286FA9),
        ],
      ).createShader(
        Rect.fromLTWH(-radius * 2, -radius * 2, radius * 4, radius * 2),
      );

    canvas.drawRect(
      Rect.fromLTWH(-radius * 2, -radius * 2, radius * 4, radius * 2),
      skyPaint,
    );

    final groundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF76513A),
          Color(0xFF2A211D),
        ],
      ).createShader(
        Rect.fromLTWH(-radius * 2, 0, radius * 4, radius * 2),
      );

    canvas.drawRect(
      Rect.fromLTWH(-radius * 2, 0, radius * 4, radius * 2),
      groundPaint,
    );

    // Horizon-line shadow.
    canvas.drawLine(
      Offset(-radius * 2, 2),
      Offset(radius * 2, 2),
      Paint()
        ..color = Colors.black.withOpacity(0.38)
        ..strokeWidth = 7
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Main horizon line.
    canvas.drawLine(
      Offset(-radius * 2, 0),
      Offset(radius * 2, 0),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    _drawPitchLadder(canvas);

    canvas.restore();

    // Subtle reflection on the glass.
    canvas.save();
    canvas.clipPath(clipPath);

    final reflectionPath = Path()
      ..moveTo(center.dx - radius, center.dy - radius)
      ..lineTo(center.dx + radius, center.dy - radius)
      ..lineTo(center.dx + radius * 0.56, center.dy - radius * 0.18)
      ..quadraticBezierTo(
        center.dx,
        center.dy - radius * 0.48,
        center.dx - radius * 0.68,
        center.dy - radius * 0.08,
      )
      ..close();

    canvas.drawPath(
      reflectionPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(instrumentRect),
    );

    canvas.restore();

    _drawBezel(canvas, center, radius, instrumentRect);
    _drawRollMarks(canvas, center, radius);
    _drawTopPointer(canvas, center, radius);
    _drawAircraftReference(canvas, center);
  }

  void _drawPitchLadder(Canvas canvas) {
    final ladderPaint = Paint()
      ..color = Colors.white.withOpacity(0.82)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
    );

    for (int degrees = -30; degrees <= 30; degrees += 10) {
      if (degrees == 0) {
        continue;
      }

      final y = -degrees * 2.1;
      final distance = degrees.abs();

      final outerLength = distance == 10
          ? 60.0
          : distance == 20
              ? 51.0
              : 42.0;

      const numberGap = 19.0;

      // Left and right parts of the pitch line.
      canvas.drawLine(
        Offset(-outerLength, y),
        Offset(-numberGap, y),
        ladderPaint,
      );

      canvas.drawLine(
        Offset(numberGap, y),
        Offset(outerLength, y),
        ladderPaint,
      );

      // Each pitch number is displayed once, in the centre.
      final label = TextPainter(
        text: TextSpan(
          text: degrees.toString(),
          style: labelStyle,
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      label.paint(
        canvas,
        Offset(-label.width / 2, y - label.height / 2),
      );
    }
  }

  void _drawBezel(
    Canvas canvas,
    Offset center,
    double radius,
    Rect instrumentRect,
  ) {
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD4DCE3),
            Color(0xFF68737C),
            Color(0xFF20262B),
            Color(0xFF090C0E),
          ],
          stops: [0.0, 0.28, 0.66, 1.0],
        ).createShader(instrumentRect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9,
    );

    // Inner dark edge.
    canvas.drawCircle(
      center,
      radius - 5,
      Paint()
        ..color = Colors.black.withOpacity(0.48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Thin cyan upper highlight.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius + 1),
      math.pi * 1.12,
      math.pi * 0.76,
      false,
      Paint()
        ..color = const Color(0xFF81D4FA).withOpacity(0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  void _drawRollMarks(Canvas canvas, Offset center, double radius) {
    for (int angle = -60; angle <= 60; angle += 10) {
      final radians = (angle - 90) * math.pi / 180;
      final isMajorMark = angle % 30 == 0;
      final length = isMajorMark ? 16.0 : 10.0;

      final outer = Offset(
        center.dx + math.cos(radians) * (radius - 2),
        center.dy + math.sin(radians) * (radius - 2),
      );

      final inner = Offset(
        center.dx + math.cos(radians) * (radius - length),
        center.dy + math.sin(radians) * (radius - length),
      );

      canvas.drawLine(
        outer,
        inner,
        Paint()
          ..color = Colors.white.withOpacity(isMajorMark ? 0.96 : 0.68)
          ..strokeWidth = isMajorMark ? 2.3 : 1.5
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawTopPointer(Canvas canvas, Offset center, double radius) {
    final pointer = Path()
      ..moveTo(center.dx, center.dy - radius + 8)
      ..lineTo(center.dx - 9, center.dy - radius + 24)
      ..lineTo(center.dx + 9, center.dy - radius + 24)
      ..close();

    canvas.drawPath(
      pointer.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );

    canvas.drawPath(
      pointer,
      Paint()..color = const Color(0xFFFF9F1C),
    );
  }

  void _drawAircraftReference(Canvas canvas, Offset center) {
    final glowPaint = Paint()
      ..color = const Color(0xFF80D8FF).withOpacity(0.30)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    canvas.drawLine(
      Offset(center.dx - 46, center.dy),
      Offset(center.dx + 46, center.dy),
      glowPaint,
    );

    final referencePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(center.dx - 46, center.dy),
      Offset(center.dx + 46, center.dy),
      referencePaint,
    );

    canvas.drawLine(
      Offset(center.dx, center.dy - 10),
      Offset(center.dx, center.dy + 10),
      referencePaint,
    );

    canvas.drawCircle(
      center,
      5,
      Paint()..color = Colors.white,
    );

    canvas.drawCircle(
      center,
      2,
      Paint()..color = const Color(0xFF1C252B),
    );
  }

  @override
  bool shouldRepaint(covariant _ArtificialHorizonPainter oldDelegate) {
    return oldDelegate.pitch != pitch || oldDelegate.roll != roll;
  }
}
