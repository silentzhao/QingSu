import 'dart:math' as math;

import 'package:flutter/material.dart';

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
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _opacity =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
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
      child: SlideTransition(position: _slide, child: widget.child),
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

class _FloatingBobState extends State<FloatingBob>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)
        ..repeat(reverse: true);
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
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _offset.value),
        child: child,
      ),
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
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.965 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFFF6F1E8)),
        const Positioned(
            top: -80,
            left: -20,
            child: Halo(size: 240, color: Color(0x33D0E0B3))),
        const Positioned(
            top: 180,
            right: -90,
            child: Halo(size: 220, color: Color(0x1FEF9E6C))),
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

class _ParticleFieldState extends State<ParticleField>
    with SingleTickerProviderStateMixin {
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
          painter: _ParticlePainter(
              progress: _controller.value, particles: _particles),
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
      canvas.drawCircle(
        Offset(size.width * particle.x, (size.height * particle.y) + shift),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}
