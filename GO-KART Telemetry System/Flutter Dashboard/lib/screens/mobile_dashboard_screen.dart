import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/telemetry_provider.dart';

class MobileDashboardScreen extends ConsumerWidget {
  const MobileDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final telemetryAsync = ref.watch(telemetryProvider);

    return telemetryAsync.when(
      data: (telemetry) {
        return Scaffold(
          backgroundColor: const Color(0xFF111216),

          appBar: AppBar(
            backgroundColor: const Color(0xFF1A1C22),
            elevation: 0,
            title: const Text(
              'FKDC TELEMETRY',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    "ESP32 🟢",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),

            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,

              children: [
                _TelemetryCard(
                  "Speed",
                  "${telemetry.gpsSpeed.toStringAsFixed(1)} km/h",
                ),

                _TelemetryCard(
                  "RPM",
                  telemetry.rpm.toStringAsFixed(0),
                ),

                _TelemetryCard(
                  "Engine Temp",
                  "${telemetry.engineTemp.toStringAsFixed(1)} °C",
                ),

                _TelemetryCard(
                  "Battery",
                  "${telemetry.battery.toStringAsFixed(1)} V",
                ),

                _TelemetryCard(
                  "Fuel",
                  "${telemetry.fuel.toStringAsFixed(0)} %",
                ),

                _TelemetryCard(
                  "GPS",
                  "${telemetry.satellites} SAT",
                ),
              ],
            ),
          ),
        );
      },

      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _TelemetryCard extends StatelessWidget {
  final String title;
  final String value;

  const _TelemetryCard(
    this.title,
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1F26),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}