import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/risk_place.dart';
import '../../../services/location_service.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/common_widgets.dart';
import '../state/risk_place_state.dart';
import 'arrival_reminder_page.dart';
import 'place_picker_page.dart';
import 'risk_place_edit_page.dart';

class RiskPlaceListPage extends StatefulWidget {
  const RiskPlaceListPage({super.key});

  @override
  State<RiskPlaceListPage> createState() => _RiskPlaceListPageState();
}

class _RiskPlaceListPageState extends State<RiskPlaceListPage> {
  final LocationService _locationService = LocationService();
  StreamSubscription<CurrentLocation>? _positionSubscription;
  bool _monitoring = false;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleMonitoring() async {
    if (_monitoring) {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      if (mounted) {
        setState(() => _monitoring = false);
      }
      return;
    }
    final hasPermission = await _locationService.ensurePermission();
    if (!mounted) {
      return;
    }
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('定位权限未开启，无法启动位置提醒')),
      );
      return;
    }
    final riskPlaceState = RiskPlaceStateScope.read(context);
    _positionSubscription = _locationService.positionStream().listen(
      (location) async {
        final triggered = await riskPlaceState.evaluatePosition(
          latitude: location.latitude,
          longitude: location.longitude,
        );
        if (!mounted || triggered.isEmpty) {
          return;
        }
        _openArrival(triggered.first);
      },
    );
    setState(() => _monitoring = true);
  }

  Future<void> _simulateArrival(RiskPlace place) async {
    final triggered = await RiskPlaceStateScope.read(context).evaluatePosition(
      latitude: place.latitude,
      longitude: place.longitude,
    );
    if (!mounted) {
      return;
    }
    _openArrival(triggered.isEmpty ? place : triggered.first);
  }

  void _openArrival(RiskPlace place) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ArrivalReminderPage(place: place),
      ),
    );
  }

  Future<void> _openEdit({String? placeId}) async {
    PickedPlace? pickedPlace;
    if (placeId == null) {
      pickedPlace = await Navigator.of(context).push<PickedPlace>(
        MaterialPageRoute(builder: (_) => const PlacePickerPage()),
      );
      if (!mounted || pickedPlace == null) {
        return;
      }
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RiskPlaceEditPage(
          placeId: placeId,
          initialPickedPlace: pickedPlace,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = RiskPlaceStateScope.of(context);
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
            children: [
              _HomeHeader(
                count: state.places.length,
                monitoring: _monitoring,
                onToggleMonitoring: _toggleMonitoring,
              ),
              const SizedBox(height: 18),
              _MapPanel(places: state.places),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('add-risk-place-button'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: const Color(0xFF1769FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openEdit(),
                icon: const Icon(Icons.add_rounded),
                label: const Text('添加高风险消费地点'),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      '我的提醒地点',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F1F3D),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: state.places.isEmpty ? null : () {},
                    child: const Text('编辑'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!state.ready)
                const Center(child: CircularProgressIndicator())
              else if (state.places.isEmpty)
                const _EmptyPlacesCard()
              else
                ...state.places.map(
                  (place) => _RiskPlaceTile(
                    place: place,
                    onEdit: () => _openEdit(placeId: place.id),
                    onSimulate: () => _simulateArrival(place),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.count,
    required this.monitoring,
    required this.onToggleMonitoring,
  });

  final int count;
  final bool monitoring;
  final VoidCallback onToggleMonitoring;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '还了么',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF071B3A),
                ),
              ),
              SizedBox(height: 6),
              _GuardStatus(count: 0),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onToggleMonitoring,
          style: IconButton.styleFrom(
            backgroundColor:
                monitoring ? const Color(0xFFE5F8EF) : Colors.white,
          ),
          icon: Icon(
            monitoring
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            color:
                monitoring ? const Color(0xFF25B876) : const Color(0xFF14315F),
          ),
        ),
      ],
    );
  }
}

class _GuardStatus extends StatelessWidget {
  const _GuardStatus({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final state = RiskPlaceStateScope.of(context);
    return Row(
      children: [
        const Icon(Icons.verified_user_rounded,
            size: 16, color: Color(0xFF25B876)),
        const SizedBox(width: 4),
        Text(
          '守护中：${state.places.length} 个地点',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF25B876),
          ),
        ),
      ],
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({required this.places});

  final List<RiskPlace> places;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 230,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/ui/map_mock.png', fit: BoxFit.cover),
            const Positioned(
              left: 158,
              top: 126,
              child: _UserDot(),
            ),
            ..._markerPositions(places).map(
              (entry) => Positioned(
                left: entry.dx,
                top: entry.dy,
                child: _MapMarker(place: places[entry.index]),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF14315F),
                ),
                onPressed: () {},
                icon: const Icon(Icons.my_location_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_MarkerPosition> _markerPositions(List<RiskPlace> places) {
    const positions = [
      Offset(72, 70),
      Offset(190, 72),
      Offset(84, 142),
      Offset(226, 142),
    ];
    return List<_MarkerPosition>.generate(
      places.length > positions.length ? positions.length : places.length,
      (index) => _MarkerPosition(
        index: index,
        dx: positions[index].dx,
        dy: positions[index].dy,
      ),
    );
  }
}

class _MarkerPosition {
  const _MarkerPosition({
    required this.index,
    required this.dx,
    required this.dy,
  });

  final int index;
  final double dx;
  final double dy;
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.place});

  final RiskPlace place;

  @override
  Widget build(BuildContext context) {
    final color = _placeColor(place);
    return SizedBox(
      width: 82,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.22),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.38)),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(_placeIcon(place), color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

class _UserDot extends StatelessWidget {
  const _UserDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFF1769FF),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x441769FF), blurRadius: 12),
        ],
      ),
    );
  }
}

class _EmptyPlacesCard extends StatelessWidget {
  const _EmptyPlacesCard();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      radius: 18,
      shadow: BoxShadow(color: Color(0x0F1769FF), blurRadius: 20),
      child: Text('还没有提醒地点，先添加一个容易冲动消费的位置。'),
    );
  }
}

class _RiskPlaceTile extends StatelessWidget {
  const _RiskPlaceTile({
    required this.place,
    required this.onEdit,
    required this.onSimulate,
  });

  final RiskPlace place;
  final VoidCallback onEdit;
  final VoidCallback onSimulate;

  @override
  Widget build(BuildContext context) {
    final color = _placeColor(place);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1769FF),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(_placeIcon(place), color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF10213F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _RadiusPill(radius: place.radiusMeters, color: color),
                      const SizedBox(width: 8),
                      Text(
                        place.enabled ? '守护中' : '已停用',
                        style: const TextStyle(color: Color(0xFF7A879A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: onSimulate,
            child: const Text('测试'),
          ),
          Switch(
            value: place.enabled,
            activeThumbColor: const Color(0xFF25B876),
            onChanged: (value) =>
                RiskPlaceStateScope.read(context).togglePlace(place.id, value),
          ),
        ],
      ),
    );
  }
}

class _RadiusPill extends StatelessWidget {
  const _RadiusPill({required this.radius, required this.color});

  final int radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$radius 米',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

Color _placeColor(RiskPlace place) {
  if (place.name.contains('咖') || place.name.contains('网')) {
    return const Color(0xFFFF8A1D);
  }
  if (place.name.contains('商')) {
    return const Color(0xFF7D5DFF);
  }
  return const Color(0xFF22B873);
}

IconData _placeIcon(RiskPlace place) {
  if (place.name.contains('咖') || place.name.contains('网')) {
    return Icons.desktop_windows_rounded;
  }
  if (place.name.contains('商')) {
    return Icons.shopping_bag_rounded;
  }
  return Icons.local_cafe_rounded;
}
