import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:quest_arena_client/models/game_models.dart';

class RoomPlayerComponent extends PositionComponent {
  PlayerData playerState;

  RoomPlayerComponent({required this.playerState}) {
    size = Vector2(50, 50);
    anchor = Anchor.center;
    
    // Initial position
    position = Vector2(
      (playerState.x) * 50.0 + 25.0,
      (playerState.y) * 50.0 + 25.0,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Lerp to target position
    final targetX = (playerState.x) * 50.0 + 25.0;
    final targetY = (playerState.y) * 50.0 + 25.0;
    
    final targetPos = Vector2(targetX, targetY);
    position.lerp(targetPos, dt * 10); // Fast lerp for room
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    
    // Draw player (Green)
    final paint = Paint()
      ..color = const Color(0xFF00FF88)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 12, paint);
    
    // Outline
    canvas.drawCircle(
      center, 
      12, 
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
    );
  }
}
