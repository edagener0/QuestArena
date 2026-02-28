import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class RoomHeaderOverlay extends ConsumerWidget {
  const RoomHeaderOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoom = ref.watch(currentRoomProvider);
    
    if (currentRoom == null) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE94560), Color(0x00E94560)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Column(
          children: [
            Text(
              'TREASURE ROOM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Grab the key and exit before the hunters arrive!',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Walk to EXIT to leave',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
