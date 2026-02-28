import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';
import 'package:quest_arena_client/widgets/inventory_panel.dart';
import 'package:quest_arena_client/widgets/quest_panel.dart';
import 'package:quest_arena_client/widgets/leaderboard_panel.dart';

class SidePanelOverlay extends ConsumerWidget {
  const SidePanelOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatMessages = ref.watch(chatMessagesProvider);

    return Positioned(
      top: 40,
      right: 0,
      bottom: 0,
      width: 280,
      child: Container(
        color: const Color(0xE616213E), // Navy with transparency
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Scrollable Panels
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const InventoryPanel(),
                    const Divider(color: Color(0xFF0F3460), height: 1),
                    const QuestPanel(),
                    const Divider(color: Color(0xFF0F3460), height: 1),
                    const LeaderboardPanel(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            
            // Fixed bottom Chat Log
            const Divider(color: Color(0xFF0F3460), height: 1),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'LOG',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: const Color(0xFF0A0A1A),
              child: ListView.builder(
                reverse: true, // Newest first
                itemCount: chatMessages.length > 10 ? 10 : chatMessages.length,
                itemBuilder: (context, index) {
                  // The actual list is chronological, so the newest is at the end
                  final msg = chatMessages[chatMessages.length - 1 - index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      msg,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
