import 'package:flutter/material.dart';

import '../../../models/risk_place.dart';
import '../../../utils/geo_utils.dart';
import '../../../widgets/app_ui.dart';
import '../../../widgets/common_widgets.dart';
import '../state/risk_place_state.dart';
import 'place_picker_page.dart';

class RiskPlaceEditPage extends StatefulWidget {
  const RiskPlaceEditPage({
    this.placeId,
    this.initialPickedPlace,
    super.key,
  });

  final String? placeId;
  final PickedPlace? initialPickedPlace;

  @override
  State<RiskPlaceEditPage> createState() => _RiskPlaceEditPageState();
}

class _RiskPlaceEditPageState extends State<RiskPlaceEditPage> {
  static const _defaultReminderText = '你已经靠近高风险消费地点，请冷静一下，先想想是不是真的需要消费。';

  final _reminderController = TextEditingController(text: _defaultReminderText);
  PickedPlace? _pickedPlace;
  int _radiusMeters = 200;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }
    final placeId = widget.placeId;
    final place = placeId == null
        ? null
        : RiskPlaceStateScope.of(context).placeById(placeId);
    if (place != null) {
      _reminderController.text = place.reminderText;
      _radiusMeters = place.radiusMeters;
      _pickedPlace = PickedPlace(
        name: place.name,
        address: place.address,
        latitude: place.latitude,
        longitude: place.longitude,
      );
    } else {
      _pickedPlace = widget.initialPickedPlace;
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _reminderController.dispose();
    super.dispose();
  }

  Future<void> _pickPlace() async {
    final picked = await Navigator.of(context).push<PickedPlace>(
      MaterialPageRoute(builder: (_) => const PlacePickerPage()),
    );
    if (picked == null) {
      return;
    }
    setState(() => _pickedPlace = picked);
  }

  Future<void> _save() async {
    final picked = _pickedPlace;
    if (picked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择一个提醒地点')),
      );
      return;
    }
    final reminderText = _reminderController.text.trim();
    final state = RiskPlaceStateScope.read(context);
    final current =
        widget.placeId == null ? null : state.placeById(widget.placeId!);
    final place = RiskPlace(
      id: current?.id ?? 'risk-${DateTime.now().microsecondsSinceEpoch}',
      name: picked.name,
      address: picked.address,
      latitude: picked.latitude,
      longitude: picked.longitude,
      radiusMeters: _radiusMeters,
      reminderText: reminderText.isEmpty ? _defaultReminderText : reminderText,
      enabled: true,
      lastTriggeredAt: current?.lastTriggeredAt,
    );
    await state.upsertPlace(place);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已保存并开启守护')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final picked = _pickedPlace;
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              _EditHeader(onBack: () => Navigator.of(context).pop()),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  children: [
                    _PickedPlaceCard(place: picked, onChange: _pickPlace),
                    const SizedBox(height: 14),
                    _RadiusCard(
                      radiusMeters: _radiusMeters,
                      onChanged: (value) =>
                          setState(() => _radiusMeters = value),
                    ),
                    const SizedBox(height: 14),
                    _ReminderTextCard(controller: _reminderController),
                    const SizedBox(height: 14),
                    const _AdvancedSettingsRow(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: FilledButton(
                  key: const Key('risk-place-save-button'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1769FF),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _save,
                  child: const Text('保存并开启守护'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 18, 6),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const Expanded(
            child: Text(
              '设置提醒',
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

class _PickedPlaceCard extends StatelessWidget {
  const _PickedPlaceCard({required this.place, required this.onChange});

  final PickedPlace? place;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    final selected = place;
    return SurfaceCard(
      radius: 18,
      padding: const EdgeInsets.all(16),
      shadow: const BoxShadow(color: Color(0x0F1769FF), blurRadius: 18),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF0AAE66),
            child: Icon(Icons.local_cafe_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: selected == null
                ? const Text(
                    '请选择需要守护的消费地点',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selected.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF7A879A),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${formatCoordinate(selected.latitude)}, ${formatCoordinate(selected.longitude)}',
                        style: const TextStyle(
                          color: Color(0xFF9AA7B8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
          ),
          TextButton(onPressed: onChange, child: const Text('更换')),
        ],
      ),
    );
  }
}

class _RadiusCard extends StatelessWidget {
  const _RadiusCard({required this.radiusMeters, required this.onChanged});

  final int radiusMeters;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      shadow: const BoxShadow(color: Color(0x0F1769FF), blurRadius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '提醒范围（半径）',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Colors.blueGrey.shade300,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final value in const [100, 200, 500])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _RadiusPresetButton(
                      value: value,
                      selected: radiusMeters == value,
                      onTap: () => onChanged(value),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Slider(
            value: radiusMeters.toDouble(),
            min: 50,
            max: 1000,
            divisions: 19,
            activeColor: const Color(0xFF1769FF),
            onChanged: (value) => onChanged(value.round()),
          ),
          const Row(
            children: [
              Text('50 米', style: TextStyle(color: Color(0xFF9AA7B8))),
              Spacer(),
              Text('1000 米', style: TextStyle(color: Color(0xFF9AA7B8))),
            ],
          ),
          Center(
            child: Text(
              '$radiusMeters 米',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF14315F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadiusPresetButton extends StatelessWidget {
  const _RadiusPresetButton({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1769FF) : const Color(0xFFF0F4FA),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          '$value 米',
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF14315F),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ReminderTextCard extends StatefulWidget {
  const _ReminderTextCard({required this.controller});

  final TextEditingController controller;

  @override
  State<_ReminderTextCard> createState() => _ReminderTextCardState();
}

class _ReminderTextCardState extends State<_ReminderTextCard> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      radius: 18,
      padding: const EdgeInsets.all(18),
      shadow: const BoxShadow(color: Color(0x0F1769FF), blurRadius: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  '语音提醒内容',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: Colors.blueGrey.shade300,
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: widget.controller,
            maxLines: 4,
            maxLength: 100,
            decoration: InputDecoration(
              hintText: _RiskPlaceEditPageState._defaultReminderText,
              filled: true,
              fillColor: Colors.white,
              counterText: '${widget.controller.text.length}/100',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE4EAF3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE4EAF3)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(46),
              foregroundColor: const Color(0xFF1769FF),
              side: BorderSide.none,
              backgroundColor: const Color(0xFFF0F5FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.mic_rounded),
            label: const Text('试听语音提醒'),
          ),
        ],
      ),
    );
  }
}

class _AdvancedSettingsRow extends StatelessWidget {
  const _AdvancedSettingsRow();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      radius: 18,
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      shadow: BoxShadow(color: Color(0x0F1769FF), blurRadius: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '高级设置',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  '通知方式、本地通知权限等',
                  style: TextStyle(color: Color(0xFF7A879A)),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Color(0xFF7A879A)),
        ],
      ),
    );
  }
}
