import 'package:flutter/material.dart';

import '../models/app_models.dart';
import 'app_ui.dart';

class ListItemCard extends StatelessWidget {
  const ListItemCard({
    required this.child,
    this.margin = const EdgeInsets.only(bottom: 14),
    this.padding = const EdgeInsets.all(18),
    this.radius = 26,
    this.shadow = const BoxShadow(
      color: Color(0x12000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      margin: margin,
      padding: padding,
      radius: radius,
      shadow: shadow,
      child: child,
    );
  }
}

class FavoriteListItem extends StatelessWidget {
  const FavoriteListItem({
    required this.item,
    required this.onTap,
    super.key,
  });

  final MenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            FoodThumb(
              color: item.color,
              icon: item.icon,
              width: 56,
              height: 56,
              radius: 16,
              heroTag: item.heroTag,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              item.price,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class BagListItem extends StatelessWidget {
  const BagListItem({
    required this.entry,
    required this.onDecrement,
    required this.onIncrement,
    super.key,
  });

  final BagEntry entry;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return ListItemCard(
      radius: 28,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FoodThumb(
            color: entry.item.color,
            icon: entry.item.icon,
            width: 96,
            height: 112,
            radius: 24,
            heroTag: entry.item.heroTag,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Tag(label: entry.item.badge, color: entry.item.badgeColor),
                    const Spacer(),
                    Text(
                      entry.item.price,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  entry.item.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _QtyButton(icon: Icons.remove, onTap: onDecrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '${entry.quantity}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                    _QtyButton(icon: Icons.add, onTap: onIncrement),
                    const Spacer(),
                    Text(
                      '¥${entry.subtotal}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF345039),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderRecordCard extends StatelessWidget {
  const OrderRecordCard({
    required this.order,
    this.margin = const EdgeInsets.only(bottom: 14),
    super.key,
  });

  final OrderRecord order;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return ListItemCard(
      margin: margin,
      padding: const EdgeInsets.all(22),
      radius: 28,
      shadow: const BoxShadow(
        color: Color(0x12000000),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Tag(label: order.status, color: order.badgeColor),
              const Spacer(),
              Text(
                order.totalPrice,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            order.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            order.schedule,
            style: const TextStyle(color: Color(0xFF5E6D60)),
          ),
          const SizedBox(height: 10),
          Text(order.summary, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 12),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Color(0xFF506D49),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF1EBDD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF405F40)),
      ),
    );
  }
}
