import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';
import 'package:quest_arena_client/widgets/dpad_controls.dart';

class DPadOverlay extends ConsumerWidget {
  const DPadOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ws = ref.read(wsServiceProvider);
    
    return Positioned(
      bottom: 12,
      left: 12,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // D-Pad
          DPadControls(
            onMove: (direction) => ws.move(direction),
          ),
          
          const SizedBox(width: 48),
          
          // Action Buttons
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Interact (TALK/USE)
              _ActionButton(
                label: 'TALK [E]',
                color: const Color(0xFFFF6600),
                onPressed: () => _handleInteract(ref),
              ),
              const SizedBox(height: 16),
              // Use Item
              _ActionButton(
                label: 'USE [I]',
                color: const Color(0xFF00BFFF),
                onPressed: () => _handleUseItem(ref),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleInteract(WidgetRef ref) {
    final snapshot = ref.read(gameSnapshotProvider);
    final teamName = ref.read(teamNameProvider);
    
    if (snapshot == null) return;
    
    final myPlayer = snapshot.players[teamName];
    if (myPlayer == null) return;

    String? nearestNpcId;
    int minDistance = 999;
    
    for (final entry in snapshot.npcs.entries) {
      final npc = entry.value as Map<String, dynamic>;
      final distX = (myPlayer.x - (npc['x'] as int)).abs();
      final distY = (myPlayer.y - (npc['y'] as int)).abs();
      final dist = distX + distY; // Manhattan distance
      
      if (dist <= 2 && dist < minDistance) {
        minDistance = dist;
        nearestNpcId = entry.key;
      }
    }
    
    if (nearestNpcId != null) {
      ref.read(wsServiceProvider).interact(nearestNpcId);
    }
  }

  void _handleUseItem(WidgetRef ref) {
    final snapshot = ref.read(gameSnapshotProvider);
    final teamName = ref.read(teamNameProvider);
    
    if (snapshot == null) return;
    
    final myPlayer = snapshot.players[teamName];
    if (myPlayer != null && myPlayer.usableItems.isNotEmpty) {
      ref.read(wsServiceProvider).useItem(myPlayer.usableItems.first.itemId);
    }
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
