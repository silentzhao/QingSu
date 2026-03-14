import 'package:flutter/material.dart';

import '../models/app_models.dart';
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
    final preferences = state.effectivePreferences;
    final bundles = state.bagBundleRecommendations;
    final recommendations = state.bagRecommendations;
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const Reveal(
              delay: Duration(milliseconds: 40),
              child: Text(
                '购物袋',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 6),
            const Reveal(
              delay: Duration(milliseconds: 90),
              child: Text(
                '先把静态套餐、配送和下单信息做完整，再继续往真实 API 接线。',
              ),
            ),
            const SizedBox(height: 20),
            ...bag.asMap().entries.map(
                  (entry) => Reveal(
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
                  ),
                ),
            const SizedBox(height: 16),
            Reveal(
              delay: const Duration(milliseconds: 360),
              child: _DeliveryCard(preferences: preferences),
            ),
            const SizedBox(height: 16),
            if (bundles.isNotEmpty) ...[
              Reveal(
                delay: const Duration(milliseconds: 390),
                child: _BagBundleCard(
                  preferences: preferences,
                  bundles: bundles,
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (recommendations.isNotEmpty) ...[
              Reveal(
                delay: const Duration(milliseconds: 405),
                child: _BagRecommendationCard(
                  preferences: preferences,
                  recommendations: recommendations,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Reveal(
              delay: const Duration(milliseconds: 420),
              child: SurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CardSectionHeader(title: '金额汇总'),
                    const SizedBox(height: 14),
                    InfoRow(label: '商品小计', value: '楼${state.subtotal}'),
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
                    InfoRow(label: '合计', value: '楼${state.total}'),
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
                                    builder: (_) => const CheckoutPage(),
                                  ),
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
  const _DeliveryCard({
    required this.preferences,
  });

  final OnboardingPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return GradientFeatureCard(
      colors: const [Color(0xFF2D4B36), Color(0xFF6E8E56)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandBadge(dark: true),
          const SizedBox(height: 14),
          const Text(
            '本次配送建议',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${preferences.mealtime.title} 优先安排在 12:10-12:30 这个静态配送窗，当前建议也会按 ${preferences.goal.title} 的方向去组合主餐和轻饮。',
            style: const TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _BagRecommendationCard extends StatelessWidget {
  const _BagRecommendationCard({
    required this.preferences,
    required this.recommendations,
  });

  final OnboardingPreferences preferences;
  final List<MenuItem> recommendations;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardSectionHeader(
            title: '按偏好补一件',
            trailing: Tag(
              label: preferences.mealtime.title,
              color: const Color(0xFFDDE8CB),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '围绕 ${preferences.goal.title} 和 ${preferences.taste.title}，先补几项更适合这次购物袋的组合。',
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 16),
          ...recommendations.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == recommendations.length - 1 ? 0 : 12,
                  ),
                  child: _BagRecommendationItem(
                    item: entry.value,
                    onOpen: () => openFoodDetail(context, entry.value),
                    onAdd: () => state.addToBag(entry.value),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _BagBundleCard extends StatelessWidget {
  const _BagBundleCard({
    required this.preferences,
    required this.bundles,
  });

  final OnboardingPreferences preferences;
  final List<BundleRecommendation> bundles;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardSectionHeader(
            title: '一键补齐套餐',
            trailing: Tag(
              label: preferences.goal.title,
              color: const Color(0xFFF3EDE2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '这组推荐不只是一件单品，而是直接按 ${preferences.mealtime.title} 场景补成可下单的组合。你也可以先替换轻饮或加餐再加入。',
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 16),
          ...bundles.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key == bundles.length - 1 ? 0 : 14,
                  ),
                  child: _BagBundleItem(bundle: entry.value),
                ),
              ),
        ],
      ),
    );
  }
}

class _BagBundleItem extends StatefulWidget {
  const _BagBundleItem({
    required this.bundle,
  });

  final BundleRecommendation bundle;

  @override
  State<_BagBundleItem> createState() => _BagBundleItemState();
}

class _BagBundleItemState extends State<_BagBundleItem> {
  late BundleRecommendation _draftBundle;

  @override
  void initState() {
    super.initState();
    _draftBundle = widget.bundle;
  }

  @override
  void didUpdateWidget(covariant _BagBundleItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bundle.id != widget.bundle.id ||
        oldWidget.bundle.subtitle != widget.bundle.subtitle) {
      _draftBundle = widget.bundle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E0D5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _draftBundle.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Tag(
                label: _draftBundle.totalPriceLabel,
                color: _draftBundle.highlightColor,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(_draftBundle.subtitle),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                _draftBundle.originalPriceLabel,
                style: const TextStyle(
                  color: Color(0xFF879283),
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _draftBundle.savingsLabel,
                style: const TextStyle(
                  color: Color(0xFF345039),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _draftBundle.reason,
            style: const TextStyle(height: 1.5, color: Color(0xFF5B6B5D)),
          ),
          const SizedBox(height: 14),
          ..._draftBundle.slots.map(
            (slot) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _BundleSlotEditor(
                bundle: _draftBundle,
                slot: slot,
                choiceKeyPrefix: 'bundle-choice',
                onChanged: (item) {
                  setState(() {
                    _draftBundle = _draftBundle.replaceSlotItem(slot.id, item);
                  });
                },
              ),
            ),
          ),
          _BundlePricingPreview(
            bundle: _draftBundle,
            referenceBundle: widget.bundle,
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              key: Key('bundle-add-${_draftBundle.id}'),
              onPressed: () {
                state.addBundleToBag(_draftBundle);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${_draftBundle.title} 已加入购物袋')),
                );
              },
              child: const Text('一键加入套餐'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BundlePricingPreview extends StatelessWidget {
  const _BundlePricingPreview({
    required this.bundle,
    required this.referenceBundle,
  });

  final BundleRecommendation bundle;
  final BundleRecommendation referenceBundle;

  @override
  Widget build(BuildContext context) {
    final changedNotes = <String>[];
    for (final slot in bundle.slots) {
      final referenceIndex = referenceBundle.slots.indexWhere(
        (candidate) => candidate.id == slot.id,
      );
      if (referenceIndex < 0) {
        continue;
      }
      final referenceSlot = referenceBundle.slots[referenceIndex];
      if (referenceSlot.selectedItem.id != slot.selectedItem.id) {
        changedNotes.add(
          '${slot.title}已从 ${referenceSlot.selectedItem.name} 替换为 ${slot.selectedItem.name}',
        );
      }
    }

    return Container(
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
            '价格预览',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '当前单品总价 ${bundle.originalPriceLabel} - 固定套餐优惠 楼${bundle.discountValue} = ${bundle.totalPriceLabel}',
            key: Key('bag-bundle-pricing-${bundle.id}'),
            style: const TextStyle(height: 1.5),
          ),
          if (changedNotes.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...changedNotes.map(
              (note) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('• $note'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BundleSlotEditor extends StatelessWidget {
  const _BundleSlotEditor({
    required this.bundle,
    required this.slot,
    required this.choiceKeyPrefix,
    required this.onChanged,
  });

  final BundleRecommendation bundle;
  final BundleSlot slot;
  final String choiceKeyPrefix;
  final ValueChanged<MenuItem> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Tag(
              label: slot.title,
              color: const Color(0xFFF4F0E7),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => openFoodDetail(context, slot.selectedItem),
                child: Row(
                  children: [
                    FoodThumb(
                      color: slot.selectedItem.color,
                      icon: slot.selectedItem.icon,
                      width: 44,
                      height: 44,
                      radius: 14,
                      heroTag: slot.selectedItem.heroTag,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        slot.selectedItem.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      slot.selectedItem.price,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (slot.canReplace) ...[
          const SizedBox(height: 10),
          const Text(
            '可替换同类项',
            style: TextStyle(
              color: Color(0xFF617263),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slot.options.map(
              (option) {
                final selected = option.id == slot.selectedItem.id;
                return ChoiceChip(
                  key: Key(
                    '$choiceKeyPrefix-${bundle.id}-${slot.id}-${option.id}',
                  ),
                  label: Text(option.name),
                  selected: selected,
                  onSelected: (_) => onChanged(option),
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

class _BagRecommendationItem extends StatelessWidget {
  const _BagRecommendationItem({
    required this.item,
    required this.onOpen,
    required this.onAdd,
  });

  final MenuItem item;
  final VoidCallback onOpen;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onOpen,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F4EC),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FoodThumb(
              color: item.color,
              icon: item.icon,
              width: 72,
              height: 72,
              radius: 20,
              heroTag: item.heroTag,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Text(
                        item.price,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: item.tags
                              .take(2)
                              .map(
                                (tag) => Tag(
                                  label: tag,
                                  color: const Color(0xFFEFE7D8),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.tonal(
                        onPressed: onAdd,
                        child: const Text('加入'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
