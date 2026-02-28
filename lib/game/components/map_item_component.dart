import 'package:flutter/material.dart';
import 'package:flame/components.dart';

class MapItemComponent extends PositionComponent {
  final String itemId;
  final String itemType;
  
  static const double tileSize = 32.0;

  MapItemComponent({
    required this.itemId,
    required this.itemType,
    required int tileX,
    required int tileY,
  }) {
    priority = 5;
    
    final sizeVal = tileSize * 0.35;
    size = Vector2(sizeVal, sizeVal);
    anchor = Anchor.center;
    position = Vector2(tileX * tileSize + tileSize / 2, tileY * tileSize + tileSize / 2);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Color itemColor;
    switch (itemType) {
      case 'potion_speed':
        itemColor = const Color(0xFF00BFFF);
        break;
      case 'potion_shield':
        itemColor = const Color(0xFFFFD700);
        break;
      case 'scroll_reveal':
        itemColor = const Color(0xFFDA70D6);
        break;
      case 'key_golden':
        itemColor = const Color(0xFFFFE066);
        break;
      case 'compass':
        itemColor = const Color(0xFF7FFF7F);
        break;
      case 'trap':
        itemColor = const Color(0xFFFF4444);
        break;
      default:
        itemColor = const Color(0xFFFFFFFF);
    }
    
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(3.0),
    );

    final Paint fillPaint = Paint()..color = itemColor;
    final Paint outlinePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, outlinePaint);
  }
}
