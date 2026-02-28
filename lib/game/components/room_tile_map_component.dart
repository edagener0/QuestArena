import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:quest_arena_client/models/game_models.dart';
import 'dart:math' as math;

class RoomTileMapComponent extends PositionComponent {
  final TreasureRoomData roomState;
  double _elapsedTime = 0.0;

  RoomTileMapComponent({required this.roomState}) {
    size = Vector2(500, 500); // 10x10 room based on 50x50 tiles
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
  }

  @override
  void render(Canvas canvas) {
    final mapData = roomState.map;
    
    // Draw background floor
    final floorPaint = Paint()..color = const Color(0xFF1E1E2E);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), floorPaint);

    final gridPaint = Paint()
      ..color = const Color(0x330F3460)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw tiles 10x10
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        if (y >= mapData.length || x >= mapData[y].length) continue;

        final tileValueStr = mapData[y][x];
        final rect = Rect.fromLTWH(x * 50.0, y * 50.0, 50, 50);

        canvas.drawRect(rect, gridPaint);

        if (tileValueStr == '1' || tileValueStr == 'wall') {
          // Wall
          canvas.drawRect(rect, Paint()..color = const Color(0xFF0A0A1A));
          // Wall details
          final detailPaint = Paint()
            ..color = const Color(0xFF16213E)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;
          canvas.drawRect(rect.deflate(4), detailPaint);
        } else if (tileValueStr == '7' || tileValueStr == 'pedestal_active' || tileValueStr == 'pedestal') {
          // Pedestal (brown platform)
          canvas.drawRect(rect.deflate(5), Paint()..color = const Color(0xFF8B4513)); // Brown platform
          // Active Pedestal (with key optionally, assume it's there if pedestal_active or 7)
          if (tileValueStr == '7' || tileValueStr == 'pedestal_active') {
            canvas.drawCircle(
              Offset(rect.center.dx, rect.center.dy),
              12,
              Paint()..color = const Color(0xFFFFCC00), // Key color
            );
          }
        } else if (tileValueStr == '8' || tileValueStr == 'pedestal_empty') {
          // Empty Pedestal
          canvas.drawRect(rect.deflate(5), Paint()..color = const Color(0xFF8B4513));
        } else if (tileValueStr == '9' || tileValueStr == 'exit_portal') {
          // Exit Portal (blue pulse + "EXIT" label)
          final double pulse = (math.sin(_elapsedTime * 5.0) + 1.0) / 2.0;
          final int alpha = (150 + 105 * pulse).toInt().clamp(0, 255);
          
          final gradient = RadialGradient(
            colors: [const Color(0xFF00BFFF).withAlpha(alpha), const Color(0xFF0000FF).withAlpha(0)],
          );
          final paint = Paint()
            ..shader = gradient.createShader(rect);
          
          canvas.drawCircle(Offset(rect.center.dx, rect.center.dy), 20, paint);
          
          // Portal center
          canvas.drawCircle(
            Offset(rect.center.dx, rect.center.dy), 
            8, 
            Paint()..color = Colors.white
          );

          // "EXIT" label
          final textPainter = TextPainter(
            text: const TextSpan(
              text: 'EXIT',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(
            canvas,
            Offset(rect.center.dx - textPainter.width / 2, rect.center.dy - 20),
          );
        } else if (tileValueStr == 'hazard') {
          // Hazard (red flash + X mark)
          final double pulse = (math.sin(_elapsedTime * 8.0) + 1.0) / 2.0;
          final int alpha = (100 + 155 * pulse).toInt().clamp(0, 255);
          
          canvas.drawRect(rect, Paint()..color = const Color(0xFFFF0000).withAlpha(alpha));
          
          final xPaint = Paint()
            ..color = Colors.white
            ..strokeWidth = 4
            ..style = PaintingStyle.stroke;
            
          canvas.drawLine(
            Offset(rect.left + 10, rect.top + 10),
            Offset(rect.right - 10, rect.bottom - 10),
            xPaint,
          );
          canvas.drawLine(
            Offset(rect.right - 10, rect.top + 10),
            Offset(rect.left + 10, rect.bottom - 10),
            xPaint,
          );
        }
      }
    }
  }
}

