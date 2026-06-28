import '../features/risk_places/state/risk_place_state.dart';
import '../models/risk_place.dart';
import 'location_service.dart';

class GeofenceService {
  const GeofenceService({
    required this.riskPlaceState,
    required this.locationService,
  });

  final RiskPlaceState riskPlaceState;
  final LocationService locationService;

  Future<List<RiskPlace>> evaluateCurrentLocation() async {
    final location = await locationService.currentLocation();
    if (location == null) {
      return const <RiskPlace>[];
    }
    return riskPlaceState.evaluatePosition(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}
