class TelemetryModel {
  final double rpm;
  final double engineTemp;
  final double battery;
  final double fuel;

  final double accelX;
  final double accelY;
  final double accelZ;

  final double gyroX;
  final double gyroY;
  final double gyroZ;

  final double pitch;
  final double roll;

  final bool brake;
  final bool frontKill;
  final bool rearKill;
  final bool emergencyKill;

  final double latitude;
  final double longitude;
  final double gpsSpeed;
  final int satellites;

  final int timestamp;

  TelemetryModel({
    required this.rpm,
    required this.engineTemp,
    required this.battery,
    required this.fuel,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.pitch,
    required this.roll,
    required this.brake,
    required this.frontKill,
    required this.rearKill,
    required this.emergencyKill,
    required this.latitude,
    required this.longitude,
    required this.gpsSpeed,
    required this.satellites,
    required this.timestamp,
  });

  TelemetryModel copyWith({double? gpsSpeed}) {
    return TelemetryModel(
      rpm: rpm,
      engineTemp: engineTemp,
      battery: battery,
      fuel: fuel,
      accelX: accelX,
      accelY: accelY,
      accelZ: accelZ,
      gyroX: gyroX,
      gyroY: gyroY,
      gyroZ: gyroZ,
      pitch: pitch,
      roll: roll,
      brake: brake,
      frontKill: frontKill,
      rearKill: rearKill,
      emergencyKill: emergencyKill,
      latitude: latitude,
      longitude: longitude,
      gpsSpeed: gpsSpeed ?? this.gpsSpeed,
      satellites: satellites,
      timestamp: timestamp,
    );
  }

  factory TelemetryModel.fromMap(Map<dynamic, dynamic> map) {
  double d(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  int i(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  bool b(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is int) return v != 0;
    return v.toString().toLowerCase() == "true";
  }

  final gps = map["gps"] is Map
      ? Map<dynamic, dynamic>.from(map["gps"])
      : {};

  return TelemetryModel(
    rpm: d(map["rpm"]),
    engineTemp: d(map["engineTemp"]),
    battery: d(map["battery"]),
    fuel: d(map["fuel"]),

    accelX: d(map["accelX"]),
    accelY: d(map["accelY"]),
    accelZ: d(map["accelZ"]),

    gyroX: d(map["gyroX"]),
    gyroY: d(map["gyroY"]),
    gyroZ: d(map["gyroZ"]),

    pitch: d(map["pitch"]),
    roll: d(map["roll"]),

    brake: b(map["brake"]),
    frontKill: b(map["frontKill"]),
    rearKill: b(map["rearKill"]),
    emergencyKill: b(map["emergencyKill"]),

    latitude: d(gps["latitude"]),
    longitude: d(gps["longitude"]),
    gpsSpeed: d(gps["speed"]),
    satellites: i(gps["satellites"]),

    timestamp: i(map["timestamp"]),
  );
}
}
