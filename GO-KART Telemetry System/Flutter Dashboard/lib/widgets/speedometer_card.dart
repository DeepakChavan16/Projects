import 'package:flutter/material.dart';

class SpeedometerCard extends StatelessWidget {
  final double speed;

  const SpeedometerCard({
    super.key,
    required this.speed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "SPEED",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              speed.toStringAsFixed(0).padLeft(3, '0'),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const Text(
              "km/h",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}