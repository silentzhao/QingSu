import 'dart:math' as math;

const double _earthRadiusMeters = 6371000;

double distanceInMeters({
  required double fromLatitude,
  required double fromLongitude,
  required double toLatitude,
  required double toLongitude,
}) {
  final fromLat = _degreesToRadians(fromLatitude);
  final toLat = _degreesToRadians(toLatitude);
  final deltaLat = _degreesToRadians(toLatitude - fromLatitude);
  final deltaLng = _degreesToRadians(toLongitude - fromLongitude);

  final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(fromLat) *
          math.cos(toLat) *
          math.sin(deltaLng / 2) *
          math.sin(deltaLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return _earthRadiusMeters * c;
}

bool isInsideRadius({
  required double fromLatitude,
  required double fromLongitude,
  required double targetLatitude,
  required double targetLongitude,
  required int radiusMeters,
}) {
  return distanceInMeters(
        fromLatitude: fromLatitude,
        fromLongitude: fromLongitude,
        toLatitude: targetLatitude,
        toLongitude: targetLongitude,
      ) <=
      radiusMeters;
}

String formatCoordinate(double value) => value.toStringAsFixed(6);

double _degreesToRadians(double degrees) => degrees * math.pi / 180;
