library bb5e.models.game_model;

import 'dart:convert';
import 'mod.dart';
import 'entries/initiative_total_entry.dart';

class GameModel {
  List<Mod> initiativeTotalMods;

  GameModel() {
    int i = 0;
    List<Map> maps = JSON.decode(initiativeTotalModsJSON);
    initiativeTotalMods = maps.map((Map map) => new Mod.fromMap(map)..id = i++).toList();
  }
}