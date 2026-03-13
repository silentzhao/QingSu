import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';
import '../widgets/list_items.dart';
import 'checkout_page.dart';

class BagPage extends StatelessWidget {
  const BagPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final bag = state.bag;
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const Reveal(
                delay: Duration(milliseconds: 40),
                child: Text('购物袋',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
            const SizedBox(height: 6),
            const Reveal(
                delay: Duration(milliseconds: 90),
                child: Text('把静态套餐单、配送和下单信息做完整，为后续接 API 留结构。')),
            const SizedBox(height: 20),
            ...bag.asMap().entries.map((entry) => Reveal(
                  delay: Duration(milliseconds: 160 + (entry.key * 70)),
                  child: BagListItem(
                    entry: entry.value,
                    onDecrement: () => state.updateBagQuantity(
                      entry.value.item,
                      entry.value.quantity - 1,
                    ),
                    onIncrement: () => state.updateBagQuantity(
                      entry.value.item,
                      entry.value.quantity + 1,
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            const Reveal(
                delay: Duration(milliseconds: 360), child: _DeliveryCard()),
            const SizedBox(height: 16),
            Reveal(
              delay: const Duration(milliseconds: 420),
              child: SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CardSectionHeader(title: '金额汇总'),
                    const SizedBox(height: 14),
                    InfoRow(label: '商品小计', value: '¥${state.subtotal}'),
                    const SizedBox(height: 8),
                    InfoRow(label: '配送费', value: '¥${state.deliveryFee}'),
                    const SizedBox(height: 8),
                    InfoRow(label: '合计', value: '¥${state.total}'),
                    const SizedBox(height: 18),
                    PressableScale(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF263C2A),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(56),
                        ),
                        onPressed: bag.isEmpty
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                      builder: (_) => const CheckoutPage()),
                                );
                              },
                        child: const Text('进入预约/下单流程'),
                      ),
                    ),
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

class _DeliveryCard extends StatelessWidget {
  const _DeliveryCard();

  @override
  Widget build(BuildContext context) {
    return const GradientFeatureCard(
      colors: [Color(0xFF2D4B36), Color(0xFF6E8E56)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BrandBadge(dark: true),
          SizedBox(height: 14),
          Text('本次配送建议',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('工作日 12:10-12:30 配送，适合办公室午餐场景。当前版本先用静态信息模拟真实下单体验。',
              style: TextStyle(color: Colors.white, height: 1.5)),
        ],
      ),
    );
  }
}
