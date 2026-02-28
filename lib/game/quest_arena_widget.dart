import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/providers/game_providers.dart';
import 'package:quest_arena_client/ui/top_bar_overlay.dart';
import 'package:quest_arena_client/ui/dpad_overlay.dart';
import 'package:quest_arena_client/ui/side_panel_overlay.dart';
import 'package:quest_arena_client/ui/npc_dialogue_overlay.dart';
import 'package:quest_arena_client/ui/item_toast_overlay.dart';
import 'package:quest_arena_client/ui/room_header_overlay.dart';
import 'package:quest_arena_client/game/quest_arena_game.dart';

class QuestArenaWidget extends ConsumerStatefulWidget {
  const QuestArenaWidget({super.key});

  @override
  ConsumerState<QuestArenaWidget> createState() => _QuestArenaWidgetState();
}

class _QuestArenaWidgetState extends ConsumerState<QuestArenaWidget> {
  late final QuestArenaGame _game;

  @override
  void initState() {
    super.initState();
    _game = QuestArenaGame(ref);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(gameSnapshotProvider);

    if (snapshot == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A1A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00FF88)),
        ),
      );
    }
    
    final currentRoom = ref.watch(currentRoomProvider);
    final inRoom = currentRoom != null;
    
    // Listen for room changes to drive game state safely
    ref.listen(currentRoomProvider, (previous, next) {
      if (next != null) {
        _game.enterRoom(next);
      } else {
        _game.exitRoom();
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. The main game canvas
          GameWidget<QuestArenaGame>(game: _game),
          
          // 2. Overlays
          if (!inRoom) ...[
            const TopBarOverlay(),
            const SidePanelOverlay(),
            const NpcDialogueOverlay(),
          ] else ...[
            const RoomHeaderOverlay(),
          ],
          
          // These show in both main map and room
          const DPadOverlay(),
          const ItemToastOverlay(),
        ],
      ),
    );
  }
}
