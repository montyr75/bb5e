library bb5e.models.game_model;

import 'mod.dart';

class GameModel {
  Map<String, Mod> mods = {};

  GameModel(Map modMaps) {
    modMaps.forEach((String id, Map modMap) => mods[id] = new Mod.fromMap(modMap)..id = id);
  }

  // return copy of requested mod
  Mod operator [](String modID) => mods[modID].clone();
}