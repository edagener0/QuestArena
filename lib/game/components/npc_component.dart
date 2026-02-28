import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;

class NpcComponent extends PositionComponent {
  final String npcId;
  final Map<String, dynamic> data;
  
  static const double tileSize = 32.0;

  Vector2 _targetPosition = Vector2.zero();
  double _elapsedTime = 0.0;

  NpcComponent({
    required this.npcId,
    required this.data,
  }) {
    priority = 8;
    
    final startX = (data['x'] as int) * tileSize + tileSize / 2;
    final startY = (data['y'] as int) * tileSize + tileSize / 2;
    
    position = Vector2(startX, startY);
    _targetPosition = position.clone();
  }

  void updatePosition(Map<String, dynamic> newData) {
    _targetPosition = Vector2(
      (newData['x'] as int) * tileSize + tileSize / 2,
      (newData['y'] as int) * tileSize + tileSize / 2,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    
    // Smooth position interpolation
    position.lerp(_targetPosition, (dt * 12).clamp(0, 1));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint npcPaint = Paint()..color = const Color(0xFFFF6600);
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Subtle idle bob: math.sin(elapsed * 1.2 * 2 * pi) * 1.5 pixels vertical offset
    final bobOffset = math.sin(_elapsedTime * 1.2 * 2 * math.pi) * 1.5;
    
    canvas.save();
    canvas.translate(0, bobOffset);
    
    final radius = tileSize * 0.35;
    canvas.drawCircle(Offset.zero, radius, npcPaint);
    canvas.drawCircle(Offset.zero, radius, outlinePaint);
    
    canvas.restore();
  }
}
