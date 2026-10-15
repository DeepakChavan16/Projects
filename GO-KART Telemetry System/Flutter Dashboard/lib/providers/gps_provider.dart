import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class GpsTrackNotifier extends Notifier<List<LatLng>> {
  @override
  List<LatLng> build() => [];

  void addPoint(double latitude, double longitude) {
    if (latitude == 0 && longitude == 0) return;

    final point = LatLng(latitude, longitude);

    // Prevent duplicate consecutive points
    if (state.isNotEmpty && state.last == point) return;

    state = [...state, point];
  }

  void clearTrack() {
    state = [];
  }
}

final gpsTrackProvider =
    NotifierProvider<GpsTrackNotifier, List<LatLng>>(
  GpsTrackNotifier.new,
);