import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';
import '../widgets/list_items.dart';
import 'order_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final favorites = menuItems.where(state.isFavorite).toList();
    final orders = state.orders;
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const Reveal(
              delay: Duration(milliseconds: 40),
              child: Text('我的',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 6),
            const Reveal(
              delay: Duration(milliseconds: 90),
              child: Text('把会员信息、偏好、预约记录和收藏结构先建好，后面接真实用户数据更顺。'),
            ),
            const SizedBox(height: 20),
            const Reveal(
                delay: Duration(milliseconds: 150), child: _MemberHero()),
            const SizedBox(height: 16),
            const Reveal(
                delay: Duration(milliseconds: 220), child: _PreferenceCard()),
            const SizedBox(height: 16),
            Reveal(
              delay: const Duration(milliseconds: 290),
              child: SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardSectionHeader(
                      title: '预约记录',
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const OrderHistoryPage(),
                            ),
                          );
                        },
                        child: const Text('查看全部'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (orders.isEmpty)
                      const Text('还没有预约记录。可以先去购物袋完成一次静态下单流程。')
                    else
                      OrderRecordCard(
                          order: orders.first, margin: EdgeInsets.zero),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Reveal(
              delay: const Duration(milliseconds: 360),
              child: SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardSectionHeader(
                      title: '我的收藏',
                      trailing: Text(
                        '${favorites.length} 项',
                        style: const TextStyle(color: Color(0xFF617263)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (favorites.isEmpty)
                      const Text('还没有收藏内容。可以去详情页标记你想试的组合。')
                    else
                      ...favorites.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: FavoriteListItem(
                              item: item,
                              onTap: () => openFoodDetail(context, item),
                            ),
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberHero extends StatelessWidget {
  const _MemberHero();

  @override
  Widget build(BuildContext context) {
    return const GradientFeatureCard(
      colors: [Color(0xFF2D4B36), Color(0xFF6E8E56)],
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandBadge(dark: true),
          SizedBox(height: 14),
          Text('轻植会员 Lv.1',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('已解锁工作日午餐偏好、收藏夹和预约记录视图。',
              style: TextStyle(color: Colors.white, height: 1.5)),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardSectionHeader(title: '饮食偏好'),
          SizedBox(height: 12),
          InfoRow(label: '口味方向', value: '清爽、低油、可持续坚持'),
          SizedBox(height: 8),
          InfoRow(label: '优先场景', value: '工作日午餐 / 训练后补充'),
          SizedBox(height: 8),
          InfoRow(label: '提醒方式', value: '每周一推送本周轻食搭配'),
        ],
      ),
    );
  }
}
