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
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
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
  });

  final String id;
  final String title;
  final String status;
  final String schedule;
  final String totalPrice;
  final String summary;
  final List<String> items;
  final Color badgeColor;
}
