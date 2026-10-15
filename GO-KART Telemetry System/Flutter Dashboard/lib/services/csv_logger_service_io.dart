import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../models/telemetry_model.dart';

/// CSV logger used by desktop platforms such as Windows.
class CsvLoggerService {
  IOSink? _sink;
  String? _filePath;

  bool get isLogging => _sink != null;

  Future<String> startLogging() async {
    if (_sink != null) return _filePath!;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final file = File(
      '${documentsDirectory.path}${Platform.pathSeparator}'
      'FKDC_Telemetry_$timestamp.csv',
    );

    _sink = file.openWrite();
    _filePath = file.path;
    _sink!.writeln(const ListToCsvConverter().convert([_header]));

    return _filePath!;
  }

  Future<void> logTelemetry(TelemetryModel data) async {
    final sink = _sink;
    if (sink == null) return;

    sink.writeln(const ListToCsvConverter().convert([_rowFor(data)]));
  }

  Future<void> stopLogging() async {
    final sink = _sink;
    if (sink == null) return;

    _sink = null;
    await sink.flush();
    await sink.close();
  }
}

const _header = [
  'Timestamp', 'RPM', 'Engine Temp', 'Battery', 'Fuel',
  'Accel X', 'Accel Y', 'Accel Z', 'Gyro X', 'Gyro Y', 'Gyro Z',
  'Pitch', 'Roll', 'Brake', 'Front Kill', 'Rear Kill', 'Emergency Kill',
  'Latitude', 'Longitude', 'GPS Speed', 'Satellites',
];

List<dynamic> _rowFor(TelemetryModel data) => [
      DateTime.now().toIso8601String(),
      data.rpm, data.engineTemp, data.battery, data.fuel,
      data.accelX, data.accelY, data.accelZ,
      data.gyroX, data.gyroY, data.gyroZ,
      data.pitch, data.roll,
      data.brake, data.frontKill, data.rearKill, data.emergencyKill,
      data.latitude, data.longitude, data.gpsSpeed, data.satellites,
    ];
