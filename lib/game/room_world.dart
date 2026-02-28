import 'package:flame/components.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_arena_client/game/components/room_tile_map_component.dart';
import 'package:quest_arena_client/game/components/room_player_component.dart';
import 'package:quest_arena_client/providers/game_providers.dart';
import 'package:quest_arena_client/models/game_models.dart';

class RoomWorld extends World {
  final WidgetRef ref;
  
  RoomTileMapComponent? _tileMap;
  RoomPlayerComponent? _player;

  RoomWorld(this.ref);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  void loadRoom(TreasureRoomData roomData, PlayerData playerState) {
    _tileMap = RoomTileMapComponent(roomState: roomData);
    add(_tileMap!);
    
    _player = RoomPlayerComponent(playerState: playerState);
    add(_player!);
  }

  void unloadRoom() {
    if (_tileMap != null) {
      _tileMap!.removeFromParent();
      _tileMap = null;
    }
    if (_player != null) {
      _player!.removeFromParent();
      _player = null;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    final snapshot = ref.read(gameSnapshotProvider);
    final teamName = ref.read(teamNameProvider);
    
    // Update player state reference for lerping
    final playerState = snapshot?.players[teamName];
    if (_player != null && playerState != null) {
      _player!.playerState = playerState;
    }
  }
}
