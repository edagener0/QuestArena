import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:quest_arena_client/models/game_models.dart';

class PlayerComponent extends PositionComponent {
  final String teamName;
  final bool isLocalPlayer;
  
  static const double tileSize = 32.0;
  
  Vector2 _targetPosition = Vector2.zero();
  late final TextPaint _textPaint;

  PlayerComponent({
    required this.teamName,
    required PlayerData data,
    required this.isLocalPlayer,
  }) {
    priority = 10;
    
    _textPaint = TextPaint(
      style: const TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    // Initial position without lerping
    position = Vector2(data.x * tileSize + tileSize / 2, data.y * tileSize + tileSize / 2);
    _targetPosition = position.clone();
  }

  void updateFromData(PlayerData data, bool isMe) {
    _targetPosition = Vector2(data.x * tileSize + tileSize / 2, data.y * tileSize + tileSize / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Smooth position interpolation
    position.lerp(_targetPosition, (dt * 12).clamp(0, 1));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final Paint playerPaint = Paint()
      ..color = isLocalPlayer ? const Color(0xFF00FF88) : const Color(0xFF53CFFF);
    
    canvas.drawCircle(Offset.zero, tileSize * 0.4, playerPaint);

    // Draw name label centered above the player
    final textWidth = _textPaint.getLineMetrics(teamName).width;
    
    _textPaint.render(
      canvas,
      teamName,
      Vector2(-textWidth / 2, -tileSize * 0.8),
    );
  }
}
