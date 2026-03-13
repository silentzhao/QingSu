import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';
import '../widgets/home_cards.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final offset =
              _scrollController.hasClients ? _scrollController.offset : 0.0;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              const SliverToBoxAdapter(child: _HomeHeader()),
              SliverToBoxAdapter(
                child: Reveal(
                  delay: const Duration(milliseconds: 120),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.18,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: HeroCard(item: menuItems.first),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 220),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Row(
                      children: [
                        Expanded(
                            child: MetricCard(number: '24h', label: '轻负担感知')),
                        SizedBox(width: 12),
                        Expanded(
                            child: MetricCard(number: '12+', label: '轻食组合')),
                        SizedBox(width: 12),
                        Expanded(
                            child: MetricCard(number: '4.9', label: '试吃反馈')),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 280),
                  child:
                      SectionTitle(title: '今日主推', subtitle: '首页做成活动页质感，品牌才立得住'),
                ),
              ),
              SliverToBoxAdapter(
                child: Reveal(
                  delay: const Duration(milliseconds: 340),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.1,
                    child: SizedBox(
                      height: 256,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) =>
                            HighlightCard(item: menuItems[i]),
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemCount: 3,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 420),
                  child: SectionTitle(
                      title: '开始下单前', subtitle: '先把浏览、收藏、购物袋和预约链路串起来'),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 480),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ValueCard(
                            icon: Icons.favorite_outline,
                            title: '先收藏',
                            subtitle: '详情页可以标记想试的组合。'),
                        ValueCard(
                            icon: Icons.shopping_bag_outlined,
                            title: '再加入购物袋',
                            subtitle: '静态版先把套餐单和金额结构走通。'),
                        ValueCard(
                            icon: Icons.event_available_outlined,
                            title: '最后预约配送',
                            subtitle: '下单流程不接后端，但交互闭环要完整。'),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 560),
                  child: SectionTitle(
                      title: '品牌故事', subtitle: '让用户感觉这不只是菜单，而是一套生活方式'),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 620),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: StoryCard(tags: ['高蛋白搭配', '适合工作日午餐', '清爽但有饱腹感']),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return const Reveal(
      delay: Duration(milliseconds: 40),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandBadge(),
                  SizedBox(height: 14),
                  Text('轻植日常',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                  SizedBox(height: 4),
                  Text('吃得轻一点，状态好很多'),
                ],
              ),
            ),
            GlassIcon(icon: Icons.spa_outlined),
          ],
        ),
      ),
    );
  }
}
