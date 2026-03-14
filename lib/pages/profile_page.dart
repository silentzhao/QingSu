import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';
import '../widgets/list_items.dart';
import 'order_history_page.dart';
import 'order_detail_page.dart';
import 'preference_edit_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final favorites = menuItems.where(state.isFavorite).toList();
    final orders = state.orders;
    final preferences = state.onboardingPreferences;
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
            Reveal(
              delay: const Duration(milliseconds: 150),
              child: _MemberHero(preferences: preferences),
            ),
            const SizedBox(height: 16),
            Reveal(
              delay: const Duration(milliseconds: 220),
              child: _PreferenceCard(preferences: preferences),
            ),
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
                        key: const Key('profile-view-all-orders'),
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
                        key: const Key('profile-latest-order-card'),
                        order: orders.first,
                        margin: EdgeInsets.zero,
                        canAdvance:
                            state.canAdvanceOrderProgress(orders.first.id),
                        advanceButtonKey:
                            const Key('profile-latest-order-advance'),
                        onAdvance: () {
                          state.advanceOrderProgress(orders.first.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已推进最新订单节点')),
                          );
                        },
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  OrderDetailPage(orderId: orders.first.id),
                            ),
                          );
                        },
                      ),
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
  const _MemberHero({
    required this.preferences,
  });

  final OnboardingPreferences? preferences;

  @override
  Widget build(BuildContext context) {
    final subtitle = preferences == null
        ? '已解锁工作日午餐偏好、收藏夹和预约记录视图。'
        : '已按 ${preferences!.goal.title} / ${preferences!.taste.title} / ${preferences!.mealtime.title} 生成本次静态偏好。';
    return _ProfileMemberHeroBody(
      subtitle: subtitle,
    );
  }
}

class _ProfileMemberHeroBody extends StatelessWidget {
  const _ProfileMemberHeroBody({
    required this.subtitle,
  });

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GradientFeatureCard(
      colors: const [Color(0xFF2D4B36), Color(0xFF6E8E56)],
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandBadge(dark: true),
          const SizedBox(height: 14),
          const Text('轻植会员 Lv.1',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(color: Colors.white, height: 1.5)),
        ],
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  const _PreferenceCard({
    required this.preferences,
  });

  final OnboardingPreferences? preferences;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardSectionHeader(
            title: '饮食偏好',
            trailing: TextButton(
              key: const Key('profile-preference-edit-button'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const PreferenceEditPage(),
                  ),
                );
              },
              child: const Text('编辑'),
            ),
          ),
          const SizedBox(height: 12),
          InfoRow(
            label: '当前目标',
            value: preferences?.goal.title ?? '轻负担、稳定状态、可持续坚持',
          ),
          const SizedBox(height: 8),
          InfoRow(
            label: '口味方向',
            value: preferences?.taste.title ?? '清爽、低油、可持续坚持',
          ),
          const SizedBox(height: 8),
          InfoRow(
            label: '优先场景',
            value: preferences?.mealtime.title ?? '工作日午餐 / 训练后补充',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: AppStateScope.read(context).reopenOnboarding,
            icon: const Icon(Icons.refresh),
            label: const Text('重新走首次引导'),
          ),
        ],
      ),
    );
  }
}
