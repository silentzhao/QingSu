import 'package:flutter/material.dart';

import '../features/risk_places/state/risk_place_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiskPlaceStateScope.of(context);
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
          children: [
            const Text(
              '设置',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF071B3A),
              ),
            ),
            const SizedBox(height: 18),
            SurfaceCard(
              radius: 18,
              child: Column(
                children: [
                  _SettingRow(
                    icon: Icons.shield_outlined,
                    title: '本地守护',
                    subtitle: '地点和提醒文案仅保存在本机',
                    trailing: Switch(value: true, onChanged: (_) {}),
                  ),
                  const Divider(height: 24),
                  const _SettingRow(
                    icon: Icons.lock_outline,
                    title: '隐私保护',
                    subtitle: '不上传位置，不需要登录',
                    trailing:
                        Icon(Icons.check_circle, color: Color(0xFF25B876)),
                  ),
                  const Divider(height: 24),
                  _SettingRow(
                    icon: Icons.location_on_outlined,
                    title: '提醒地点',
                    subtitle: '当前 ${state.places.length} 个地点',
                    trailing: const Icon(Icons.chevron_right),
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

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GlassIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Color(0xFF6B7890))),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}
