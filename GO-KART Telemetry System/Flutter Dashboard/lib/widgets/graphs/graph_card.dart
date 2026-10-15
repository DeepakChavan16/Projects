import 'package:flutter/material.dart';

class GraphCard extends StatelessWidget {
  final String title;
  final Widget child;

  const GraphCard({super.key, required this.title, required this.child});

  Color get _accentColor {
    final name = title.toUpperCase();

    if (name.contains('RPM')) {
      return const Color(0xFFFF5252);
    }
    if (name.contains('SPEED')) {
      return const Color(0xFF2196F3);
    }
    if (name.contains('TEMP')) {
      return const Color(0xFFFFA000);
    }
    if (name.contains('BATTERY')) {
      return const Color(0xFF47E87A);
    }
    if (name.contains('FUEL')) {
      return const Color(0xFFFFC107);
    }

    return const Color(0xFF00C8E8);
  }

  IconData get _icon {
    final name = title.toUpperCase();

    if (name.contains('RPM')) {
      return Icons.speed_rounded;
    }
    if (name.contains('SPEED')) {
      return Icons.directions_car_filled_outlined;
    }
    if (name.contains('TEMP')) {
      return Icons.thermostat_outlined;
    }
    if (name.contains('BATTERY')) {
      return Icons.battery_charging_full_rounded;
    }
    if (name.contains('FUEL')) {
      return Icons.local_gas_station_rounded;
    }

    return Icons.insights_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 110;
        final iconSize = compact ? 22.0 : 28.0;

        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF292B33), Color(0xFF1C1D23)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: accent.withOpacity(0.20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              10,
              compact ? 4 : 8,
              10,
              compact ? 4 : 8,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(compact ? 7 : 9),
                      ),
                      child: Icon(
                        _icon,
                        color: accent,
                        size: compact ? 14 : 18,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: compact ? 12 : 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: compact ? 5 : 7,
                        vertical: compact ? 2 : 3,
                      ),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          color: accent,
                          fontSize: compact ? 8 : 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: compact ? 4 : 7),
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
