import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/telemetry_model.dart';
import '../providers/telemetry_provider.dart';
import 'dashboard_card.dart';
import 'racing_speedometer.dart';
import 'rpm_gauge.dart';
import 'temperature_gauge.dart';

class TopDashboard extends ConsumerWidget {
  const TopDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(telemetryProvider).asData?.value;

    if (data == null) return const SizedBox.shrink();

    return SizedBox.expand(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: 'RPM',
              compact: true,
              child: RPMGauge(rpm: data.rpm),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: RacingSpeedometer(
              speed: data.gpsSpeed,
              rpm: data.rpm,
              gear: 3,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: DashboardCard(
              title: 'ENGINE TEMP',
              compact: true,
              child: TemperatureGauge(temperature: data.engineTemp),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 5,
            child: DashboardCard(
              title: 'VEHICLE STATUS',
              compact: true,
              child: _VehicleStatusGrid(data: data),
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleStatusGrid extends StatelessWidget {
  final TelemetryModel data;

  const _VehicleStatusGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final tiles = <_StatusData>[
      _StatusData(
        icon: Icons.battery_charging_full_rounded,
        label: 'Battery',
        value: '${data.battery.toStringAsFixed(1)} V',
        color: const Color(0xFF47E87A),
      ),
      _StatusData(
        icon: Icons.local_gas_station_rounded,
        label: 'Fuel',
        value: '${data.fuel.toStringAsFixed(0)} %',
        color: const Color(0xFFFFA000),
      ),
      _StatusData(
        icon: Icons.speed_rounded,
        label: 'GPS Speed',
        value: '${data.gpsSpeed.toStringAsFixed(1)} km/h',
        color: const Color(0xFF00C8E8),
      ),
      _StatusData(
        icon: Icons.satellite_alt_rounded,
        label: 'Satellites',
        value: data.satellites.toString(),
        color: const Color(0xFF2196F3),
      ),
      _StatusData(
        icon: Icons.car_crash_rounded,
        label: 'Brake',
        value: data.brake ? 'ON' : 'OFF',
        color: data.brake ? const Color(0xFFFF5252) : const Color(0xFF47E87A),
      ),
      _StatusData(
        icon: Icons.warning_amber_rounded,
        label: 'Emergency',
        value: data.emergencyKill ? 'ACTIVE' : 'SAFE',
        color: data.emergencyKill
            ? const Color(0xFFFF5252)
            : const Color(0xFF47E87A),
      ),
      _StatusData(
        icon: Icons.power_settings_new_rounded,
        label: 'Front Kill',
        value: data.frontKill ? 'ON' : 'OFF',
        color: data.frontKill
            ? const Color(0xFFFF5252)
            : const Color(0xFF47E87A),
      ),
      _StatusData(
        icon: Icons.power_settings_new_rounded,
        label: 'Rear Kill',
        value: data.rearKill ? 'ON' : 'OFF',
        color: data.rearKill
            ? const Color(0xFFFF5252)
            : const Color(0xFF47E87A),
      ),
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tiles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.52,
      ),
      itemBuilder: (context, index) => _StatusTile(data: tiles[index]),
    );
  }
}

class _StatusData {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatusData({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _StatusTile extends StatelessWidget {
  final _StatusData data;

  const _StatusTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [data.color.withOpacity(0.14), const Color(0xFF24262D)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: data.color.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: data.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(data.icon, color: data.color, size: 16),
              ),
              const Spacer(),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            data.label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              data.value,
              style: TextStyle(
                color: data.color,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
