import 'package:flutter/material.dart';

import '../../../models/risk_place.dart';
import '../../../utils/geo_utils.dart';

const demoPickedPlaces = [
  PickedPlace(
    name: '星巴克（人民广场店）',
    address: '上海市黄浦区南京东路 123 号',
    latitude: 31.227956,
    longitude: 121.474727,
  ),
  PickedPlace(
    name: '商场（XX 广场）',
    address: '上海市静安区南京西路 1515 号',
    latitude: 31.229056,
    longitude: 121.454727,
  ),
  PickedPlace(
    name: '网吧（极速网咖）',
    address: '上海市普陀区中山北路 3300 号',
    latitude: 31.231295,
    longitude: 121.413948,
  ),
];

class PlacePickerPage extends StatefulWidget {
  const PlacePickerPage({super.key});

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  final _searchController = TextEditingController();
  PickedPlace _selected = demoPickedPlaces.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: Column(
          children: [
            _PickerHeader(onBack: () => Navigator.of(context).pop()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '搜索商场名或门店',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE3EAF5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE3EAF5)),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: _CategoryChips(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/ui/map_mock.png', fit: BoxFit.cover),
                  Center(
                    child: _SelectionCircle(place: _selected),
                  ),
                  const Positioned(
                    right: 18,
                    bottom: 122,
                    child: _LocateButton(),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _SelectedPlaceSheet(
                      selected: _selected,
                      onSelect: (place) => setState(() => _selected = place),
                      onSubmit: () => Navigator.of(context).pop(_selected),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerHeader extends StatelessWidget {
  const _PickerHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 18, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const Expanded(
            child: Text(
              '添加地点',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Chip(label: '附近商场'),
        SizedBox(width: 8),
        _Chip(label: '咖啡店'),
        SizedBox(width: 8),
        _Chip(label: '餐饮'),
        SizedBox(width: 8),
        _Chip(label: '更多'),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(color: Color(0x0C1769FF), blurRadius: 14)
          ],
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  const _SelectionCircle({required this.place});

  final PickedPlace place;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              color: const Color(0xFF1769FF).withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1769FF).withValues(alpha: 0.35),
              ),
            ),
          ),
          const Icon(Icons.location_on_rounded,
              size: 54, color: Color(0xFFFF4F45)),
        ],
      ),
    );
  }
}

class _LocateButton extends StatelessWidget {
  const _LocateButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x2214315F), blurRadius: 18)],
      ),
      child: const Icon(Icons.my_location_rounded, color: Color(0xFF14315F)),
    );
  }
}

class _SelectedPlaceSheet extends StatelessWidget {
  const _SelectedPlaceSheet({
    required this.selected,
    required this.onSelect,
    required this.onSubmit,
  });

  final PickedPlace selected;
  final ValueChanged<PickedPlace> onSelect;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [BoxShadow(color: Color(0x2214315F), blurRadius: 24)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD6DFEC),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final place = demoPickedPlaces[index];
                final active = selected.name == place.name;
                return GestureDetector(
                  onTap: () => onSelect(place),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 230,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFFF3F8FF) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1769FF)
                            : const Color(0xFFE4EAF3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFF0AAE66),
                          child: Icon(Icons.local_cafe, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                place.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '距离您 ${120 + index * 40} 米',
                                style: const TextStyle(
                                  color: Color(0xFF7A879A),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: demoPickedPlaces.length,
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: const Color(0xFF1769FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onSubmit,
            child: const Text('下一步：设置提醒范围'),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatCoordinate(selected.latitude)}, ${formatCoordinate(selected.longitude)}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF9AA7B8)),
          ),
        ],
      ),
    );
  }
}
