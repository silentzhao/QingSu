import 'package:flutter/material.dart';

import '../../../models/risk_place.dart';
import '../../../widgets/common_widgets.dart';

class ArrivalReminderPage extends StatelessWidget {
  const ArrivalReminderPage({required this.place, super.key});

  final RiskPlace place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 18, 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const Expanded(
                      child: Text(
                        '到达提醒',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                  children: [
                    _GuardHero(place: place),
                    const SizedBox(height: 22),
                    _NotificationCard(place: place),
                    const SizedBox(height: 16),
                    const _VoiceTriggeredCard(),
                  ],
                ),
              ),
              const _ArrivalBottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuardHero extends StatelessWidget {
  const _GuardHero({required this.place});

  final RiskPlace place;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 108,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF20D394), Color(0xFF05A968)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(color: Color(0x3325B876), blurRadius: 24),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 58),
        ),
        const SizedBox(height: 18),
        const Text(
          '守护中',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0F1F3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          place.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF14315F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE5F8EF),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '半径 ${place.radiusMeters} 米',
            style: const TextStyle(
              color: Color(0xFF16A66C),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '当您进入提醒范围时，我们会自动提醒',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF7A879A)),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.place});

  final RiskPlace place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x1414315F), blurRadius: 22),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF1769FF),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '还了么',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 8),
              const Text('现在', style: TextStyle(color: Color(0xFF9AA7B8))),
              const Spacer(),
              const Icon(Icons.info_outline_rounded, color: Color(0xFF7A879A)),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            '已到达提醒范围',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            place.reminderText,
            style: const TextStyle(height: 1.55, color: Color(0xFF33415C)),
          ),
        ],
      ),
    );
  }
}

class _VoiceTriggeredCard extends StatelessWidget {
  const _VoiceTriggeredCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x1414315F), blurRadius: 22),
        ],
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '语音提醒已触发',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 18),
          const _Waveform(),
          const SizedBox(height: 18),
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFF1769FF),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Color(0x331769FF), blurRadius: 20)],
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 10),
          const Text('点击停止语音', style: TextStyle(color: Color(0xFF7A879A))),
        ],
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [16.0, 28.0, 20.0, 38.0, 24.0, 44.0, 28.0, 18.0, 34.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final height in [...heights, ...heights.reversed])
          Container(
            width: 3,
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF1769FF).withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

class _ArrivalBottomNav extends StatelessWidget {
  const _ArrivalBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(34, 10, 34, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7EDF6))),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ArrivalNavItem(icon: Icons.home_rounded, label: '首页', active: true),
          _ArrivalNavItem(icon: Icons.description_outlined, label: '记录'),
          _ArrivalNavItem(icon: Icons.settings_outlined, label: '设置'),
        ],
      ),
    );
  }
}

class _ArrivalNavItem extends StatelessWidget {
  const _ArrivalNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF1769FF) : const Color(0xFF7A879A);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: active ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
