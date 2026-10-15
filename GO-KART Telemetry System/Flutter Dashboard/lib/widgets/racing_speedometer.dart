import 'package:flutter/material.dart';

import 'shift_lights.dart';

class RacingSpeedometer extends StatelessWidget {
  final double speed;
  final double rpm;
  final int gear;

  const RacingSpeedometer({
    super.key,
    required this.speed,
    required this.rpm,
    this.gear = 3,
  });

  String get _gearText {
    if (gear < 0) {
      return 'R';
    }
    if (gear == 0) {
      return 'N';
    }
    return gear.toString();
  }

  @override
  Widget build(BuildContext context) {
    final rpmPercent = (rpm / 8000).clamp(0.0, 1.0);
    final rpmColor = rpmPercent >= 0.92
        ? const Color(0xFFFF5252)
        : rpmPercent >= 0.72
            ? const Color(0xFFFFA000)
            : const Color(0xFF47E87A);

    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF272A32),
              Color(0xFF17191F),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF00C8E8).withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C8E8).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(
                      Icons.speed_rounded,
                      color: Color(0xFF00C8E8),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'DIGITAL SPEED',
                    style: TextStyle(
                      color: Colors.white,
                    fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C8E8).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'KM/H',
                      style: TextStyle(
                        color: Color(0xFF00C8E8),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(end: speed),
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutCubic,
                            builder: (context, animatedSpeed, _) {
                              return Text(
                                animatedSpeed
                                    .clamp(0, 999)
                                    .toStringAsFixed(0)
                                    .padLeft(3, '0'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 70,
                                  fontWeight: FontWeight.w800,
                                  height: 0.9,
                                  letterSpacing: -3,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'km/h',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: rpmColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: rpmColor.withOpacity(0.24),
                              ),
                            ),
                            child: Text(
                              '${rpm.toStringAsFixed(0)} RPM',
                              style: TextStyle(
                                color: rpmColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 86,
                      decoration: BoxDecoration(
                        color: const Color(0xFF11141A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'GEAR',
                            style: TextStyle(
                              color: Colors.white54,
                            fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _gearText,
                            style: const TextStyle(
                              color: Color(0xFF00C8E8),
                            fontSize: 58,
                              fontWeight: FontWeight.w800,
                              height: 0.95,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              ShiftLights(rpm: rpm, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
