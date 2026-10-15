import 'package:flutter/material.dart';

class ShiftLights extends StatelessWidget {
  final double rpm;
  final double maxRpm;
  final bool compact;

  const ShiftLights({
    super.key,
    required this.rpm,
    this.maxRpm = 8000,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (rpm / maxRpm).clamp(0.0, 1.0);

    final flashing = rpm >= 7500;

    return Column(
      children: [
        Text(
          "SHIFT LIGHTS",
          style: TextStyle(
            color: Colors.white70,
            fontSize: compact ? 10 : 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        SizedBox(height: compact ? 5 : 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(8, (index) {
            final active = percent >= ((index + 1) / 8);

            Color ledColor;

            if (index < 4) {
              ledColor = Colors.green;
            } else if (index < 6) {
              ledColor = Colors.orange;
            } else {
              ledColor = Colors.red;
            }

            final isBlinkOn =
                !flashing || DateTime.now().millisecond < 500;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.symmetric(horizontal: compact ? 2 : 3),

              width: compact ? 18 : 24,
              height: compact ? 10 : 14,

              decoration: BoxDecoration(
                color: active
                    ? (flashing && index >= 6
                        ? (isBlinkOn
                            ? Colors.redAccent
                            : Colors.black)
                        : ledColor)
                    : const Color(0xFF2E2E2E),

                borderRadius: BorderRadius.circular(5),

                border: Border.all(
                  color: Colors.white10,
                ),

                boxShadow: active
                    ? [
                        BoxShadow(
                          color: ledColor.withOpacity(0.95),
                          blurRadius: 22,
                          spreadRadius: 4,
                        ),
                      ]
                    : [],
              ),
            );
          }),
        ),
      ],
    );
  }
}
