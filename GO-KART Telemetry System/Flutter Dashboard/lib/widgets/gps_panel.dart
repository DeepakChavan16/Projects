import 'package:flutter/material.dart';

import '../models/telemetry_model.dart';
import 'dashboard_card.dart';

class GPSPanel extends StatelessWidget {
  final TelemetryModel data;

  const GPSPanel({
    super.key,
    required this.data,
  });

  Widget gpsRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      title: "GPS",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gpsRow("Latitude", data.latitude.toStringAsFixed(6)),
          gpsRow("Longitude", data.longitude.toStringAsFixed(6)),
          gpsRow("Speed", "${data.gpsSpeed.toStringAsFixed(1)} km/h"),
          gpsRow("Satellites", data.satellites.toString()),
          const Spacer(),
        ],
      ),
    );
  }
}