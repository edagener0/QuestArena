import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FogComponent extends Component {
  Vector2? playerPosition;
  double visibleRadius = 150.0;
  
  FogComponent() {
    priority = 100; // Render above everything else on the map
  }

  @override
  void render(Canvas canvas) {
    if (playerPosition == null) return;
    
    // We get the camera view size from the active world somehow? 
    // Wait, let's just draw an infinite or very large rect because it's attached to the world.
    // Assuming a max map size, or we just draw a very large area around the player.
    // A 100x100 tile map is 3200x3200, so a 5000x5000 rect centered on player is safe.
    
    final Rect fogRect = Rect.fromCenter(
      center: Offset(playerPosition!.x, playerPosition!.y), 
      width: 10000, 
      height: 10000,
    );
    
    // Save layer to allow blending
    canvas.saveLayer(fogRect, Paint());
    
    // Draw solid fog
    final fogPaint = Paint()..color = Colors.black.withAlpha(200); // 180-200 alpha for dark fog of war
    canvas.drawRect(fogRect, fogPaint);
    
    // Punch out the visible radius using BlendMode.dstOut (or clear)
    // We use a radial gradient so the edges of vision are soft.
    final gradient = RadialGradient(
      colors: [
        Colors.black,
        Colors.black.withAlpha(0),
      ],
      stops: const [0.4, 1.0],
    );
    
    final cutoutPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(playerPosition!.x, playerPosition!.y), 
          radius: visibleRadius,
        ),
      )
      ..blendMode = BlendMode.dstOut;
      
    canvas.drawCircle(
      Offset(playerPosition!.x, playerPosition!.y), 
      visibleRadius, 
      cutoutPaint,
    );
    
    canvas.restore();
  }
}
