import 'package:flutter/material.dart';

import '../models/app_models.dart';
import 'app_ui.dart';
import 'common_widgets.dart';

class DiscoverBar extends StatelessWidget {
  const DiscoverBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      padding: EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(child: MiniStat(label: '新品热度', value: 'TOP 3')),
          SizedBox(width: 12),
          Expanded(child: MiniStat(label: '平均热量', value: '<420')),
          SizedBox(width: 12),
          Expanded(child: MiniStat(label: '最快取餐', value: '15 min')),
        ],
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  const MiniStat({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF35503B))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class CampaignBanner extends StatelessWidget {
  const CampaignBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const HoverLift(
      child: GradientFeatureCard(
        colors: [Color(0xFFEF8F55), Color(0xFFF4B96C), Color(0xFFF8DE97)],
        radius: 30,
        shadow: BoxShadow(
            color: Color(0x16000000), blurRadius: 28, offset: Offset(0, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('本周轻食入门组合',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            SizedBox(height: 8),
            Text('从 5 份高满意度搭配开始，减少选择成本，先把轻松吃饭建立起来。',
                style: TextStyle(color: Colors.white, height: 1.45)),
            SizedBox(height: 18),
            Row(
              children: [
                Tag(
                    label: '工作日午餐',
                    color: Color(0x33FFFFFF),
                    textColor: Colors.white),
                SizedBox(width: 8),
                Tag(
                    label: '低负担',
                    color: Color(0x33FFFFFF),
                    textColor: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: GestureDetector(
        onTap: () => openFoodDetail(context, item),
        child: SurfaceCard(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          radius: 30,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: FoodThumb(
                          color: item.color,
                          icon: item.icon,
                          width: 148,
                          height: 148,
                          radius: 30,
                          heroTag: item.heroTag)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Tag(label: item.badge, color: item.badgeColor),
                          const Spacer(),
                          Text(item.price,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800))
                        ]),
                        const SizedBox(height: 14),
                        Text(item.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(item.description),
                        const SizedBox(height: 12),
                        Text(item.kcal,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF59714E))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags
                      .map((tag) =>
                          Tag(label: tag, color: const Color(0xFFF3EDE2)))
                      .toList()),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Text('适合第一次接触轻食的用户，也适合工作日午餐快速决策。')),
                  const SizedBox(width: 16),
                  PressableScale(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF263C2A),
                          foregroundColor: Colors.white),
                      onPressed: () => openFoodDetail(context, item),
                      child: const Text('加入组合'),
                    ),
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
