import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/risk_place.dart';

abstract class RiskPlaceStore {
  Future<List<RiskPlace>> loadRiskPlaces();

  Future<void> saveRiskPlaces(List<RiskPlace> places);
}

class SharedPrefsRiskPlaceStore implements RiskPlaceStore {
  const SharedPrefsRiskPlaceStore();

  static const _riskPlacesKey = 'risk_places_json';

  @override
  Future<List<RiskPlace>> loadRiskPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_riskPlacesKey);
    if (raw == null || raw.isEmpty) {
      return const <RiskPlace>[];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .whereType<Map<String, Object?>>()
        .map(RiskPlace.fromJson)
        .toList(growable: false);
  }

  @override
  Future<void> saveRiskPlaces(List<RiskPlace> places) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      places.map((place) => place.toJson()).toList(growable: false),
    );
    await prefs.setString(_riskPlacesKey, encoded);
  }
}
