import 'dart:async';

import 'package:geolocator/geolocator.dart';

class CurrentLocation {
  const CurrentLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;
}

class LocationService {
  Future<bool> ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<CurrentLocation?> currentLocation() async {
    if (!await ensurePermission()) {
      return null;
    }
    final position = await Geolocator.getCurrentPosition();
    return CurrentLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMeters: position.accuracy,
    );
  }

  Stream<CurrentLocation> positionStream() async* {
    if (!await ensurePermission()) {
      return;
    }
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 25,
    );
    yield* Geolocator.getPositionStream(locationSettings: settings).map(
      (position) => CurrentLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyMeters: position.accuracy,
      ),
    );
  }
}
