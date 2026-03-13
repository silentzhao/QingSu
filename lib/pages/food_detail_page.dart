import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  FavoriteButton(item: item),
                ],
              ),
              const SizedBox(height: 14),
              HoverLift(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      item.color.withValues(alpha: 0.95),
                      item.color.withValues(alpha: 0.68)
                    ]),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x18000000),
                          blurRadius: 28,
                          offset: Offset(0, 16))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Tag(
                            label: item.badge,
                            color: Colors.white.withValues(alpha: 0.2),
                            textColor: Colors.white),
                        const Spacer(),
                        Text(item.price,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white))
                      ]),
                      const SizedBox(height: 18),
                      FloatingBob(
                        amplitude: 10,
                        duration: const Duration(milliseconds: 3400),
                        child: FoodThumb(
                          color: item.color,
                          icon: item.icon,
                          width: double.infinity,
                          height: 260,
                          radius: 40,
                          heroTag: item.heroTag,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(item.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(item.description,
                          style: const TextStyle(
                              fontSize: 16, height: 1.5, color: Colors.white)),
                      const SizedBox(height: 18),
                      Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.tags
                              .map((tag) => Tag(
                                  label: tag,
                                  color: Colors.white.withValues(alpha: 0.18),
                                  textColor: Colors.white))
                              .toList()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: MetricCard(number: item.kcal, label: '单份热量')),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: MetricCard(number: '15 min', label: '预计出餐')),
                ],
              ),
              const SizedBox(height: 18),
              _DetailBlock(
                title: '食材组成',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.ingredients
                      .map((value) =>
                          Tag(label: value, color: const Color(0xFFF3EDE2)))
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              _DetailBlock(
                title: '营养结构',
                child: Column(
                  children: item.nutrition
                      .map((stat) => _NutritionRow(stat: stat))
                      .toList(),
                ),
              ),
              const SizedBox(height: 14),
              _DetailBlock(
                title: '推荐场景',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: item.scenes
                      .map((scene) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 18, color: Color(0xFF506D49)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(scene)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 22),
              PressableScale(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF263C2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    state.addToBag(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} 已加入购物袋')),
                    );
                  },
                  child: const Text('加入今日轻食组合'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      radius: 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.stat});

  final NutritionStat stat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(stat.label,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(stat.value,
                  style: const TextStyle(color: Color(0xFF526A4D))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: stat.progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF0EADA),
              color: const Color(0xFF7CA05B),
            ),
          ),
        ],
      ),
    );
  }
}
