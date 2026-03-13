import 'package:flutter/widgets.dart';

import '../data/demo_data.dart';
import '../models/app_models.dart';

class AppState extends ChangeNotifier {
  bool _onboardingComplete = false;
  final Set<String> _favoriteIds = <String>{};
  final List<BagEntry> _bag = <BagEntry>[
    BagEntry(item: menuItems.first),
  ];
  final List<OrderRecord> _orders = List<OrderRecord>.from(orderRecords);

  bool get onboardingComplete => _onboardingComplete;
  Set<String> get favoriteIds => _favoriteIds;
  List<BagEntry> get bag => List.unmodifiable(_bag);
  List<OrderRecord> get orders => List.unmodifiable(_orders);

  int get subtotal => _bag.fold(0, (sum, entry) => sum + entry.subtotal);
  int get deliveryFee => _bag.isEmpty ? 0 : 6;
  int get total => subtotal + deliveryFee;
  int get bagCount => _bag.fold(0, (sum, entry) => sum + entry.quantity);

  bool isFavorite(MenuItem item) => _favoriteIds.contains(item.id);

  void completeOnboarding() {
    if (_onboardingComplete) {
      return;
    }
    _onboardingComplete = true;
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
    final index = _bag.indexWhere((entry) => entry.item.id == item.id);
    if (index >= 0) {
      _bag[index] = _bag[index].copyWith(quantity: _bag[index].quantity + 1);
    } else {
      _bag.add(BagEntry(item: item));
    }
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
    notifyListeners();
  }

  void placeDemoOrder() {
    final items =
        _bag.map((entry) => '${entry.item.name} x${entry.quantity}').toList();
    final totalValue = total;
    _orders.insert(
      0,
      OrderRecord(
        id: 'order-${DateTime.now().microsecondsSinceEpoch}',
        title: '最新轻食预约',
        status: '待配送',
        schedule: '2026-03-13 12:10 - 12:30',
        totalPrice: '¥$totalValue',
        summary: '静态演示订单已创建，可继续用于预约记录和订单历史展示。',
        items: items,
        badgeColor: const Color(0xFFDDE8CB),
      ),
    );
    _bag
      ..clear()
      ..add(BagEntry(item: menuItems[2]));
    notifyListeners();
  }
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
