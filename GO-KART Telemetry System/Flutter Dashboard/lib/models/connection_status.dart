class ConnectionStatus {
  final bool esp32Online;
  final bool firebaseConnected;
  final DateTime lastPacketTime;
  final int packetCount;
  final double packetRate;

  const ConnectionStatus({
    required this.esp32Online,
    required this.firebaseConnected,
    required this.lastPacketTime,
    required this.packetCount,
    required this.packetRate,
  });

  ConnectionStatus copyWith({
    bool? esp32Online,
    bool? firebaseConnected,
    DateTime? lastPacketTime,
    int? packetCount,
    double? packetRate,
  }) {
    return ConnectionStatus(
      esp32Online: esp32Online ?? this.esp32Online,
      firebaseConnected:
          firebaseConnected ?? this.firebaseConnected,
      lastPacketTime:
          lastPacketTime ?? this.lastPacketTime,
      packetCount:
          packetCount ?? this.packetCount,
      packetRate:
          packetRate ?? this.packetRate,
    );
  }
}