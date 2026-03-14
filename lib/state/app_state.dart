import 'package:flutter/widgets.dart';

import '../data/demo_data.dart';
import '../models/app_models.dart';
import 'app_preferences_store.dart';

class AppState extends ChangeNotifier {
  AppState({
    required AppPreferencesStore preferencesStore,
  }) : _preferencesStore = preferencesStore {
    _restoreOnboardingState();
  }

  final AppPreferencesStore _preferencesStore;

  bool _ready = false;
  bool _onboardingComplete = false;
  OnboardingPreferences? _onboardingPreferences;
  BundleRecommendation? _appliedBundleRecommendation;
  final Set<String> _favoriteIds = <String>{};
  final List<BagEntry> _bag = <BagEntry>[
    BagEntry(item: menuItems.first),
  ];
  final List<OrderRecord> _orders = List<OrderRecord>.from(orderRecords);

  bool get ready => _ready;
  bool get onboardingComplete => _onboardingComplete;
  OnboardingPreferences? get onboardingPreferences => _onboardingPreferences;
  OnboardingPreferences get effectivePreferences =>
      _onboardingPreferences ?? defaultOnboardingPreferences;
  Set<String> get favoriteIds => _favoriteIds;
  List<BagEntry> get bag => List.unmodifiable(_bag);
  List<OrderRecord> get orders => List.unmodifiable(_orders);
  List<BundleRecommendation> get bagBundleRecommendations =>
      buildBundleRecommendations(effectivePreferences);
  BundleRecommendation? get checkoutBundleRecommendation =>
      _resolvedAppliedBundleRecommendation;
  BundleRecommendation? get checkoutReferenceBundle {
    final bundle = checkoutBundleRecommendation;
    if (bundle == null) {
      return null;
    }
    for (final candidate in bagBundleRecommendations) {
      if (candidate.id == bundle.id) {
        return candidate;
      }
    }
    return null;
  }

  List<MenuItem> get bagRecommendations {
    final excludedIds = _bag.map((entry) => entry.item.id).toSet();
    final preferences = effectivePreferences;
    final rankedItems = [...menuItems]..sort(
        (a, b) => _bagRecommendationScore(
          b,
          preferences,
        ).compareTo(
          _bagRecommendationScore(a, preferences),
        ),
      );
    return rankedItems
        .where((item) => !excludedIds.contains(item.id))
        .take(3)
        .toList(growable: false);
  }

  int get subtotal => _bag.fold(0, (sum, entry) => sum + entry.subtotal);
  int get bundleDiscount => checkoutBundleRecommendation?.savingsValue ?? 0;
  int get deliveryFee => _bag.isEmpty ? 0 : 6;
  int get total => subtotal + deliveryFee - bundleDiscount;
  int get bagCount => _bag.fold(0, (sum, entry) => sum + entry.quantity);
  List<String> get checkoutBundleChangeNotes {
    final bundle = checkoutBundleRecommendation;
    final reference = checkoutReferenceBundle;
    if (bundle == null || reference == null) {
      return const <String>[];
    }
    final notes = <String>[];
    for (final slot in bundle.slots) {
      final referenceIndex =
          reference.slots.indexWhere((candidate) => candidate.id == slot.id);
      if (referenceIndex < 0) {
        continue;
      }
      final referenceSlot = reference.slots[referenceIndex];
      if (referenceSlot.selectedItem.id != slot.selectedItem.id) {
        notes.add(
          '${slot.title}已从 ${referenceSlot.selectedItem.name} 替换为 ${slot.selectedItem.name}',
        );
      }
    }
    return List<String>.unmodifiable(notes);
  }

  String? get checkoutBundlePricingExplanation {
    final bundle = checkoutBundleRecommendation;
    if (bundle == null) {
      return null;
    }
    return '当前单品总价 ${bundle.originalPriceLabel} - 固定套餐优惠 楼${bundle.discountValue} = ${bundle.totalPriceLabel}';
  }

  BundleRecommendation? get _resolvedAppliedBundleRecommendation {
    final bundle = _appliedBundleRecommendation;
    if (bundle == null) {
      return null;
    }
    final bagIds = _bag.map((entry) => entry.item.id).toSet();
    final bundleIds = bundle.items.map((item) => item.id).toSet();
    if (!bundleIds.every(bagIds.contains)) {
      return null;
    }
    return bundle;
  }

  bool isFavorite(MenuItem item) => _favoriteIds.contains(item.id);

  OrderRecord? orderById(String id) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index < 0) {
      return null;
    }
    return _orders[index];
  }

  Future<void> _restoreOnboardingState() async {
    _onboardingComplete = await _preferencesStore.getHasSeenOnboarding();
    _onboardingPreferences = onboardingPreferencesFromIds(
      await _preferencesStore.getOnboardingPreferenceIds(),
    );
    _ready = true;
    notifyListeners();
  }

  Future<void> completeOnboarding(OnboardingPreferences preferences) async {
    _onboardingPreferences = preferences;
    _onboardingComplete = true;
    notifyListeners();
    await _preferencesStore.setHasSeenOnboarding(true);
    await _preferencesStore.setOnboardingPreferenceIds(preferences.ids);
  }

  Future<void> updatePreferences(OnboardingPreferences preferences) async {
    _onboardingPreferences = preferences;
    notifyListeners();
    await _preferencesStore.setOnboardingPreferenceIds(preferences.ids);
  }

  void reopenOnboarding() {
    _onboardingComplete = false;
    notifyListeners();
  }

  void toggleFavorite(MenuItem item) {
    if (_favoriteIds.contains(item.id)) {
      _favoriteIds.remove(item.id);
    } else {
      _favoriteIds.add(item.id);
    }
    notifyListeners();
  }

  void addToBag(MenuItem item) {
    _upsertBagItem(item, 1);
    _syncAppliedBundleRecommendation();
    notifyListeners();
  }

  void addBundleToBag(BundleRecommendation bundle) {
    for (final item in bundle.items) {
      _upsertBagItem(item, 1);
    }
    _appliedBundleRecommendation = bundle;
    notifyListeners();
  }

  void replaceAppliedBundleItem({
    required String slotId,
    required MenuItem item,
  }) {
    final bundle = _resolvedAppliedBundleRecommendation;
    if (bundle == null) {
      return;
    }
    final index = bundle.slots.indexWhere((slot) => slot.id == slotId);
    if (index < 0) {
      return;
    }
    final currentSlot = bundle.slots[index];
    if (currentSlot.selectedItem.id == item.id) {
      return;
    }
    _upsertBagItem(currentSlot.selectedItem, -1);
    _upsertBagItem(item, 1);
    _appliedBundleRecommendation = bundle.replaceSlotItem(slotId, item);
    _syncAppliedBundleRecommendation();
    notifyListeners();
  }

  void updateBagQuantity(MenuItem item, int quantity) {
    final index = _bag.indexWhere((entry) => entry.item.id == item.id);
    if (index < 0) {
      return;
    }
    if (quantity <= 0) {
      _bag.removeAt(index);
    } else {
      _bag[index] = _bag[index].copyWith(quantity: quantity);
    }
    _syncAppliedBundleRecommendation();
    notifyListeners();
  }

  void placeDemoOrder() {
    final items =
        _bag.map((entry) => '${entry.item.name} x${entry.quantity}').toList();
    final totalValue = total;
    final bundle = checkoutBundleRecommendation;
    _orders.insert(
      0,
      OrderRecord(
        id: 'order-${DateTime.now().microsecondsSinceEpoch}',
        title: bundle?.title ?? '最新轻食预定',
        status: '待配送',
        schedule: '2026-03-13 12:10 - 12:30',
        totalPrice: '楼$totalValue',
        summary: bundle == null
            ? '静态演示订单已创建，可继续用于预定记录和订单历史展示。'
            : '这次订单来自你的偏好套餐推荐，可继续用于预定记录和订单历史展示。',
        items: items,
        badgeColor: const Color(0xFFDDE8CB),
        bundleTitle: bundle?.title,
        bundleReason: bundle?.reason,
        deliveryAddress: '上海市静安区轻植路 88 号 18F',
        paymentMethod: '企业午餐券 / 微信支付',
        note: bundle == null ? '无需餐具' : '由偏好套餐一键加入，已保留当前轻食场景备注。',
        timeline: [
          const OrderProgressEvent(
            time: '11:42',
            title: '订单已确认',
            description: '系统已记录本次静态预定，门店开始准备餐品。',
          ),
          const OrderProgressEvent(
            time: '11:55',
            title: '餐品制作中',
            description: '门店正在完成打包，准备进入配送阶段。',
          ),
          OrderProgressEvent(
            time: '12:08',
            title: '骑手待取餐',
            description:
                bundle == null ? '当前订单已进入取餐前状态。' : '本单来自偏好套餐推荐，准备按预定时间出发配送。',
            completed: false,
          ),
        ],
      ),
    );
    _appliedBundleRecommendation = null;
    _bag
      ..clear()
      ..add(BagEntry(item: menuItems[2]));
    notifyListeners();
  }

  bool canAdvanceOrderProgress(String orderId) {
    final order = orderById(orderId);
    return order != null && _nextOrderProgressEvent(order) != null;
  }

  void advanceOrderProgress(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index < 0) {
      return;
    }
    final order = _orders[index];
    final currentProgress = order.currentProgress;
    final nextProgress = _nextOrderProgressEvent(order);
    if (currentProgress == null || nextProgress == null) {
      return;
    }
    final currentIndex = order.timeline.indexOf(currentProgress);
    if (currentIndex < 0) {
      return;
    }
    final updatedTimeline = List<OrderProgressEvent>.from(order.timeline);
    updatedTimeline[currentIndex] = currentProgress.copyWith(completed: true);
    updatedTimeline.add(nextProgress);
    _orders[index] = order.copyWith(
      timeline: List<OrderProgressEvent>.unmodifiable(updatedTimeline),
    );
    notifyListeners();
  }

  void _upsertBagItem(MenuItem item, int quantityDelta) {
    final index = _bag.indexWhere((entry) => entry.item.id == item.id);
    if (index < 0) {
      if (quantityDelta > 0) {
        _bag.add(BagEntry(item: item, quantity: quantityDelta));
      }
      return;
    }
    final nextQuantity = _bag[index].quantity + quantityDelta;
    if (nextQuantity <= 0) {
      _bag.removeAt(index);
      return;
    }
    _bag[index] = _bag[index].copyWith(quantity: nextQuantity);
  }

  void _syncAppliedBundleRecommendation() {
    if (_resolvedAppliedBundleRecommendation == null) {
      _appliedBundleRecommendation = null;
    }
  }

  int _bagRecommendationScore(
    MenuItem item,
    OnboardingPreferences preferences,
  ) {
    var score = 0;
    if (item.category == preferences.preferredCategory) {
      score += 5;
    }
    if (item.scenes
        .any((scene) => scene.contains(preferences.mealtime.title))) {
      score += 4;
    }
    if (preferences.taste.id == 'fresh' &&
        item.tags.any((tag) => tag.contains('娓呯埥') || tag.contains('椴滆敩'))) {
      score += 3;
    }
    if (preferences.taste.id == 'warm' &&
        item.tags.any((tag) => tag.contains('楗辫吂') || tag.contains('澶嶅悎纰虫按'))) {
      score += 3;
    }
    if (preferences.taste.id == 'sweet' &&
        item.tags.any((tag) => tag.contains('杞荤敎') || tag.contains('鍔犻'))) {
      score += 3;
    }
    if (preferences.goal.id == 'protein' &&
        item.tags.any((tag) => tag.contains('楂樿泲鐧'))) {
      score += 3;
    }
    if (preferences.goal.id == 'shape' &&
        item.tags.any((tag) => tag.contains('杞昏礋鎷') || tag.contains('浣庡崱'))) {
      score += 3;
    }
    if (preferences.goal.id == 'steady' &&
        item.scenes
            .any((scene) => scene.contains('宸ヤ綔鏃') || scene.contains('涓嬪崍'))) {
      score += 3;
    }
    return score;
  }
}

List<BundleRecommendation> buildBundleRecommendations(
  OnboardingPreferences preferences,
) {
  final primary = preferredPrimaryItem(preferences);
  final snack = preferredSnackItem(preferences);
  final drink = preferredDrinkItem();

  BundleRecommendation lunchBundle() => BundleRecommendation(
        id: 'bundle-lunch-${preferences.goal.id}',
        title: '${preferences.mealtime.title}稳态组合',
        subtitle: '${primary.name} + ${drink.name}',
        reason: '优先围绕 ${preferences.goal.title} 组织这顿主餐，搭配一份轻饮让决策更快完成。',
        slots: [
          _bundleSlot('primary', '主餐', primary),
          _bundleSlot('drink', '轻饮', drink),
        ],
        highlightColor: primary.badgeColor,
        discountValue: 4,
      );

  BundleRecommendation snackBundle() => BundleRecommendation(
        id: 'bundle-snack-${preferences.taste.id}',
        title: '${preferences.mealtime.title}补能组合',
        subtitle: '${snack.name} + ${drink.name}',
        reason: '按 ${preferences.taste.title} 的口感方向，先给购物袋补一套更轻一点但不空的组合。',
        slots: [
          _bundleSlot('snack', '加餐', snack),
          _bundleSlot('drink', '轻饮', drink),
        ],
        highlightColor: snack.badgeColor,
        discountValue: 3,
      );

  BundleRecommendation trainingBundle() => BundleRecommendation(
        id: 'bundle-training-${preferences.goal.id}',
        title: '训练后恢复组合',
        subtitle: '${primary.name} + ${snack.name}',
        reason: '围绕 ${preferences.goal.title} 补充蛋白和恢复感，适合一次性加入购物袋。',
        slots: [
          _bundleSlot('primary', '主餐', primary),
          _bundleSlot('snack', '加餐', snack),
        ],
        highlightColor: const Color(0xFFE3EDD2),
        discountValue: 5,
      );

  if (preferences.mealtime.id == 'snack') {
    return [
      snackBundle(),
      BundleRecommendation(
        id: 'bundle-snack-balance-${preferences.goal.id}',
        title: '轻甜平衡组合',
        subtitle: '${snack.name} + ${primary.name}',
        reason: '如果这次不只想加餐，也可以补一份小主餐把饱腹感拉起来。',
        slots: [
          _bundleSlot('snack', '加餐', snack),
          _bundleSlot('primary', '主餐', primary),
        ],
        highlightColor: const Color(0xFFF4D8DE),
        discountValue: 4,
      ),
    ];
  }
  if (preferences.mealtime.id == 'training') {
    return [
      trainingBundle(),
      BundleRecommendation(
        id: 'bundle-training-refresh-${preferences.taste.id}',
        title: '恢复后清爽组合',
        subtitle: '${primary.name} + ${drink.name}',
        reason: '训练后如果更想吃得清一点，这组会比完整加餐更轻负担。',
        slots: [
          _bundleSlot('primary', '主餐', primary),
          _bundleSlot('drink', '轻饮', drink),
        ],
        highlightColor: const Color(0xFFD9F0EB),
        discountValue: 4,
      ),
    ];
  }
  return [
    lunchBundle(),
    BundleRecommendation(
      id: 'bundle-lunch-extended-${preferences.goal.id}',
      title: '午餐加餐组合',
      subtitle: '${primary.name} + ${snack.name}',
      reason: '如果今天节奏更长，这组适合提前把午后加餐也一起放进购物袋。',
      slots: [
        _bundleSlot('primary', '主餐', primary),
        _bundleSlot('snack', '加餐', snack),
      ],
      highlightColor: const Color(0xFFF4E1C7),
      discountValue: 6,
    ),
  ];
}

BundleSlot _bundleSlot(
  String id,
  String title,
  MenuItem selectedItem,
) {
  return BundleSlot(
    id: id,
    title: title,
    selectedItem: selectedItem,
    options: _replacementOptionsForSlot(id),
  );
}

List<MenuItem> _replacementOptionsForSlot(String slotId) {
  switch (slotId) {
    case 'primary':
      return _itemsByIds(
        const [
          'grilled-chicken-bowl',
          'avocado-shrimp-salad',
          'pumpkin-quinoa-bowl',
        ],
      );
    case 'snack':
      return _itemsByIds(
        const [
          'berry-yogurt-cup',
          'cocoa-energy-bites',
        ],
      );
    case 'drink':
      return _itemsByIds(
        const [
          'lime-sparkling',
          'cold-brew-oat',
        ],
      );
    default:
      return const <MenuItem>[];
  }
}

List<MenuItem> _itemsByIds(List<String> ids) {
  final items = <MenuItem>[];
  for (final id in ids) {
    final index = menuItems.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items.add(menuItems[index]);
    }
  }
  return List<MenuItem>.unmodifiable(items);
}

OrderProgressEvent? _nextOrderProgressEvent(OrderRecord order) {
  final current = order.currentProgress;
  if (current == null) {
    return null;
  }
  if (current.title.contains('订单已评价')) {
    return null;
  }
  if (current.title.contains('订单已送达')) {
    return const OrderProgressEvent(
      time: '12:38',
      title: '订单已评价',
      description: '用户已完成这次套餐反馈，订单进入可复购参考状态。',
      completed: false,
    );
  }
  if (current.title.contains('骑手配送中')) {
    return const OrderProgressEvent(
      time: '12:24',
      title: '订单已送达',
      description: '餐品已经送达预定地址，等待用户签收与反馈。',
      completed: false,
    );
  }
  if (current.title.contains('骑手待取餐')) {
    return const OrderProgressEvent(
      time: '12:16',
      title: '骑手配送中',
      description: '骑手已经取到餐，正在按预定线路配送中。',
      completed: false,
    );
  }
  if (current.title.contains('餐品制作中')) {
    return const OrderProgressEvent(
      time: '12:08',
      title: '骑手待取餐',
      description: '门店已打包完成，等待骑手到店取餐。',
      completed: false,
    );
  }
  if (current.title.contains('订单已确认')) {
    return const OrderProgressEvent(
      time: '11:55',
      title: '餐品制作中',
      description: '门店正在完成本单制作和打包。',
      completed: false,
    );
  }
  return null;
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }

  static AppState read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<AppStateScope>();
    final scope = element?.widget as AppStateScope?;
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}
