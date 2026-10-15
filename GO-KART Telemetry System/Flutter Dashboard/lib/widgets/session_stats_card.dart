import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/telemetry_provider.dart';

class SessionStatsCard extends ConsumerStatefulWidget {
  const SessionStatsCard({super.key});

  @override
  ConsumerState<SessionStatsCard> createState() => _SessionStatsCardState();
}

class _SessionStatsCardState extends ConsumerState<SessionStatsCard> {
  double _maxRpm = 0;
  double _maxSpeed = 0;
  double _maxTemp = 0;
  int _packets = 0;

  Object? _lastPacket;
  late final DateTime _startTime;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _recordPacket(dynamic data) {
    if (identical(_lastPacket, data)) {
      return;
    }

    _lastPacket = data;
    _packets++;

    if (data.rpm > _maxRpm) {
      _maxRpm = data.rpm;
    }

    if (data.gpsSpeed > _maxSpeed) {
      _maxSpeed = data.gpsSpeed;
    }

    if (data.engineTemp > _maxTemp) {
      _maxTemp = data.engineTemp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final telemetry = ref.watch(telemetryProvider);

    // The provider rebuilds this widget for every fresh telemetry packet.
    // Keeping the previous object prevents the one-second clock refresh from
    // counting the same packet more than once.
    telemetry.whenData(_recordPacket);

    final runtime = DateTime.now().difference(_startTime);
    final runtimeText = _formatRuntime(runtime);

    final stats = <_SessionStatData>[
      _SessionStatData(
        icon: Icons.timer_outlined,
        label: 'Runtime',
        value: runtimeText,
        color: const Color(0xFF00C8E8),
      ),
      _SessionStatData(
        icon: Icons.inventory_2_outlined,
        label: 'Packets',
        value: _packets.toString(),
        color: const Color(0xFF9C4DFF),
      ),
      _SessionStatData(
        icon: Icons.speed_rounded,
        label: 'Max RPM',
        value: _maxRpm.toStringAsFixed(0),
        color: const Color(0xFFFFA000),
      ),
      _SessionStatData(
        icon: Icons.directions_car_filled_outlined,
        label: 'Max Speed',
        value: '${_maxSpeed.toStringAsFixed(1)} km/h',
        color: const Color(0xFF2196F3),
      ),
      _SessionStatData(
        icon: Icons.thermostat_outlined,
        label: 'Max Temp',
        value: '${_maxTemp.toStringAsFixed(1)} °C',
        color: const Color(0xFFFF5252),
      ),
    ];

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF202127),
              Color(0xFF191A20),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.06),
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWideLayout = constraints.maxWidth >= 900;
              final cardWidth = isWideLayout
                  ? (constraints.maxWidth - 64) / 5
                  : (constraints.maxWidth - 14) / 2;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.query_stats_rounded,
                        color: Color(0xFF00C8E8),
                        size: 22,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'SESSION STATISTICS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 14,
                    children: stats
                        .map(
                          (stat) => SizedBox(
                            width: cardWidth,
                            child: _SessionStatTile(stat: stat),
                          ),
                        )
                        .toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatRuntime(Duration runtime) {
    final hours = runtime.inHours.toString().padLeft(2, '0');
    final minutes = (runtime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (runtime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class _SessionStatData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SessionStatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _SessionStatTile extends StatelessWidget {
  final _SessionStatData stat;

  const _SessionStatTile({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF292B33),
            Color(0xFF202126),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: stat.color.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: stat.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(stat.icon, color: stat.color, size: 21),
          ),
          const SizedBox(height: 9),
          Text(
            stat.label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: TextStyle(
                color: stat.color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
