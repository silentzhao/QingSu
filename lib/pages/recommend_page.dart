import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../widgets/common_widgets.dart';
import '../widgets/recommend_cards.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  int selectedCategory = 0;
  final categories = const ['主推', '能量碗', '轻沙拉', '低卡小食', '轻饮品'];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = selectedCategory == 0
        ? menuItems
        : menuItems
            .where((e) => e.category == categories[selectedCategory])
            .toList();

    return AppBackdrop(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final offset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return SafeArea(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                const Reveal(
                    delay: Duration(milliseconds: 40),
                    child: Text('今天吃点轻松的',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w800))),
                const SizedBox(height: 6),
                const Reveal(
                    delay: Duration(milliseconds: 90),
                    child: Text('把推荐页做得像精品品牌橱窗，用户才会想继续往下看。')),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 150),
                  child: ParallaxShift(
                      offset: offset, factor: 0.12, child: const DiscoverBar()),
                ),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 220),
                  child: SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) => AnimatedScale(
                        duration: const Duration(milliseconds: 220),
                        scale: selectedCategory == i ? 1.0 : 0.96,
                        child: FilterChip(
                          label: Text(categories[i]),
                          selected: selectedCategory == i,
                          showCheckmark: false,
                          side: BorderSide.none,
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFFDDE8CB),
                          onSelected: (_) =>
                              setState(() => selectedCategory = i),
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: categories.length,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 280),
                  child: ParallaxShift(
                      offset: offset,
                      factor: 0.16,
                      child: const CampaignBanner()),
                ),
                const SizedBox(height: 18),
                ...items.asMap().entries.map(
                      (entry) => Reveal(
                        delay: Duration(milliseconds: 320 + (entry.key * 70)),
                        child: ProductCard(item: entry.value),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}
