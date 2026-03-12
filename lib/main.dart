import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const LightFoodDemoApp());

class LightFoodDemoApp extends StatelessWidget {
  const LightFoodDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '轻植日常',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF789B56),
          brightness: Brightness.light,
          surface: const Color(0xFFF6F1E8),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F1E8),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final pages = const [HomePage(), RecommendPage(), InspirePage(), ActionPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 420),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(
            begin: const Offset(0.04, 0),
            end: Offset.zero,
          ).animate(animation);
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_index),
          child: pages[_index],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: NavigationBar(
            height: 78,
            backgroundColor: Colors.white.withValues(alpha: 0.92),
            indicatorColor: const Color(0xFFDDE8CB),
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: '首页'),
              NavigationDestination(icon: Icon(Icons.lunch_dining_outlined), selectedIcon: Icon(Icons.lunch_dining), label: '推荐'),
              NavigationDestination(icon: Icon(Icons.auto_stories_outlined), selectedIcon: Icon(Icons.auto_stories), label: '灵感'),
              NavigationDestination(icon: Icon(Icons.favorite_outline), selectedIcon: Icon(Icons.favorite), label: '预约'),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 18)),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 40),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BrandBadge(),
                              SizedBox(height: 14),
                              Text('轻植日常', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                              SizedBox(height: 4),
                              Text('吃得轻一点，状态好很多'),
                            ],
                          ),
                        ),
                        GlassIcon(icon: Icons.spa_outlined),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Reveal(
                  delay: const Duration(milliseconds: 120),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.18,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: HeroCard(item: menuItems.first),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 220),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 0),
                    child: Row(
                      children: [
                        Expanded(child: MetricCard(number: '24h', label: '轻负担感知')),
                        SizedBox(width: 12),
                        Expanded(child: MetricCard(number: '12+', label: '轻食组合')),
                        SizedBox(width: 12),
                        Expanded(child: MetricCard(number: '4.9', label: '试吃反馈')),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Reveal(delay: Duration(milliseconds: 280), child: SectionTitle(title: '今日主推', subtitle: '首页做成活动页质感，品牌才立得住'))),
              SliverToBoxAdapter(
                child: Reveal(
                  delay: const Duration(milliseconds: 340),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.1,
                    child: SizedBox(
                      height: 256,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, i) => HighlightCard(item: menuItems[i]),
                        separatorBuilder: (_, __) => const SizedBox(width: 14),
                        itemCount: 3,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Reveal(delay: Duration(milliseconds: 420), child: SectionTitle(title: '轻食价值', subtitle: '第一版先突出卖点和情绪价值'))),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 480),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ValueCard(icon: Icons.monitor_weight_outlined, title: '热量清晰', subtitle: '每份搭配一眼看懂。'),
                        ValueCard(icon: Icons.eco_outlined, title: '现配现鲜', subtitle: '食材组合更有层次。'),
                        ValueCard(icon: Icons.favorite_outline, title: '容易坚持', subtitle: '不是极端克制，而是长期舒服地吃。'),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Reveal(delay: Duration(milliseconds: 560), child: SectionTitle(title: '品牌故事', subtitle: '让用户感觉这不只是菜单，而是一套生活方式'))),
              const SliverToBoxAdapter(
                child: Reveal(
                  delay: Duration(milliseconds: 620),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: StoryCard(tags: ['高蛋白搭配', '适合工作日午餐', '清爽但有饱腹感']),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
      ),
    );
  }
}

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> {
  int selectedCategory = 0;
  final categories = const ['主推', '能量碗', '轻沙拉', '低卡小食', '轻饮品'];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = selectedCategory == 0
        ? menuItems
        : menuItems.where((e) => e.category == categories[selectedCategory]).toList();

    return AppBackdrop(
      child: AnimatedBuilder(
        animation: _scrollController,
        builder: (context, _) {
          final offset = _scrollController.hasClients ? _scrollController.offset : 0.0;
          return SafeArea(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                const Reveal(
                  delay: Duration(milliseconds: 40),
                  child: Text('今天吃点轻松的', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 6),
                const Reveal(
                  delay: Duration(milliseconds: 90),
                  child: Text('把推荐页做得像精品品牌橱窗，用户才会想继续往下看。'),
                ),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 150),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.12,
                    child: const DiscoverBar(),
                  ),
                ),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 220),
                  child: SizedBox(
                    height: 46,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) => AnimatedScale(
                        duration: const Duration(milliseconds: 220),
                        scale: selectedCategory == i ? 1.0 : 0.96,
                        child: FilterChip(
                          label: Text(categories[i]),
                          selected: selectedCategory == i,
                          showCheckmark: false,
                          side: BorderSide.none,
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFFDDE8CB),
                          onSelected: (_) => setState(() => selectedCategory = i),
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemCount: categories.length,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Reveal(
                  delay: const Duration(milliseconds: 280),
                  child: ParallaxShift(
                    offset: offset,
                    factor: 0.16,
                    child: const CampaignBanner(),
                  ),
                ),
                const SizedBox(height: 18),
                ...items.asMap().entries.map(
                      (entry) => Reveal(
                        delay: Duration(milliseconds: 320 + (entry.key * 70)),
                        child: ProductCard(item: entry.value),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class InspirePage extends StatelessWidget {
  const InspirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            const Reveal(delay: Duration(milliseconds: 40), child: Text('饮食灵感', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800))),
            const SizedBox(height: 6),
            const Reveal(delay: Duration(milliseconds: 90), child: Text('用内容页把品牌的方法论和调性讲清楚。')),
            const SizedBox(height: 18),
            const Reveal(delay: Duration(milliseconds: 150), child: ContentHero()),
            const SizedBox(height: 18),
            ...articles.asMap().entries.map((entry) => Reveal(delay: Duration(milliseconds: 220 + (entry.key * 70)), child: ArticleCard(item: entry.value))),
            const SizedBox(height: 8),
            const Reveal(delay: Duration(milliseconds: 420), child: Text('轻知识', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
            const SizedBox(height: 12),
            ...tips.asMap().entries.map((entry) => Reveal(delay: Duration(milliseconds: 480 + (entry.key * 60)), child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InsightCard(text: entry.value),
                ))),
          ],
        ),
      ),
    );
  }
}

class ActionPage extends StatelessWidget {
  const ActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackdrop(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            Reveal(
              delay: const Duration(milliseconds: 50),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2D4B36), Color(0xFF6E8E56)]),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 24, offset: Offset(0, 14))],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BrandBadge(dark: true),
                    SizedBox(height: 14),
                    Text('轻一点开始', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('让商业转化入口在第一版就成立。', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            ...actions.asMap().entries.map((entry) => Reveal(delay: Duration(milliseconds: 140 + (entry.key * 70)), child: ActionCard(item: entry.value))),
            const SizedBox(height: 10),
            const Reveal(
              delay: Duration(milliseconds: 380),
              child: _BrandInfoCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandInfoCard extends StatelessWidget {
  const _BrandInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12))],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('品牌信息', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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

class Reveal extends StatefulWidget {
  const Reveal({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.offset = const Offset(0, 0.06),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.offset,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

class HoverLift extends StatefulWidget {
  const HoverLift({required this.child, super.key});

  final Widget child;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final dy = _hovering ? -6.0 : 0.0;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translateByDouble(0.0, dy, 0.0, 1.0),
        child: widget.child,
      ),
    );
  }
}

class FloatingBob extends StatefulWidget {
  const FloatingBob({
    required this.child,
    this.amplitude = 6,
    this.duration = const Duration(milliseconds: 3600),
    super.key,
  });

  final Widget child;
  final double amplitude;
  final Duration duration;

  @override
  State<FloatingBob> createState() => _FloatingBobState();
}

class _FloatingBobState extends State<FloatingBob> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
  late final Animation<double> _offset = Tween<double>(
    begin: -widget.amplitude,
    end: widget.amplitude,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offset,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offset.value),
          child: child,
        );
      },
    );
  }
}

class ParallaxShift extends StatelessWidget {
  const ParallaxShift({
    required this.child,
    required this.offset,
    this.factor = 0.12,
    super.key,
  });

  final Widget child;
  final double offset;
  final double factor;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -(offset * factor)),
      child: child,
    );
  }
}

class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, super.key});

  final Widget child;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value && mounted) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.965 : 1.0;
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

void openFoodDetail(BuildContext context, MenuItem item) {
  Navigator.of(context).push(_foodDetailRoute(item));
}

PageRouteBuilder<void> _foodDetailRoute(MenuItem item) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) => FoodDetailPage(item: item),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFFF6F1E8)),
        const Positioned(top: -80, left: -20, child: Halo(size: 240, color: Color(0x33D0E0B3))),
        const Positioned(top: 180, right: -90, child: Halo(size: 220, color: Color(0x1FEF9E6C))),
        const Positioned.fill(child: ParticleField()),
        child,
      ],
    );
  }
}

class ParticleField extends StatefulWidget {
  const ParticleField({super.key});

  @override
  State<ParticleField> createState() => _ParticleFieldState();
}

class _ParticleFieldState extends State<ParticleField> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 9000),
  )..repeat();

  static const _particles = <_Particle>[
    _Particle(x: 0.12, y: 0.18, size: 8, drift: 18, color: Color(0x2894B86B)),
    _Particle(x: 0.84, y: 0.12, size: 10, drift: 22, color: Color(0x22F0A06B)),
    _Particle(x: 0.22, y: 0.48, size: 6, drift: 16, color: Color(0x1E6FA689)),
    _Particle(x: 0.72, y: 0.38, size: 12, drift: 26, color: Color(0x1CA6C975)),
    _Particle(x: 0.55, y: 0.72, size: 7, drift: 20, color: Color(0x22E3BB88)),
    _Particle(x: 0.88, y: 0.78, size: 9, drift: 24, color: Color(0x1891BCA1)),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ParticlePainter(progress: _controller.value, particles: _particles),
        ),
      ),
    );
  }
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.drift,
    required this.color,
  });

  final double x;
  final double y;
  final double size;
  final double drift;
  final Color color;
}

class _ParticlePainter extends CustomPainter {
  const _ParticlePainter({required this.progress, required this.particles});

  final double progress;
  final List<_Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final shift = particle.drift * (0.5 - (progress + (i * 0.11)) % 1);
      final opacity = 0.45 + 0.25 * math.sin((progress * 6.283) + i).abs();
      final paint = Paint()..color = particle.color.withValues(alpha: opacity);
      final dx = size.width * particle.x;
      final dy = (size.height * particle.y) + shift;
      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class Halo extends StatelessWidget {
  const Halo({required this.size, required this.color, super.key});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)])),
    );
  }
}

class BrandBadge extends StatelessWidget {
  const BrandBadge({this.dark = false, super.key});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFE2EBCD);
    final fg = dark ? Colors.white : const Color(0xFF476240);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, size: 16, color: fg),
          const SizedBox(width: 6),
          Text('BRAND SELECT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: fg)),
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
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Icon(icon, color: const Color(0xFF406042)),
    );
  }
}

class HeroCard extends StatelessWidget {
  const HeroCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: FloatingBob(
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF2C4D35), Color(0xFF6C9653), Color(0xFFD5E5AA)]),
            borderRadius: BorderRadius.circular(36),
            boxShadow: const [BoxShadow(color: Color(0x24000000), blurRadius: 30, offset: Offset(0, 18))],
          ),
          child: Stack(
            children: [
              Positioned(right: -6, top: 20, child: Halo(size: 140, color: Colors.white.withValues(alpha: 0.1))),
              Positioned(
                right: 18,
                top: 52,
                child: FloatingBob(
                  amplitude: 8,
                  duration: const Duration(milliseconds: 3200),
                  child: FoodThumb(color: item.color, icon: item.icon, width: 126, height: 126, radius: 34, heroTag: item.heroTag),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(999)),
                    child: const Text('SPRING CAMPAIGN', style: TextStyle(fontSize: 11, letterSpacing: 0.9, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(width: 210, child: Text('重新认识轻食', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, height: 0.98, color: Colors.white))),
                  const SizedBox(height: 12),
                  const SizedBox(width: 230, child: Text('不是吃得更少，而是吃得更好。把品牌主张和招牌单品一次讲清楚。', style: TextStyle(color: Colors.white, height: 1.45))),
                  const SizedBox(height: 22),
                  const Wrap(spacing: 10, runSpacing: 10, children: [Tag(label: '高蛋白', color: Color(0x33FFFFFF), textColor: Colors.white), Tag(label: '午餐友好', color: Color(0x33FFFFFF), textColor: Colors.white), Tag(label: '好吃不将就', color: Color(0x33FFFFFF), textColor: Colors.white)]),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      PressableScale(
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFF1B16A), foregroundColor: const Color(0xFF1F2A18)),
                          onPressed: () => openFoodDetail(context, item),
                          child: const Text('立即预览'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      PressableScale(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), foregroundColor: Colors.white),
                          onPressed: () => openFoodDetail(context, item),
                          child: const Text('查看菜单'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white))),
                      Text(item.price, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({required this.number, required this.label, super.key});

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF365039))),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ]),
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle),
      ]),
    );
  }
}

class HighlightCard extends StatelessWidget {
  const HighlightCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: GestureDetector(
        onTap: () => openFoodDetail(context, item),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 26, offset: Offset(0, 16))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Tag(label: item.badge, color: item.badgeColor), const Spacer(), Text(item.price, style: const TextStyle(fontWeight: FontWeight.w800))]),
            const SizedBox(height: 16),
            FoodThumb(color: item.color, icon: item.icon, width: 184, height: 116, radius: 28, heroTag: item.heroTag),
            const SizedBox(height: 16),
            Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(item.description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Row(children: [Text(item.kcal, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5B734F))), const Spacer(), const Icon(Icons.arrow_outward, size: 20)]),
          ]),
        ),
      ),
    );
  }
}

class ValueCard extends StatelessWidget {
  const ValueCard({required this.icon, required this.title, required this.subtitle, super.key});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: SizedBox(
      width: MediaQuery.sizeOf(context).width / 2 - 26,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFFCF7), Color(0xFFF0EAD9)]),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: const Color(0xFFDDE8CB), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: const Color(0xFF446141)),
          ),
          const SizedBox(height: 18),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(subtitle),
        ]),
      ),
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({required this.tags, super.key});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF20352C),
        borderRadius: BorderRadius.circular(34),
        boxShadow: const [BoxShadow(color: Color(0x18000000), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('适合忙碌生活中的每一餐', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
        const SizedBox(height: 12),
        const Text('午餐需要效率，晚餐需要轻松，健身后需要补充。轻植日常把口感、营养和情绪价值放在同一份餐里。', style: TextStyle(color: Colors.white70, height: 1.5)),
        const SizedBox(height: 18),
        Wrap(spacing: 10, runSpacing: 10, children: tags.map((tag) => Tag(label: tag, color: Colors.white.withValues(alpha: 0.09), textColor: Colors.white)).toList()),
      ]),
      ),
    );
  }
}

class DiscoverBar extends StatelessWidget {
  const DiscoverBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12))],
      ),
      child: const Row(
        children: [
          Expanded(child: MiniStat(label: '新品热度', value: 'TOP 3')),
          SizedBox(width: 12),
          Expanded(child: MiniStat(label: '平均热量', value: '<420')),
          SizedBox(width: 12),
          Expanded(child: MiniStat(label: '最快取餐', value: '15 min')),
        ],
      ),
    );
  }
}

class MiniStat extends StatelessWidget {
  const MiniStat({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF35503B))),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 13)),
    ]);
  }
}

class CampaignBanner extends StatelessWidget {
  const CampaignBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFEF8F55), Color(0xFFF4B96C), Color(0xFFF8DE97)]),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 28, offset: Offset(0, 16))],
      ),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('本周轻食入门组合', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
        SizedBox(height: 8),
        Text('从 5 份高满意度搭配开始，减少选择成本，先把轻松吃饭建立起来。', style: TextStyle(color: Colors.white, height: 1.45)),
        SizedBox(height: 18),
        Row(children: [Tag(label: '工作日午餐', color: Color(0x33FFFFFF), textColor: Colors.white), SizedBox(width: 8), Tag(label: '低负担', color: Color(0x33FFFFFF), textColor: Colors.white)]),
      ]),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: GestureDetector(
        onTap: () => openFoodDetail(context, item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12))],
          ),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: FoodThumb(color: item.color, icon: item.icon, width: 148, height: 148, radius: 30, heroTag: item.heroTag)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [Tag(label: item.badge, color: item.badgeColor), const Spacer(), Text(item.price, style: const TextStyle(fontWeight: FontWeight.w800))]),
                  const SizedBox(height: 14),
                  Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(item.description),
                  const SizedBox(height: 12),
                  Text(item.kcal, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF59714E))),
                ]),
              ),
            ]),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: item.tags.map((tag) => Tag(label: tag, color: const Color(0xFFF3EDE2))).toList()),
            const SizedBox(height: 16),
            Row(children: [
              const Expanded(child: Text('适合第一次接触轻食的用户，也适合工作日午餐快速决策。')),
              const SizedBox(width: 16),
          PressableScale(
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF263C2A), foregroundColor: Colors.white),
              onPressed: () => openFoodDetail(context, item),
              child: const Text('加入组合'),
            ),
          ),
            ]),
          ]),
        ),
      ),
    );
  }
}

class ContentHero extends StatelessWidget {
  const ContentHero({super.key});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF284B4B), Color(0xFF53786F), Color(0xFF9DB7A5)]),
        borderRadius: BorderRadius.circular(32),
      ),
      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BrandBadge(dark: true),
        SizedBox(height: 16),
        Text('为什么工作日更适合吃轻食', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
        SizedBox(height: 10),
        Text('规律、轻负担、清晰的营养结构，会让午后状态更稳定。内容页的重点是把品牌方法论讲明白。', style: TextStyle(color: Colors.white, height: 1.5)),
      ]),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({required this.item, super.key});

  final ArticleItem item;

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Row(children: [
        FoodThumb(color: item.color, icon: item.icon, width: 96, height: 108, radius: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Tag(label: item.tag, color: const Color(0xFFE6EFD9)),
            const SizedBox(height: 10),
            Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(item.summary, maxLines: 4, overflow: TextOverflow.ellipsis),
          ]),
        ),
      ]),
      ),
    );
  }
}

class InsightCard extends StatelessWidget {
  const InsightCard({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: const Color(0xFFDDE8CB), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFF4B6643)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ]),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({required this.item, super.key});

  final ActionItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 10))],
      ),
      child: Row(children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(18)),
          child: Icon(item.icon, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(item.subtitle),
          ]),
        ),
        PressableScale(
          child: FilledButton.tonal(onPressed: () {}, child: const Text('进入')),
        ),
      ]),
    );
  }
}

class Tag extends StatelessWidget {
  const Tag({required this.label, required this.color, this.textColor = const Color(0xFF354A33), super.key});

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor)),
    );
  }
}

class FoodThumb extends StatelessWidget {
  const FoodThumb({
    required this.color,
    required this.icon,
    this.width = 88,
    this.height = 88,
    this.radius = 24,
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
    final thumb = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withValues(alpha: 0.96), color.withValues(alpha: 0.68)]),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(children: [
        Positioned(
          right: -10,
          bottom: -8,
          child: Container(
            width: width * 0.5,
            height: width * 0.5,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), shape: BoxShape.circle),
          ),
        ),
        Center(child: Icon(icon, size: width * 0.34, color: Colors.white)),
      ]),
    );
    if (heroTag == null) {
      return thumb;
    }
    return Hero(tag: heroTag!, child: thumb);
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 70, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5C6A5D)))),
      Expanded(child: Text(value)),
    ]);
  }
}

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({required this.item, super.key});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          const AppBackdrop(child: SizedBox.expand()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Spacer(),
                    Tag(label: item.badge, color: item.badgeColor),
                  ],
                ),
                const SizedBox(height: 16),
                FloatingBob(
                  amplitude: 10,
                  duration: const Duration(milliseconds: 3400),
                  child: FoodThumb(
                    color: item.color,
                    icon: item.icon,
                    width: double.infinity,
                    height: 260,
                    radius: 40,
                    heroTag: item.heroTag,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(item.description, style: const TextStyle(fontSize: 16, height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(item.price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: item.tags.map((tag) => Tag(label: tag, color: const Color(0xFFF3EDE2))).toList(),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(child: MetricCard(number: item.kcal, label: '单份热量')),
                    const SizedBox(width: 12),
                    const Expanded(child: MetricCard(number: '15 min', label: '预计出餐')),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 24, offset: Offset(0, 12))],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('推荐亮点', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      SizedBox(height: 12),
                      Text('高蛋白搭配减少工作日午后的疲惫感。'),
                      SizedBox(height: 8),
                      Text('轻负担但有饱腹感，适合午餐和健身后补充。'),
                      SizedBox(height: 8),
                      Text('演示版详情页的目标，是让点开卡片后像真实商品页而不是简单弹层。'),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                PressableScale(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF263C2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {},
                    child: const Text('加入今日轻食组合'),
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

class MenuItem {
  const MenuItem({
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
  });

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

  String get heroTag => 'food-${name.hashCode}';
}

class ArticleItem {
  const ArticleItem({required this.title, required this.summary, required this.tag, required this.icon, required this.color});

  final String title;
  final String summary;
  final String tag;
  final IconData icon;
  final Color color;
}

class ActionItem {
  const ActionItem({required this.title, required this.subtitle, required this.icon, required this.color});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const menuItems = [
  MenuItem(name: '炙烤鸡胸能量碗', description: '高蛋白、低负担，适合工作日午餐和训练后补充。', kcal: '428 kcal', price: '¥39', category: '能量碗', tags: ['高蛋白', '适合午餐', '饱腹感强'], icon: Icons.rice_bowl_outlined, color: Color(0xFF84A14C), badge: '招牌单品', badgeColor: Color(0xFFE3EDD2)),
  MenuItem(name: '牛油果鲜虾沙拉', description: '清爽但不单薄，适合想控卡又想吃得有层次的人。', kcal: '362 kcal', price: '¥42', category: '轻沙拉', tags: ['轻负担', '鲜蔬', '清爽口感'], icon: Icons.spa_outlined, color: Color(0xFF4E8B72), badge: '新品推荐', badgeColor: Color(0xFFDCEBEB)),
  MenuItem(name: '南瓜藜麦轻能量餐', description: '复合碳水搭配更多纤维，下午状态更稳定。', kcal: '396 kcal', price: '¥36', category: '能量碗', tags: ['复合碳水', '饱腹感', '办公室友好'], icon: Icons.emoji_food_beverage_outlined, color: Color(0xFFE39A51), badge: '入门友好', badgeColor: Color(0xFFF7E1CA)),
  MenuItem(name: '莓果酸奶杯', description: '轻甜不腻，适合早餐、加餐和训练前补能。', kcal: '214 kcal', price: '¥22', category: '低卡小食', tags: ['加餐', '轻甜', '早餐友好'], icon: Icons.icecream_outlined, color: Color(0xFFD26874), badge: '低卡加餐', badgeColor: Color(0xFFF4D8DE)),
  MenuItem(name: '青柠气泡轻饮', description: '清爽解腻，适合搭配主餐或午后提神。', kcal: '96 kcal', price: '¥16', category: '轻饮品', tags: ['轻饮', '解腻', '午后提神'], icon: Icons.local_drink_outlined, color: Color(0xFF5AB1A2), badge: '限定特调', badgeColor: Color(0xFFD9F0EB)),
];

const articles = [
  ArticleItem(title: '为什么工作日更适合吃轻食', summary: '对忙碌的上班族来说，稳定的能量供给比短暂的饱腹更重要，清晰搭配会让午后状态更轻盈。', tag: '午餐建议', icon: Icons.work_outline, color: Color(0xFF6D8F68)),
  ArticleItem(title: '减脂期怎么吃，才更容易坚持', summary: '真正容易坚持的饮食不是极端克制，而是能兼顾口感、营养和日常节奏。', tag: '减脂', icon: Icons.directions_run_outlined, color: Color(0xFFDD9154)),
  ArticleItem(title: '高蛋白、低 GI、轻负担到底是什么意思', summary: '把这些概念放回一日三餐的场景里看，才会更容易理解，也更容易执行。', tag: '营养基础', icon: Icons.auto_graph_outlined, color: Color(0xFF5A7DB5)),
];

const tips = [
  '高蛋白不等于高负担，关键在于烹饪方式和搭配结构。',
  '轻食也需要碳水，选对比例比完全不吃更重要。',
  '长期坚持比短期极端更重要，先从一顿午餐开始改变。',
];

const actions = [
  ActionItem(title: '预约试吃', subtitle: '留下信息，优先获取首批试吃资格。', icon: Icons.event_available_outlined, color: Color(0xFF7AA258)),
  ActionItem(title: '领取 7 天轻食建议', subtitle: '用最简单的方式体验更轻松的饮食安排。', icon: Icons.library_books_outlined, color: Color(0xFFE79D50)),
  ActionItem(title: '加入会员社群', subtitle: '获取新品预告、轻食知识和门店动态。', icon: Icons.groups_outlined, color: Color(0xFF658C7F)),
];
