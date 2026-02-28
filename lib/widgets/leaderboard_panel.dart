import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class LeaderboardPanel extends ConsumerWidget {
  const LeaderboardPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(gameSnapshotProvider);
    final currentTeam = ref.watch(teamNameProvider);

    if (snapshot == null || snapshot.leaderboard.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedEntries = snapshot.leaderboard.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'LEADERBOARD',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        ...List.generate(sortedEntries.length, (index) {
          final entry = sortedEntries[index];
          final isMe = entry.key == currentTeam;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFF0F3460) : const Color(0xFF0A0A1A),
              borderRadius: BorderRadius.circular(6),
              border: isMe ? Border.all(color: const Color(0xFF00FF88)) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: index == 0 ? const Color(0xFFFFD700) : 
                             index == 1 ? const Color(0xFFC0C0C0) : 
                             index == 2 ? const Color(0xFFCD7F32) : 
                             Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    entry.key,
                    style: TextStyle(
                      color: isMe ? const Color(0xFF00FF88) : Colors.white,
                      fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${entry.value}',
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
