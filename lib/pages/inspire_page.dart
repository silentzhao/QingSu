import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../widgets/common_widgets.dart';
import '../widgets/inspire_cards.dart';

class InspirePage extends StatelessWidget {
  const InspirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const Reveal(
                delay: Duration(milliseconds: 40),
                child: Text('饮食灵感',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
            const SizedBox(height: 6),
            const Reveal(
                delay: Duration(milliseconds: 90),
                child: Text('用内容页把品牌的方法论和调性讲清楚。')),
            const SizedBox(height: 18),
            const Reveal(
                delay: Duration(milliseconds: 150), child: ContentHero()),
            const SizedBox(height: 18),
            ...articles.asMap().entries.map(
                  (entry) => Reveal(
                    delay: Duration(milliseconds: 220 + (entry.key * 70)),
                    child: ArticleCard(item: entry.value),
                  ),
                ),
            const SizedBox(height: 8),
            const Reveal(
                delay: Duration(milliseconds: 420),
                child: Text('轻知识',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
            const SizedBox(height: 12),
            ...tips.asMap().entries.map(
                  (entry) => Reveal(
                    delay: Duration(milliseconds: 480 + (entry.key * 60)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InsightCard(text: entry.value),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
