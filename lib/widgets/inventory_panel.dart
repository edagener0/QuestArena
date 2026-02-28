import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class InventoryPanel extends ConsumerWidget {
  const InventoryPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(gameSnapshotProvider);
    final teamName = ref.watch(teamNameProvider);
    final ws = ref.read(wsServiceProvider);
    
    if (snapshot == null) return const SizedBox.shrink();
    
    final myPlayer = snapshot.players[teamName];
    if (myPlayer == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Active Effects Header
        if (myPlayer.speedBoost > 0 || myPlayer.hasShield) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            color: const Color(0x3300BFFF),
            child: Row(
              children: [
                if (myPlayer.speedBoost > 0)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.flash_on, color: Color(0xFF00BFFF), size: 16),
                  ),
                if (myPlayer.hasShield)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.shield, color: Color(0xFFFFD700), size: 16),
                  ),
                const Text(
                  'ACTIVE EFFECTS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Header
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'INVENTORY',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),

        // Usable Items List
        if (myPlayer.usableItems.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'No usable items.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          )
        else
          ...myPlayer.usableItems.map((item) {
            Color color;
            IconData icon;
            switch (item.itemType) {
              case 'potion_speed':
                color = const Color(0xFF00BFFF);
                icon = Icons.flash_on;
                break;
              case 'potion_shield':
                color = const Color(0xFFFFD700);
                icon = Icons.shield;
                break;
              case 'scroll_reveal':
                color = const Color(0xFFDA70D6);
                icon = Icons.map;
                break;
              case 'key_golden':
                color = const Color(0xFFFFE066);
                icon = Icons.key;
                break;
              case 'compass':
                color = const Color(0xFF7FFF7F);
                icon = Icons.explore;
                break;
              default:
                color = Colors.white;
                icon = Icons.category;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0F3460)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.withValues(alpha: 0.2),
                        foregroundColor: color,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        minimumSize: const Size(0, 36),
                      ),
                      onPressed: () => ws.useItem(item.itemId),
                      child: const Text('USE'),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
