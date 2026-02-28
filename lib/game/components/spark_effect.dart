import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class SparkEffect extends Component {
  final Vector2 position;
  final double duration;
  
  double _elapsed = 0.0;
  final List<_SparkParticle> _particles = [];
  final math.Random _random = math.Random();

  SparkEffect({
    required this.position,
    this.duration = 0.5,
    int particleCount = 12,
  }) {
    priority = 20;

    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final speed = 30.0 + _random.nextDouble() * 50.0;
      
      _particles.add(_SparkParticle(
        position: position.clone(),
        velocity: Vector2(math.cos(angle) * speed, math.sin(angle) * speed),
        color: const Color(0xFFE94560), 
        size: 2.0 + _random.nextDouble() * 3.0,
      ));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    if (_elapsed >= duration) {
      removeFromParent();
      return;
    }

    // Shrink size and decelerate
    final progress = _elapsed / duration;
    
    for (var particle in _particles) {
      particle.position.add(particle.velocity * dt);
      particle.velocity.scale(0.9); // friction
      particle.currentSize = particle.size * (1.0 - progress);
    }
  }

  @override
  void render(Canvas canvas) {
    final alpha = (255 * (1.0 - (_elapsed / duration))).toInt().clamp(0, 255);
    
    for (var particle in _particles) {
      final Paint paint = Paint()
        ..color = particle.color.withAlpha(alpha)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(
        Offset(particle.position.x, particle.position.y), 
        particle.currentSize, 
        paint
      );
    }
  }
}

class _SparkParticle {
  Vector2 position;
  Vector2 velocity;
  Color color;
  double size;
  double currentSize;

  _SparkParticle({
    required this.position,
    required this.velocity,
    required this.color,
    required this.size,
  }) : currentSize = size;
}
