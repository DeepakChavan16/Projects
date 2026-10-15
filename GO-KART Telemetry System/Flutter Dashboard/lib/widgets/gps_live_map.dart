import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../providers/gps_provider.dart';
import '../providers/telemetry_provider.dart';

class GpsLiveMap extends ConsumerStatefulWidget {
  const GpsLiveMap({super.key});

  @override
  ConsumerState<GpsLiveMap> createState() => _GpsLiveMapState();
}

class _GpsLiveMapState extends ConsumerState<GpsLiveMap> {
  static const _defaultCenter = LatLng(18.5204, 73.8567);

  final MapController _mapController = MapController();
  LatLng? _lastMapCenter;
  LatLng? _currentLocation;
  bool _isFollowingVehicle = true;

  void _followVehicle(LatLng location) {
    _currentLocation = location;
    if (!_isFollowingVehicle) return;

    final previous = _lastMapCenter;
    final hasMoved = previous == null ||
        (previous.latitude - location.latitude).abs() > 0.000001 ||
        (previous.longitude - location.longitude).abs() > 0.000001;

    if (!hasMoved) return;

    _lastMapCenter = location;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _mapController.move(location, 17.5);
    });
  }

  void _resumeFollowing() {
    final location = _currentLocation;
    if (location == null) return;

    setState(() => _isFollowingVehicle = true);
    _lastMapCenter = location;
    _mapController.move(location, 17.5);
  }

  @override
  Widget build(BuildContext context) {
    final track = ref.watch(gpsTrackProvider);
    final telemetry = ref.watch(telemetryProvider).asData?.value;

    LatLng? currentLocation;
    if (telemetry != null &&
        (telemetry.latitude != 0 || telemetry.longitude != 0)) {
      currentLocation = LatLng(telemetry.latitude, telemetry.longitude);
    } else if (track.isNotEmpty) {
      currentLocation = track.last;
    }

    if (currentLocation != null) {
      _followVehicle(currentLocation);
    }

    final initialCenter = currentLocation ?? _defaultCenter;
    final speed = telemetry?.gpsSpeed ?? 0.0;
    final satellites = telemetry?.satellites ?? 0;
    final hasFix = currentLocation != null && satellites > 0;
    final statusColor =
        hasFix ? const Color(0xFF47E87A) : const Color(0xFFFFA000);

    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: currentLocation == null ? 13 : 17.5,
                onPositionChanged: (_, hasGesture) {
                  if (hasGesture && _isFollowingVehicle) {
                    setState(() => _isFollowingVehicle = false);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.fkdc.dashboard',
                ),
                if (track.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: track,
                        strokeWidth: 4,
                        color: const Color(0xFF00C8E8),
                      ),
                    ],
                  ),
                if (currentLocation != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: currentLocation,
                        width: 64,
                        height: 64,
                        child: const _VehicleMarker(),
                      ),
                    ],
                  ),
              ],
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.transparent,
                      Colors.black.withOpacity(0.38),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: _MapPill(
                icon: hasFix
                    ? Icons.gps_fixed_rounded
                    : Icons.gps_not_fixed_rounded,
                label: hasFix ? 'GPS LOCK' : 'WAITING FOR GPS',
                color: statusColor,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _MapPill(
                icon: Icons.satellite_alt_rounded,
                label: '$satellites SAT',
                color: const Color(0xFFAB47BC),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: _SpeedBadge(speed: speed),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _CoordinateBadge(
                location: currentLocation,
                telemetryAvailable: telemetry != null,
              ),
            ),
            if (!_isFollowingVehicle && currentLocation != null)
              Positioned(
                top: 52,
                right: 12,
                child: _FollowButton(onPressed: _resumeFollowing),
              ),
            if (currentLocation == null)
              const _NoGpsOverlay(),
          ],
        ),
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FollowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF15171C).withOpacity(0.94),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF00C8E8).withOpacity(0.5)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.my_location_rounded, color: Color(0xFF00C8E8), size: 15),
              SizedBox(width: 5),
              Text(
                'FOLLOW',
                style: TextStyle(
                  color: Color(0xFF00C8E8),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VehicleMarker extends StatelessWidget {
  const _VehicleMarker();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFF00C8E8).withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF00C8E8).withOpacity(0.65),
                width: 2,
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF1479D1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C8E8).withOpacity(0.75),
                  blurRadius: 14,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.navigation_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MapPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF15171C).withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.32)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 15),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeedBadge extends StatelessWidget {
  final double speed;

  const _SpeedBadge({required this.speed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF15171C).withOpacity(0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF00C8E8).withOpacity(0.35),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'SPEED',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            speed.toStringAsFixed(0),
            style: const TextStyle(
              color: Color(0xFF00C8E8),
              fontSize: 27,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'km/h',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoordinateBadge extends StatelessWidget {
  final LatLng? location;
  final bool telemetryAvailable;

  const _CoordinateBadge({
    required this.location,
    required this.telemetryAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final label = location == null
        ? (telemetryAvailable
            ? 'GPS COORDINATES PENDING'
            : 'GPS TELEMETRY UNAVAILABLE')
        : '${location!.latitude.toStringAsFixed(5)}, '
            '${location!.longitude.toStringAsFixed(5)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF15171C).withOpacity(0.90),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NoGpsOverlay extends StatelessWidget {
  const _NoGpsOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.34),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF15171C).withOpacity(0.94),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFFA000).withOpacity(0.42),
            ),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.gps_off_rounded,
                color: Color(0xFFFFA000),
                size: 34,
              ),
              SizedBox(height: 8),
              Text(
                'WAITING FOR GPS DATA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Connect ESP32 and GPS module',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
