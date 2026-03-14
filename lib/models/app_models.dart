import 'package:flutter/material.dart';

class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.kcal,
    required this.price,
    required this.category,
    required this.tags,
    required this.icon,
    required this.color,
    required this.badge,
    required this.badgeColor,
    required this.ingredients,
    required this.nutrition,
    required this.scenes,
  });

  final String id;
  final String name;
  final String description;
  final String kcal;
  final String price;
  final String category;
  final List<String> tags;
  final IconData icon;
  final Color color;
  final String badge;
  final Color badgeColor;
  final List<String> ingredients;
  final List<NutritionStat> nutrition;
  final List<String> scenes;

  int get priceValue => int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));

  String get heroTag => 'food-$id';
}

class NutritionStat {
  const NutritionStat({
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;
}

class ArticleItem {
  const ArticleItem({
    required this.title,
    required this.summary,
    required this.tag,
    required this.icon,
    required this.color,
  });

  final String title;
  final String summary;
  final String tag;
  final IconData icon;
  final Color color;
}

class ActionItem {
  const ActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class PreferenceOption {
  const PreferenceOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class OnboardingPreferences {
  const OnboardingPreferences({
    required this.goal,
    required this.taste,
    required this.mealtime,
  });

  final PreferenceOption goal;
  final PreferenceOption taste;
  final PreferenceOption mealtime;

  String get homeTitle => '${goal.title}，从今天这顿开始';

  String get homeSubtitle =>
      '按你偏好的 ${taste.title} 口感和 ${mealtime.title} 场景，先把今天的轻食节奏安排好。';

  String get recommendationTitle => '${mealtime.title}推荐';

  String get recommendationSubtitle =>
      '围绕 ${goal.title} 目标，优先看更适合 ${taste.title} 口感的组合。';

  String get summary =>
      '你更在意 ${goal.title}，偏好 ${taste.title}，主要场景是 ${mealtime.title}。后续首页、推荐和我的页面会先按这个方向承接。';

  List<String> get storyTags => [goal.title, taste.title, mealtime.title];

  String get preferredCategory {
    if (mealtime.id == 'snack') {
      return '低卡小食';
    }
    if (taste.id == 'fresh') {
      return '轻沙拉';
    }
    return '能量碗';
  }

  Map<String, String> get ids => {
        'goal': goal.id,
        'taste': taste.id,
        'mealtime': mealtime.id,
      };
}

class BagEntry {
  const BagEntry({
    required this.item,
    this.quantity = 1,
  });

  final MenuItem item;
  final int quantity;

  BagEntry copyWith({
    MenuItem? item,
    int? quantity,
  }) {
    return BagEntry(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  int get subtotal => item.priceValue * quantity;
}

class BundleSlot {
  const BundleSlot({
    required this.id,
    required this.title,
    required this.selectedItem,
    this.options = const <MenuItem>[],
  });

  final String id;
  final String title;
  final MenuItem selectedItem;
  final List<MenuItem> options;

  BundleSlot copyWith({
    String? id,
    String? title,
    MenuItem? selectedItem,
    List<MenuItem>? options,
  }) {
    return BundleSlot(
      id: id ?? this.id,
      title: title ?? this.title,
      selectedItem: selectedItem ?? this.selectedItem,
      options: options ?? this.options,
    );
  }

  bool get canReplace => options.length > 1;
}

class BundleRecommendation {
  const BundleRecommendation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.reason,
    required this.slots,
    required this.highlightColor,
    required this.discountValue,
  });

  final String id;
  final String title;
  final String subtitle;
  final String reason;
  final List<BundleSlot> slots;
  final Color highlightColor;
  final int discountValue;

  List<MenuItem> get items =>
      slots.map((slot) => slot.selectedItem).toList(growable: false);

  BundleRecommendation copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? reason,
    List<BundleSlot>? slots,
    Color? highlightColor,
    int? discountValue,
  }) {
    return BundleRecommendation(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      reason: reason ?? this.reason,
      slots: slots ?? this.slots,
      highlightColor: highlightColor ?? this.highlightColor,
      discountValue: discountValue ?? this.discountValue,
    );
  }

  BundleRecommendation replaceSlotItem(String slotId, MenuItem item) {
    final updatedSlots = slots
        .map(
          (slot) =>
              slot.id == slotId ? slot.copyWith(selectedItem: item) : slot,
        )
        .toList(growable: false);
    return copyWith(
      slots: updatedSlots,
      subtitle: _subtitleForSlots(updatedSlots),
    );
  }

  int get originalPriceValue =>
      items.fold(0, (sum, item) => sum + item.priceValue);

  int get bundlePriceValue => originalPriceValue - discountValue;

  int get savingsValue => discountValue;

  String get totalPriceLabel => '¥$bundlePriceValue';

  String get originalPriceLabel => '¥$originalPriceValue';

  String get savingsLabel => '立减 ¥$savingsValue';
  static String _subtitleForSlots(List<BundleSlot> slots) =>
      slots.map((slot) => slot.selectedItem.name).join(' + ');
}

class OrderProgressEvent {
  const OrderProgressEvent({
    required this.time,
    required this.title,
    required this.description,
    this.completed = true,
  });

  final String time;
  final String title;
  final String description;
  final bool completed;

  OrderProgressEvent copyWith({
    String? time,
    String? title,
    String? description,
    bool? completed,
  }) {
    return OrderProgressEvent(
      time: time ?? this.time,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

class OrderRecord {
  const OrderRecord({
    required this.id,
    required this.title,
    required this.status,
    required this.schedule,
    required this.totalPrice,
    required this.summary,
    required this.items,
    required this.badgeColor,
    this.bundleTitle,
    this.bundleReason,
    this.deliveryAddress,
    this.paymentMethod,
    this.note,
    this.timeline = const [],
  });

  final String id;
  final String title;
  final String status;
  final String schedule;
  final String totalPrice;
  final String summary;
  final List<String> items;
  final Color badgeColor;
  final String? bundleTitle;
  final String? bundleReason;
  final String? deliveryAddress;
  final String? paymentMethod;
  final String? note;
  final List<OrderProgressEvent> timeline;

  OrderRecord copyWith({
    String? id,
    String? title,
    String? status,
    String? schedule,
    String? totalPrice,
    String? summary,
    List<String>? items,
    Color? badgeColor,
    String? bundleTitle,
    String? bundleReason,
    String? deliveryAddress,
    String? paymentMethod,
    String? note,
    List<OrderProgressEvent>? timeline,
  }) {
    return OrderRecord(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      schedule: schedule ?? this.schedule,
      totalPrice: totalPrice ?? this.totalPrice,
      summary: summary ?? this.summary,
      items: items ?? this.items,
      badgeColor: badgeColor ?? this.badgeColor,
      bundleTitle: bundleTitle ?? this.bundleTitle,
      bundleReason: bundleReason ?? this.bundleReason,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      timeline: timeline ?? this.timeline,
    );
  }

  OrderProgressEvent? get currentProgress {
    for (final event in timeline) {
      if (!event.completed) {
        return event;
      }
    }
    if (timeline.isEmpty) {
      return null;
    }
    return timeline.last;
  }

  String get displayStatus {
    final progress = currentProgress;
    if (progress == null) {
      return status;
    }
    final title = progress.title;
    if (title.contains('骑手配送中')) {
      return '配送中';
    }
    if (title.contains('订单已送达')) {
      return '已完成';
    }
    if (title.contains('订单已评价')) {
      return '已评价';
    }
    if (title.contains('寰呭彇椁') || title.contains('閰嶉€')) {
      return '寰呴厤閫?';
    }
    if (title.contains('鍒朵綔')) {
      return '鍒朵綔涓?';
    }
    if (title.contains('閫佽揪')) {
      return '宸插畬鎴?';
    }
    if (title.contains('褰掓。') || title.contains('璇勪环')) {
      return '宸茶瘎浠?';
    }
    if (title.contains('纭')) {
      return '宸茬‘璁?';
    }
    return status;
  }

  Color get displayBadgeColor {
    switch (displayStatus) {
      case '配送中':
        return const Color(0xFFD9E8F0);
      case '已完成':
      case '宸插畬鎴?':
        return const Color(0xFFF4E1C7);
      case '已评价':
      case '宸茶瘎浠?':
        return const Color(0xFFDCEBEB);
      case '鍒朵綔涓?':
        return const Color(0xFFF7E1CA);
      case '宸茬‘璁?':
        return const Color(0xFFE6EED7);
      case '寰呴厤閫?':
      default:
        return const Color(0xFFDDE8CB);
    }
  }
}
