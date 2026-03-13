import 'package:flutter/material.dart';

import '../models/app_models.dart';
import 'app_ui.dart';
import 'common_widgets.dart';

class ContentHero extends StatelessWidget {
  const ContentHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const HoverLift(
      child: GradientFeatureCard(
        colors: [Color(0xFF284B4B), Color(0xFF53786F), Color(0xFF9DB7A5)],
        radius: 32,
        padding: EdgeInsets.all(24),
        shadow: BoxShadow(
            color: Color(0x12000000), blurRadius: 22, offset: Offset(0, 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrandBadge(dark: true),
            SizedBox(height: 16),
            Text('为什么工作日更适合吃轻食',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            SizedBox(height: 10),
            Text('规律、轻负担、清晰的营养结构，会让午后状态更稳定。内容页的重点是把品牌方法论讲明白。',
                style: TextStyle(color: Colors.white, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({required this.item, super.key});

  final ArticleItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: SurfaceCard(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        radius: 26,
        shadow: const BoxShadow(
            color: Color(0x10000000), blurRadius: 24, offset: Offset(0, 10)),
        child: Row(
          children: [
            FoodThumb(
                color: item.color,
                icon: item.icon,
                width: 96,
                height: 108,
                radius: 24),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tag(label: item.tag, color: const Color(0xFFE6EFD9)),
                  const SizedBox(height: 10),
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(item.summary,
                      maxLines: 4, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(18),
      radius: 22,
      shadow: const BoxShadow(
          color: Color(0x10000000), blurRadius: 18, offset: Offset(0, 8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: const Color(0xFFDDE8CB),
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.lightbulb_outline,
                size: 18, color: Color(0xFF4B6643)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
