import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class TopBarOverlay extends ConsumerWidget {
  const TopBarOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(gameSnapshotProvider);
    final teamName = ref.watch(teamNameProvider);
    final inRoom = ref.watch(currentRoomProvider) != null;

    if (snapshot == null) return const SizedBox.shrink();

    final myPlayer = snapshot.players[teamName];
    final gemCount = myPlayer != null ? myPlayer.countItemType('gem') : 0;
    final inventoryCount = myPlayer?.usableItems.length ?? 0;
    final score = myPlayer?.score ?? 0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: const Color(0xCC0A0A1A), // Dark navy with transparency
        child: Row(
          children: [
            // Team Name
            Expanded(
              child: Text(
                teamName,
                style: const TextStyle(
                  color: Color(0xFF00FF88),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // In Room Badge
            if (inRoom) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94560),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'IN ROOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Stats
            _StatItem(
              icon: Icons.diamond,
              iconColor: const Color(0xFFE94560), // Red-pink
              value: '$gemCount',
            ),
            const SizedBox(width: 16),
            _StatItem(
              icon: Icons.inventory_2,
              iconColor: const Color(0xFF00BFFF), // Light blue
              value: '$inventoryCount',
            ),
            const SizedBox(width: 16),
            _StatItem(
              icon: Icons.star,
              iconColor: const Color(0xFFFFD700), // Gold
              value: '$score',
            ),
            const SizedBox(width: 16),

            // Round/Time Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF16213E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0F3460)),
              ),
              child: Text(
                snapshot.gameActive
                    ? 'R${snapshot.round} | ${snapshot.timeRemaining}s'
                    : 'Lobby',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
