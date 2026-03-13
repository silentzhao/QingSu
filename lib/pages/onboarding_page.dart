import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.read(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
        children: [
          const Reveal(
            delay: Duration(milliseconds: 40),
            child: BrandBadge(),
          ),
          const SizedBox(height: 22),
          const Reveal(
            delay: Duration(milliseconds: 110),
            child: Text(
              '轻植日常',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w800, height: 0.96),
            ),
          ),
          const SizedBox(height: 10),
          const Reveal(
            delay: Duration(milliseconds: 180),
            child: Text(
              '从演示样机推进到完整静态产品版，先把用户第一次进入应用时的认知和选择建立起来。',
              style: TextStyle(height: 1.55),
            ),
          ),
          const SizedBox(height: 24),
          Reveal(
            delay: const Duration(milliseconds: 240),
            child: HoverLift(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFF2C4D35),
                    Color(0xFF6C9653),
                    Color(0xFFD5E5AA)
                  ]),
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('吃得轻一点，状态好很多',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          SizedBox(height: 10),
                          Text('先告诉你品牌是什么、适合谁、怎么开始。',
                              style:
                                  TextStyle(color: Colors.white, height: 1.5)),
                        ],
                      ),
                    ),
                    FloatingBob(
                      amplitude: 8,
                      child: FoodThumb(
                        color: menuItems.first.color,
                        icon: menuItems.first.icon,
                        width: 108,
                        height: 108,
                        radius: 28,
                        heroTag: menuItems.first.heroTag,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          ...preferenceOptions.asMap().entries.map((entry) {
            final option = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                  bottom: entry.key == preferenceOptions.length - 1 ? 0 : 12),
              child: Reveal(
                delay: Duration(milliseconds: 320 + (entry.key * 80)),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 24,
                          offset: Offset(0, 12))
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE8CB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child:
                            Icon(option.icon, color: const Color(0xFF456243)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(option.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 6),
                            Text(option.subtitle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Reveal(
            delay: const Duration(milliseconds: 560),
            child: PressableScale(
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF263C2A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                ),
                onPressed: state.completeOnboarding,
                child: const Text('进入轻植日常'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
