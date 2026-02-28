import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/game/components/tile_map_component.dart';
import 'package:quest_arena_client/game/components/player_component.dart';
import 'package:quest_arena_client/game/components/npc_component.dart';
import 'package:quest_arena_client/game/components/map_item_component.dart';
import 'package:quest_arena_client/game/components/spark_effect.dart';
import 'package:quest_arena_client/game/components/fog_component.dart';
import 'package:quest_arena_client/providers/game_providers.dart';

class QuestWorld extends World {
  final WidgetRef ref;
  
  late final TileMapComponent _tileMap;
  final Map<String, PlayerComponent> _players = {};
  final Map<String, NpcComponent> _npcs = {};
  final Map<String, MapItemComponent> _items = {};
  
  late final FogComponent _fogComponent;

  QuestWorld(this.ref);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    _tileMap = TileMapComponent();
    add(_tileMap);
    
    _fogComponent = FogComponent();
    add(_fogComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final snapshot = ref.read(gameSnapshotProvider);
    if (snapshot == null) return;

    // 1. Sync Tile Map
    _tileMap.updateMap(snapshot.map);

    // 2. Sync Players
    final teamName = ref.read(teamNameProvider);
    
    // Add new players or update existing
    for (final entry in snapshot.players.entries) {
      final playerName = entry.key;
      final playerData = entry.value;
      
      if (_players.containsKey(playerName)) {
        _players[playerName]!.updateFromData(playerData, playerName == teamName);
      } else {
        final newPlayer = PlayerComponent(
          teamName: playerName,
          data: playerData,
          isLocalPlayer: playerName == teamName,
        );
        _players[playerName] = newPlayer;
        add(newPlayer);
      }
    }

    // Remove obsolete players
    final currentServerPlayers = snapshot.players.keys.toSet();
    final toRemove = _players.keys.where((k) => !currentServerPlayers.contains(k)).toList();
    for (final key in toRemove) {
      final comp = _players.remove(key);
      if (comp != null) {
        comp.removeFromParent();
      }
    }

    // 3. Sync NPCs
    for (final entry in snapshot.npcs.entries) {
      final npcId = entry.key;
      final npcData = entry.value as Map<String, dynamic>;
      
      if (_npcs.containsKey(npcId)) {
        _npcs[npcId]!.updatePosition(npcData);
      } else {
        final newNpc = NpcComponent(
          npcId: npcId,
          data: npcData,
        );
        _npcs[npcId] = newNpc;
        add(newNpc);
      }
    }

    // Remove obsolete NPCs
    final currentServerNpcs = snapshot.npcs.keys.toSet();
    final npcsToRemove = _npcs.keys.where((k) => !currentServerNpcs.contains(k)).toList();
    for (final key in npcsToRemove) {
      final comp = _npcs.remove(key);
      if (comp != null) {
        comp.removeFromParent();
      }
    }

    // 4. Sync Map Items
    for (final entry in snapshot.items.entries) {
      final itemId = entry.key;
      final itemData = entry.value;

      if (!_items.containsKey(itemId)) {
        final newItem = MapItemComponent(
          itemId: itemId,
          itemType: itemData.itemType,
          tileX: itemData.x,
          tileY: itemData.y,
        );
        _items[itemId] = newItem;
        add(newItem);
      }
    }

    // Remove obsolete Items and Trigger Spark Effects
    final currentServerItems = snapshot.items.keys.toSet();
    final itemsToRemove = _items.keys.where((k) => !currentServerItems.contains(k)).toList();
    for (final key in itemsToRemove) {
      final comp = _items.remove(key);
      if (comp != null) {
        // Spawn spark effect at item's position
        add(SparkEffect(position: comp.position.clone()));
        comp.removeFromParent();
      }
    }

    // 5. Camera Follow & Fog Update
    if (teamName.isNotEmpty && _players.containsKey(teamName)) {
      final myPlayerComp = _players[teamName]!;
      final cam = findGame()!.camera;
      
      cam.viewfinder.position = Vector2(
        cam.viewfinder.position.x + (myPlayerComp.position.x - cam.viewfinder.position.x) * 0.15,
        cam.viewfinder.position.y + (myPlayerComp.position.y - cam.viewfinder.position.y) * 0.15,
      );
      
      _fogComponent.playerPosition = myPlayerComp.position.clone();
      
      // Optionally increase vision radius if player has a speed boost or active effect
      final snapshotPlayer = snapshot.players[teamName];
      if (snapshotPlayer != null && snapshotPlayer.speedBoost > 0) {
        _fogComponent.visibleRadius = 200.0;
      } else {
        _fogComponent.visibleRadius = 150.0;
      }
    }
  }
}
