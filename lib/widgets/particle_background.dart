import 'dart:math';
import 'package:flutter/material.dart';

/// A single particle floating in the background
class _Particle {
  double x;
  double y;
  double baseX;
  double baseY;
  double radius;
  double speedX;
  double speedY;
  Color color;
  double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.color,
    required this.opacity,
  })  : baseX = x,
        baseY = y;
}

/// Cursor-reactive animated particle background.
/// Particles drift around and get pushed away from the cursor.
class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.particleCount = 60,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();
  Offset _cursorPosition = Offset.zero;
  bool _initialized = false;

  static const double cursorInfluenceRadius = 150.0;
  static const double cursorForceStrength = 40.0;

  final List<Color> _colors = const [
    Color(0xFF66FCF1),
    Color(0xFFC501E2),
    Color(0xFF45A29E),
    Color(0xFF7B2FFF),
    Color(0xFFFF6B9D),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_updateParticles);
  }

  void _initParticles(Size size) {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble() * size.width,
        y: _random.nextDouble() * size.height,
        radius: _random.nextDouble() * 3 + 1,
        speedX: (_random.nextDouble() - 0.5) * 0.5,
        speedY: (_random.nextDouble() - 0.5) * 0.5,
        color: _colors[_random.nextInt(_colors.length)],
        opacity: _random.nextDouble() * 0.5 + 0.2,
      ));
    }
    _initialized = true;
  }

  void _updateParticles() {
    if (!_initialized || !mounted) return;
    final size = context.size;
    if (size == null) return;

    for (final p in _particles) {
      // Base drift movement
      p.x += p.speedX;
      p.y += p.speedY;

      // Cursor repulsion
      final dx = p.x - _cursorPosition.dx;
      final dy = p.y - _cursorPosition.dy;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist < cursorInfluenceRadius && dist > 0) {
        final force = (cursorInfluenceRadius - dist) / cursorInfluenceRadius;
        p.x += (dx / dist) * force * cursorForceStrength * 0.05;
        p.y += (dy / dist) * force * cursorForceStrength * 0.05;
      }

      // Wrap around edges
      if (p.x < -10) p.x = size.width + 10;
      if (p.x > size.width + 10) p.x = -10;
      if (p.y < -10) p.y = size.height + 10;
      if (p.y > size.height + 10) p.y = -10;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateParticles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!_initialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initParticles(Size(constraints.maxWidth, constraints.maxHeight));
          });
        }
        return MouseRegion(
          onHover: (event) {
            _cursorPosition = event.localPosition;
          },
          child: Stack(
            children: [
              // Gradient background
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0, -0.3),
                    radius: 1.2,
                    colors: [
                      Color(0xFF151821),
                      Color(0xFF0B0C10),
                    ],
                  ),
                ),
              ),
              // Particles
              CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _ParticlePainter(
                  particles: _particles,
                  cursorPosition: _cursorPosition,
                ),
              ),
              // Child content
              if (widget.child != null) widget.child!,
            ],
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset cursorPosition;

  _ParticlePainter({
    required this.particles,
    required this.cursorPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connecting lines between nearby particles
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 120) {
          final opacity = (1 - dist / 120) * 0.15;
          final paint = Paint()
            ..color = particles[i].color.withAlpha((opacity * 255).toInt())
            ..strokeWidth = 0.5;
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            paint,
          );
        }
      }
    }

    // Draw particles
    for (final p in particles) {
      // Glow
      final glowPaint = Paint()
        ..color = p.color.withAlpha((p.opacity * 80).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(p.x, p.y), p.radius * 3, glowPaint);

      // Core
      final corePaint = Paint()
        ..color = p.color.withAlpha((p.opacity * 255).toInt());
      canvas.drawCircle(Offset(p.x, p.y), p.radius, corePaint);
    }

    // Cursor glow
    if (cursorPosition != Offset.zero) {
      final cursorGlow = Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF66FCF1).withAlpha(30),
            const Color(0xFF66FCF1).withAlpha(0),
          ],
        ).createShader(Rect.fromCircle(center: cursorPosition, radius: 100));
      canvas.drawCircle(cursorPosition, 100, cursorGlow);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
