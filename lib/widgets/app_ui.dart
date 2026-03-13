import 'package:flutter/material.dart';

import '../models/app_models.dart';
import '../pages/food_detail_page.dart';
import '../state/app_state.dart';

void openFoodDetail(BuildContext context, MenuItem item) {
  Navigator.of(context).push(
    PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 420),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) =>
          FoodDetailPage(item: item),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
                    .animate(curved),
            child: child,
          ),
        );
      },
    ),
  );
}

class BrandBadge extends StatelessWidget {
  const BrandBadge({this.dark = false, super.key});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg =
        dark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE2EBCD);
    final fg = dark ? Colors.white : const Color(0xFF476240);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(
            'BRAND SELECT',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: fg),
          ),
        ],
      ),
    );
  }
}

class GlassIcon extends StatelessWidget {
  const GlassIcon({required this.icon, super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))
        ],
      ),
      child: Icon(icon, color: const Color(0xFF406042)),
    );
  }
}

class FoodThumb extends StatelessWidget {
  const FoodThumb({
    required this.color,
    required this.icon,
    required this.width,
    required this.height,
    required this.radius,
    this.heroTag,
    super.key,
  });

  final Color color;
  final IconData icon;
  final double width;
  final double height;
  final double radius;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          color.withValues(alpha: 0.94),
          color.withValues(alpha: 0.62)
        ]),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
              color: Color(0x16000000), blurRadius: 24, offset: Offset(0, 12))
        ],
      ),
      child: Icon(icon, size: height * 0.34, color: Colors.white),
    );
    if (heroTag == null) {
      return child;
    }
    return Hero(tag: heroTag!, child: child);
  }
}

class Tag extends StatelessWidget {
  const Tag({
    required this.label,
    required this.color,
    this.textColor = const Color(0xFF3D563C),
    super.key,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.number,
    required this.label,
    super.key,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _MetricCardBody(number: number, label: label);
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.margin,
    this.radius = 28,
    this.color = Colors.white,
    this.shadow = const BoxShadow(
      color: Color(0x12000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color color;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [shadow],
      ),
      child: child,
    );
  }
}

class GradientFeatureCard extends StatelessWidget {
  const GradientFeatureCard({
    required this.child,
    required this.colors,
    this.padding = const EdgeInsets.all(22),
    this.radius = 30,
    this.shadow = const BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, 14),
    ),
    super.key,
  });

  final Widget child;
  final List<Color> colors;
  final EdgeInsetsGeometry padding;
  final double radius;
  final BoxShadow shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [shadow],
      ),
      child: child,
    );
  }
}

class CardSectionHeader extends StatelessWidget {
  const CardSectionHeader({
    required this.title,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        if (trailing != null) ...[
          const Spacer(),
          trailing!,
        ],
      ],
    );
  }
}

class _MetricCardBody extends StatelessWidget {
  const _MetricCardBody({
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF365039))),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 92,
            child:
                Text(label, style: const TextStyle(color: Color(0xFF6A766A)))),
        Expanded(
            child: Text(value,
                style: const TextStyle(fontWeight: FontWeight.w700))),
      ],
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final selected = state.isFavorite(item);
    return IconButton.filledTonal(
      onPressed: () => state.toggleFavorite(item),
      style: IconButton.styleFrom(
        backgroundColor: selected ? const Color(0xFFDBE8CA) : Colors.white,
      ),
      icon: Icon(selected ? Icons.favorite : Icons.favorite_border,
          color: const Color(0xFF3E5D3F)),
    );
  }
}
