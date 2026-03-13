import 'package:flutter/material.dart';

import '../models/app_models.dart';
import 'app_ui.dart';
import 'common_widgets.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: FloatingBob(
        child: GradientFeatureCard(
          colors: const [
            Color(0xFF2C4D35),
            Color(0xFF6C9653),
            Color(0xFFD5E5AA)
          ],
          padding: const EdgeInsets.all(26),
          radius: 36,
          shadow: const BoxShadow(
              color: Color(0x24000000), blurRadius: 30, offset: Offset(0, 18)),
          child: Stack(
            children: [
              Positioned(
                  right: -6,
                  top: 20,
                  child: Halo(
                      size: 140, color: Colors.white.withValues(alpha: 0.1))),
              Positioned(
                right: 18,
                top: 52,
                child: FloatingBob(
                  amplitude: 8,
                  duration: const Duration(milliseconds: 3200),
                  child: FoodThumb(
                      color: item.color,
                      icon: item.icon,
                      width: 126,
                      height: 126,
                      radius: 34,
                      heroTag: item.heroTag),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999)),
                    child: const Text('SPRING CAMPAIGN',
                        style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(
                    width: 210,
                    child: Text('重新认识轻食',
                        style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            height: 0.98,
                            color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 230,
                    child: Text('不是吃得更少，而是吃得更好。把品牌主张和招牌单品一次讲清楚。',
                        style: TextStyle(color: Colors.white, height: 1.45)),
                  ),
                  const SizedBox(height: 22),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Tag(
                          label: '高蛋白',
                          color: Color(0x33FFFFFF),
                          textColor: Colors.white),
                      Tag(
                          label: '午餐友好',
                          color: Color(0x33FFFFFF),
                          textColor: Colors.white),
                      Tag(
                          label: '好吃不将就',
                          color: Color(0x33FFFFFF),
                          textColor: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      PressableScale(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF1B16A),
                              foregroundColor: const Color(0xFF1F2A18)),
                          onPressed: () => openFoodDetail(context, item),
                          child: const Text('立即预览'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      PressableScale(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white38),
                              foregroundColor: Colors.white),
                          onPressed: () => openFoodDetail(context, item),
                          child: const Text('查看菜单'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: Text(item.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white))),
                      Text(item.price,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HighlightCard extends StatelessWidget {
  const HighlightCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: GestureDetector(
        onTap: () => openFoodDetail(context, item),
        child: SurfaceCard(
          padding: const EdgeInsets.all(18),
          radius: 30,
          shadow: const BoxShadow(
              color: Color(0x14000000), blurRadius: 26, offset: Offset(0, 16)),
          child: SizedBox(
            width: 184,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Tag(label: item.badge, color: item.badgeColor),
                  const Spacer(),
                  Text(item.price,
                      style: const TextStyle(fontWeight: FontWeight.w800))
                ]),
                const SizedBox(height: 16),
                FoodThumb(
                    color: item.color,
                    icon: item.icon,
                    width: 184,
                    height: 116,
                    radius: 28,
                    heroTag: item.heroTag),
                const SizedBox(height: 16),
                Text(item.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(item.description,
                    maxLines: 3, overflow: TextOverflow.ellipsis),
                const Spacer(),
                Row(children: [
                  Text(item.kcal,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B734F))),
                  const Spacer(),
                  const Icon(Icons.arrow_outward, size: 20)
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  const ValueCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      super.key});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width / 2 - 26,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFFFFFCF7), Color(0xFFF0EAD9)]),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDE8CB),
                    borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: const Color(0xFF446141)),
              ),
              const SizedBox(height: 18),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(subtitle),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({required this.tags, super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: SurfaceCard(
        padding: const EdgeInsets.all(24),
        radius: 34,
        color: const Color(0xFF20352C),
        shadow: const BoxShadow(
            color: Color(0x18000000), blurRadius: 30, offset: Offset(0, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('适合忙碌生活中的每一餐',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 12),
            const Text('午餐需要效率，晚餐需要轻松，健身后需要补充。轻植日常把口感、营养和情绪价值放在同一份餐里。',
                style: TextStyle(color: Colors.white70, height: 1.5)),
            const SizedBox(height: 18),
            Wrap(
                spacing: 10,
                runSpacing: 10,
                children: tags
                    .map((tag) => Tag(
                        label: tag,
                        color: Colors.white.withValues(alpha: 0.09),
                        textColor: Colors.white))
                    .toList()),
          ],
        ),
      ),
    );
  }
}
