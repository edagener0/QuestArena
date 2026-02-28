import 'dart:ui';
import 'dart:math' as math;
import 'package:flame/components.dart';

class TileMapComponent extends PositionComponent {
  static const double tileSize = 32.0;

  List<List<String>> _map = [];
  double _elapsedTime = 0.0;

  void updateMap(List<List<String>> newMap) {
    _map = newMap;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (_map.isEmpty) return;

    final Paint emptyPaint = Paint()..color = const Color(0xFF1A1A2E);
    final Paint wallPaint = Paint()..color = const Color(0xFF16213E);
    final Paint gridPaint = Paint()
      ..color = const Color(0x4D0F3460) // #0F3460 at 30% alpha (0x4D = 77)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final Paint lockedDoorPaint = Paint()..color = const Color(0xFFFFE066);
    final Paint doorPaint = Paint();
    
    final int rows = _map.length;
    final int cols = _map[0].length;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final String tileType = x < _map[y].length ? _map[y][x] : 'empty';
        final Rect rect = Rect.fromLTWH(x * tileSize, y * tileSize, tileSize, tileSize);

        // Draw base tile
        if (tileType == 'wall') {
          canvas.drawRect(rect, wallPaint);
        } else {
          canvas.drawRect(rect, emptyPaint);
        }

        // Draw special tiles
        switch (tileType) {
          case 'gem':
            _drawGem(canvas, rect);
            break;
          case 'locked_door':
            _drawLockedDoor(canvas, rect, lockedDoorPaint);
            break;
          case 'door':
            _drawDoor(canvas, rect, doorPaint);
            break;
        }

        // Draw grid outline
        canvas.drawRect(rect, gridPaint);
      }
    }
  }

  void _drawGem(Canvas canvas, Rect rect) {
    final Paint gemPaint = Paint()..color = const Color(0xFFE94560);
    canvas.save();
    canvas.translate(rect.center.dx, rect.center.dy);
    canvas.rotate(_elapsedTime * 2.0);
    
    final Path path = Path();
    final double size = tileSize * 0.3;
    path.moveTo(0, -size);
    path.lineTo(size, 0);
    path.lineTo(0, size);
    path.lineTo(-size, 0);
    path.close();
    
    canvas.drawPath(path, gemPaint);
    canvas.restore();
  }

  void _drawLockedDoor(Canvas canvas, Rect rect, Paint paint) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: rect.center, width: tileSize * 0.8, height: tileSize * 0.8),
      const Radius.circular(4.0),
    );
    canvas.drawRRect(rrect, paint);

    final Paint keyholePaint = Paint()..color = const Color(0xFF16213E);
    canvas.drawCircle(rect.center - const Offset(0, 2), 3.0, keyholePaint);
    final Path keyholePath = Path();
    keyholePath.moveTo(rect.center.dx - 2.5, rect.center.dy);
    keyholePath.lineTo(rect.center.dx + 2.5, rect.center.dy);
    keyholePath.lineTo(rect.center.dx + 4.0, rect.center.dy + 7.0);
    keyholePath.lineTo(rect.center.dx - 4.0, rect.center.dy + 7.0);
    keyholePath.close();
    canvas.drawPath(keyholePath, keyholePaint);
  }

  void _drawDoor(Canvas canvas, Rect rect, Paint paint) {
    final double pulse = (math.sin(_elapsedTime * 4.0) + 1.0) / 2.0;
    final int alpha = (100 + 155 * pulse).toInt().clamp(0, 255);
    paint.color = const Color(0xFF00FF88).withAlpha(alpha);
    
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: rect.center, width: tileSize * 0.8, height: tileSize * 0.8),
      const Radius.circular(4.0),
    );
    canvas.drawRRect(rrect, paint);
  }
}
