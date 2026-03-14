import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../state/app_state.dart';
import '../widgets/app_ui.dart';
import '../widgets/common_widgets.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final bundle = state.checkoutBundleRecommendation;
    final bundleNotes = state.checkoutBundleChangeNotes;
    final pricingExplanation = state.checkoutBundlePricingExplanation;
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
                  const SizedBox(width: 12),
                  const Text(
                    '预约/下单',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Reveal(
                delay: Duration(milliseconds: 60),
                child: _CheckoutStepCard(
                  index: '01',
                  title: '配送信息',
                  lines: [
                    '上海市静安区轻植路 88 号 18F',
                    '联系人：轻植体验用户',
                    '送达时间：今天 12:10 - 12:30',
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Reveal(
                delay: Duration(milliseconds: 140),
                child: _CheckoutStepCard(
                  index: '02',
                  title: '支付方式',
                  lines: [
                    '企业午餐券',
                    '备用方式：微信支付',
                    '备注：无需餐具，优先低温保鲜袋',
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (bundle != null) ...[
                Reveal(
                  delay: const Duration(milliseconds: 190),
                  child: SurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CardSectionHeader(title: '本单来自偏好套餐'),
                        const SizedBox(height: 12),
                        Text(
                          bundle.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bundle.reason,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '结算前仍可替换套餐中的轻饮或加餐，原价会按当前单品重算，但套餐优惠会固定沿用。',
                          style: TextStyle(color: Color(0xFF5D6B5E)),
                        ),
                        const SizedBox(height: 12),
                        ...bundle.slots.map(
                          (slot) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _CheckoutBundleSlotEditor(
                              bundle: bundle,
                              slot: slot,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F3EB),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '价格说明',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                pricingExplanation ?? '',
                                key: const Key(
                                    'checkout-bundle-pricing-explanation'),
                                style: const TextStyle(height: 1.5),
                              ),
                              if (bundleNotes.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                ...bundleNotes.map(
                                  (note) => Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
                                    child: Text('• $note'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              bundle.originalPriceLabel,
                              style: const TextStyle(
                                color: Color(0xFF879283),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              bundle.savingsLabel,
                              style: const TextStyle(
                                color: Color(0xFF345039),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Reveal(
                delay: const Duration(milliseconds: 220),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CardSectionHeader(title: '订单明细'),
                      const SizedBox(height: 12),
                      ...state.bag.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InfoRow(
                            label: '${entry.item.name} x${entry.quantity}',
                            value: '楼${entry.subtotal}',
                          ),
                        ),
                      ),
                      if (state.bundleDiscount > 0) ...[
                        const SizedBox(height: 8),
                        InfoRow(
                          label: '套餐优惠',
                          value: '-楼${state.bundleDiscount}',
                        ),
                      ],
                      const SizedBox(height: 8),
                      InfoRow(label: '配送费', value: '楼${state.deliveryFee}'),
                      const SizedBox(height: 8),
                      InfoRow(label: '需支付', value: '楼${state.total}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Reveal(
                delay: Duration(milliseconds: 300),
                child: _BrandInfoCard(),
              ),
              const SizedBox(height: 24),
              Reveal(
                delay: const Duration(milliseconds: 360),
                child: PressableScale(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF263C2A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(58),
                    ),
                    onPressed: () {
                      state.placeDemoOrder();
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('预约已提交'),
                          content: const Text(
                            '静态订单流程已走通。当前版本未接后端，页面会保留一份默认购物袋用于继续演示。',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context)
                                ..pop()
                                ..pop(),
                              child: const Text('知道了'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('确认预约并提交'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutBundleSlotEditor extends StatelessWidget {
  const _CheckoutBundleSlotEditor({
    required this.bundle,
    required this.slot,
  });

  final BundleRecommendation bundle;
  final BundleSlot slot;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Tag(label: slot.title, color: const Color(0xFFF4F0E7)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${slot.selectedItem.name} ${slot.selectedItem.price}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        if (slot.canReplace) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slot.options.map(
              (option) {
                final selected = option.id == slot.selectedItem.id;
                return ChoiceChip(
                  key: Key(
                    'checkout-bundle-choice-${bundle.id}-${slot.id}-${option.id}',
                  ),
                  label: Text(option.name),
                  selected: selected,
                  onSelected: (_) => state.replaceAppliedBundleItem(
                    slotId: slot.id,
                    item: option,
                  ),
                  selectedColor: const Color(0xFFDDE8CB),
                  backgroundColor: const Color(0xFFF7F3EB),
                  labelStyle: TextStyle(
                    color: selected
                        ? const Color(0xFF345039)
                        : const Color(0xFF546355),
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ],
    );
  }
}

class _CheckoutStepCard extends StatelessWidget {
  const _CheckoutStepCard({
    required this.index,
    required this.title,
    required this.lines,
  });

  final String index;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFDDE8CB),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              index,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Color(0xFF41623F),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ...lines.map(
                  (line) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(line),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandInfoCard extends StatelessWidget {
  const _BrandInfoCard();

  @override
  Widget build(BuildContext context) {
    return const SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '品牌信息',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 12),
          InfoRow(label: '门店计划', value: '城市白领商圈快闪店'),
          SizedBox(height: 8),
          InfoRow(label: '品牌邮箱', value: 'hello@lightdaily.demo'),
          SizedBox(height: 8),
          InfoRow(label: '品牌主张', value: '让每一餐都更轻松'),
        ],
      ),
    );
  }
}
