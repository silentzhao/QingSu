import 'package:flutter/widgets.dart';

import '../../../models/risk_place.dart';
import '../../../utils/geo_utils.dart';
import '../data/risk_place_store.dart';

typedef RiskPlaceTriggerHandler = Future<void> Function(RiskPlace place);
typedef RiskPlaceClock = DateTime Function();

class RiskPlaceState extends ChangeNotifier {
  RiskPlaceState({
    required RiskPlaceStore store,
    RiskPlaceTriggerHandler? onTriggered,
    RiskPlaceClock? clock,
  })  : _store = store,
        _onTriggered = onTriggered,
        _clock = clock ?? DateTime.now {
    _restore();
  }

  static const triggerCooldown = Duration(minutes: 30);

  final RiskPlaceStore _store;
  final RiskPlaceTriggerHandler? _onTriggered;
  final RiskPlaceClock _clock;

  bool _ready = false;
  final List<RiskPlace> _places = <RiskPlace>[];

  bool get ready => _ready;

  List<RiskPlace> get places => List<RiskPlace>.unmodifiable(_places);

  List<RiskPlace> get enabledPlaces =>
      _places.where((place) => place.enabled).toList(growable: false);

  RiskPlace? placeById(String id) {
    final index = _places.indexWhere((place) => place.id == id);
    if (index < 0) {
      return null;
    }
    return _places[index];
  }

  Future<void> _restore() async {
    _places
      ..clear()
      ..addAll(await _store.loadRiskPlaces());
    _ready = true;
    notifyListeners();
  }

  Future<void> upsertPlace(RiskPlace place) async {
    final index = _places.indexWhere((candidate) => candidate.id == place.id);
    if (index < 0) {
      _places.insert(0, place);
    } else {
      _places[index] = place;
    }
    await _persistAndNotify();
  }

  Future<void> deletePlace(String id) async {
    _places.removeWhere((place) => place.id == id);
    await _persistAndNotify();
  }

  Future<void> togglePlace(String id, bool enabled) async {
    final index = _places.indexWhere((place) => place.id == id);
    if (index < 0) {
      return;
    }
    _places[index] = _places[index].copyWith(enabled: enabled);
    await _persistAndNotify();
  }

  Future<List<RiskPlace>> evaluatePosition({
    required double latitude,
    required double longitude,
  }) async {
    final triggered = <RiskPlace>[];
    for (var index = 0; index < _places.length; index += 1) {
      final place = _places[index];
      if (!place.enabled || !_isInside(place, latitude, longitude)) {
        continue;
      }
      if (!_canTrigger(place)) {
        continue;
      }
      final updated = place.copyWith(lastTriggeredAt: _clock());
      _places[index] = updated;
      triggered.add(updated);
      await _onTriggered?.call(updated);
    }
    if (triggered.isNotEmpty) {
      await _persistAndNotify();
    }
    return List<RiskPlace>.unmodifiable(triggered);
  }

  bool _isInside(RiskPlace place, double latitude, double longitude) {
    return isInsideRadius(
      fromLatitude: latitude,
      fromLongitude: longitude,
      targetLatitude: place.latitude,
      targetLongitude: place.longitude,
      radiusMeters: place.radiusMeters,
    );
  }

  bool _canTrigger(RiskPlace place) {
    final lastTriggeredAt = place.lastTriggeredAt;
    if (lastTriggeredAt == null) {
      return true;
    }
    return _clock().difference(lastTriggeredAt) >= triggerCooldown;
  }

  Future<void> _persistAndNotify() async {
    await _store.saveRiskPlaces(_places);
    notifyListeners();
  }
}

class RiskPlaceStateScope extends InheritedNotifier<RiskPlaceState> {
  const RiskPlaceStateScope({
    required RiskPlaceState notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static RiskPlaceState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RiskPlaceStateScope>();
    assert(scope != null, 'RiskPlaceStateScope not found in context');
    return scope!.notifier!;
  }

  static RiskPlaceState read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<RiskPlaceStateScope>();
    final scope = element?.widget as RiskPlaceStateScope?;
    assert(scope != null, 'RiskPlaceStateScope not found in context');
    return scope!.notifier!;
  }
}
