import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/game/quest_world.dart';
import 'package:quest_arena_client/game/room_world.dart';
import 'package:quest_arena_client/providers/game_providers.dart';
import 'package:quest_arena_client/models/game_models.dart';
import 'package:flame/components.dart';

class QuestArenaGame extends FlameGame with KeyboardEvents {
  final WidgetRef ref;
  
  static const double tileSize = 32.0;

  late final QuestWorld questWorld;
  late final RoomWorld roomWorld;

  QuestArenaGame(this.ref);

  @override
  Color backgroundColor() => const Color(0xFF0A0A1A);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    questWorld = QuestWorld(ref);
    roomWorld = RoomWorld(ref);
    
    // Initial camera setup
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = 1.0;

    // Set world (this handles adding precisely one world to the tree)
    final currentRoom = ref.read(currentRoomProvider);
    if (currentRoom != null) {
      enterRoom(currentRoom);
    } else {
      world = questWorld;
    }
  }

  void enterRoom(TreasureRoomData roomData) {
    if (world != roomWorld) {
      final snapshot = ref.read(gameSnapshotProvider);
      final teamName = ref.read(teamNameProvider);
      final playerState = snapshot?.players[teamName];
      
      if (playerState != null) {
        // Setting world automatically removes the previous one and adds this one
        world = roomWorld;
        roomWorld.loadRoom(roomData, playerState);
        camera.viewfinder.zoom = 1.0;
        // Centers camera on room grid center
        // Room map is 10x10 tiles, each 50x50. Center is 5 * 50 = 250.
        camera.viewfinder.position = Vector2(250, 250);
      }
    }
  }

  void exitRoom() {
    if (world != questWorld) {
      world = questWorld;
      roomWorld.unloadRoom();
      camera.viewfinder.zoom = 1.0;
    }
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is! KeyDownEvent) return super.onKeyEvent(event, keysPressed);

    final ws = ref.read(wsServiceProvider);
    final snapshot = ref.read(gameSnapshotProvider);
    final teamName = ref.read(teamNameProvider);
    
    // Movement
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW)) {
      ws.move('north');
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown) || keysPressed.contains(LogicalKeyboardKey.keyS)) {
      ws.move('south');
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      ws.move('west');
      return KeyEventResult.handled;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      ws.move('east');
      return KeyEventResult.handled;
    }

    // Interact with NPC
    if (keysPressed.contains(LogicalKeyboardKey.keyE)) {
      if (snapshot != null) {
        final myPlayer = snapshot.players[teamName];
        if (myPlayer != null) {
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
            ws.interact(nearestNpcId);
            return KeyEventResult.handled;
          }
        }
      }
    }

    // Use item (uses first usable item)
    if (keysPressed.contains(LogicalKeyboardKey.keyI)) {
      if (snapshot != null) {
        final myPlayer = snapshot.players[teamName];
        if (myPlayer != null && myPlayer.usableItems.isNotEmpty) {
          ws.useItem(myPlayer.usableItems.first.itemId);
          return KeyEventResult.handled;
        }
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
