import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connection_provider.dart';

class TelemetryHeader extends ConsumerWidget {
  const TelemetryHeader({super.key});

  Widget _statusTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: color,
          size: 18,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectionProvider);

    final lastPacket = connection.lastPacketSeconds;

    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF181A20),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade800,
          ),
        ),
      ),
      child: Row(
        children: [
          // =====================================================
          // FKDC LOGO
          // =====================================================

          Image.asset(
            'assets/images/fkdc_logo.png',
            width: 52,
            height: 52,
            fit: BoxFit.contain,
          ),

          const SizedBox(width: 12),

          // =====================================================
          // TITLE + DESIGNER
          // =====================================================

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FKDC TELEMETRY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'Design by Dynamic Booster 8.0',
                style: TextStyle(
                  color: Colors.cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          const Spacer(),

          // =====================================================
          // ESP32
          // =====================================================

          _statusTile(
            icon: Icons.memory,
            color: connection.esp32Online
                ? Colors.green
                : Colors.red,
            title: 'ESP32',
            value: connection.esp32Online
                ? 'ONLINE'
                : 'OFFLINE',
          ),

          const SizedBox(width: 30),

          // =====================================================
          // FIREBASE
          // =====================================================

          _statusTile(
            icon: Icons.cloud_done,
            color: connection.firebaseConnected
                ? Colors.green
                : Colors.red,
            title: 'Firebase',
            value: connection.firebaseConnected
                ? 'CONNECTED'
                : 'DISCONNECTED',
          ),

          const SizedBox(width: 30),

          // =====================================================
          // LAST PACKET
          // =====================================================

          _statusTile(
            icon: Icons.schedule,
            color: Colors.orange,
            title: 'Last Packet',
            value:
                '${lastPacket.toStringAsFixed(1)} s',
          ),

          const SizedBox(width: 30),

          // =====================================================
          // PACKET RATE
          // =====================================================

          _statusTile(
            icon: Icons.network_check,
            color: Colors.cyan,
            title: 'Packet Rate',
            value:
                '${connection.packetRate.toStringAsFixed(1)} Hz',
          ),

          const SizedBox(width: 30),

          // =====================================================
          // PACKETS
          // =====================================================

          _statusTile(
            icon: Icons.inventory_2,
            color: Colors.deepPurpleAccent,
            title: 'Packets',
            value:
                connection.packetCount.toString(),
          ),

          const SizedBox(width: 30),

          // =====================================================
          // CLOCK
          // =====================================================

          const Icon(
            Icons.access_time,
            color: Colors.white70,
          ),

          const SizedBox(width: 8),

          Text(
            TimeOfDay.now().format(context),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}