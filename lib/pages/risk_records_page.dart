import 'package:flutter/material.dart';

import '../features/risk_places/state/risk_place_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class RiskRecordsPage extends StatelessWidget {
  const RiskRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = RiskPlaceStateScope.of(context);
    final triggered = state.places
        .where((place) => place.lastTriggeredAt != null)
        .toList(growable: false);
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 112),
          children: [
            const Text(
              '记录',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF071B3A),
              ),
            ),
            const SizedBox(height: 8),
            const Text('这里记录已经触发过的位置提醒。'),
            const SizedBox(height: 18),
            if (triggered.isEmpty)
              const SurfaceCard(
                radius: 18,
                child: Text('还没有到达提醒记录。'),
              )
            else
              ...triggered.map(
                (place) => SurfaceCard(
                  radius: 18,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const GlassIcon(icon: Icons.notifications_active),
                    title: Text(place.name),
                    subtitle: Text(place.reminderText),
                    trailing: Text('${place.radiusMeters} 米'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
