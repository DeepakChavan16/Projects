import 'dart:convert';
import 'dart:html' as html;

import 'package:csv/csv.dart';

import '../models/telemetry_model.dart';

/// CSV logger used by browsers. The CSV is kept in memory until logging stops,
/// when the browser downloads it as a file.
class CsvLoggerService {
  final List<String> _rows = [];
  bool _isLogging = false;
  String _fileName = 'FKDC_Telemetry.csv';

  bool get isLogging => _isLogging;

  Future<String> startLogging() async {
    if (_isLogging) return 'Browser: $_fileName';

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    _fileName = 'FKDC_Telemetry_$timestamp.csv';
    _rows
      ..clear()
      ..add(const ListToCsvConverter().convert([_header]));
    _isLogging = true;

    return 'Browser: $_fileName';
  }

  Future<void> logTelemetry(TelemetryModel data) async {
    if (!_isLogging) return;
    _rows.add(const ListToCsvConverter().convert([_rowFor(data)]));
  }

  Future<void> stopLogging() async {
    if (!_isLogging) return;
    _isLogging = false;

    if (_rows.length <= 1) return;

    final blob = html.Blob(
      [utf8.encode('${_rows.join('\n')}\n')],
      'text/csv;charset=utf-8',
    );
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..download = _fileName
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
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
