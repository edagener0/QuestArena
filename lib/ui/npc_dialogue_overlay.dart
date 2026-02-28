import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class NpcDialogueOverlay extends ConsumerWidget {
  const NpcDialogueOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogue = ref.watch(npcDialogueProvider);

    if (dialogue == null) return const SizedBox.shrink();

    Color borderColor;
    IconData npcIcon;
    switch (dialogue.npcType) {
      case 'guard':
        borderColor = const Color(0xFF00BFFF);
        npcIcon = Icons.shield;
        break;
      case 'hunter':
        borderColor = const Color(0xFFE94560);
        npcIcon = Icons.sports_martial_arts;
        break;
      default:
        borderColor = const Color(0xFFFF6600);
        npcIcon = Icons.person;
    }

    return Positioned(
      bottom: 80, // Above D-Pad
      left: 16,
      right: 300, // Leave room for side panel
      child: GestureDetector(
        onTap: () {
          // Clear dialogue when tapped
          ref.read(npcDialogueProvider.notifier).clear();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: 0.3),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(npcIcon, color: borderColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dialogue.npcId.toUpperCase(),
                      style: TextStyle(
                        color: borderColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (dialogue.thinking)
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: borderColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Thinking...',
                            style: TextStyle(
                              color: Colors.white54,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        dialogue.dialogue,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap to close',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
