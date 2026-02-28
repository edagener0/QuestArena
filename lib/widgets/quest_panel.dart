import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class QuestPanel extends ConsumerStatefulWidget {
  const QuestPanel({super.key});

  @override
  ConsumerState<QuestPanel> createState() => _QuestPanelState();
}

class _QuestPanelState extends ConsumerState<QuestPanel> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(gameSnapshotProvider);
    final ws = ref.read(wsServiceProvider);

    if (snapshot == null) return const SizedBox.shrink();

    final activeQuests = snapshot.quests.entries
        .where((entry) => entry.value.status != 'completed')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text(
            'ACTIVE QUESTS',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        if (activeQuests.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'No active quests.',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          )
        else
          ...activeQuests.map((entry) {
            final questId = entry.key;
            final quest = entry.value;

            IconData icon;
            Color iconColor;
            
            switch (quest.questType) {
              case 'collection':
                icon = Icons.diamond;
                iconColor = const Color(0xFFE94560);
                break;
              case 'riddle':
                icon = Icons.psychology;
                iconColor = const Color(0xFF00BFFF);
                break;
              case 'location':
                icon = Icons.flag;
                iconColor = const Color(0xFF00FF88);
                break;
              default:
                icon = Icons.assignment;
                iconColor = Colors.white;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A1A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0F3460)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, color: iconColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quest.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Reward: ${quest.reward} points',
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (quest.questType == 'riddle') ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 36,
                              child: TextField(
                                controller: _controllers.putIfAbsent(
                                  questId,
                                  () => TextEditingController(),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Answer...',
                                  hintStyle: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFF16213E),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                                onSubmitted: (answer) {
                                  if (answer.trim().isNotEmpty) {
                                    ws.action(questId, answer.trim());
                                    // Don't clear immediately, wait for server response
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BFFF),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(0, 36),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            onPressed: () {
                              final text = _controllers[questId]?.text.trim() ?? '';
                              if (text.isNotEmpty) {
                                ws.action(questId, text);
                              }
                            },
                            child: const Icon(Icons.send, size: 16),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
