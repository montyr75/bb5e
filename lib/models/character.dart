library client.dm.character;

import 'dart:collection';
import 'package:bb5e/models/game_model.dart';
import 'mod.dart';
import 'entry.dart';
import 'initiative_total_entry.dart';

class Character {
//  GameModel _gameModel;     // reference to game rules and mods

  HashMap<String, Entry> _entries = <String, Entry>{
    "name": new Entry<String>("name"),
    "initiativeTotal": new InitiativeTotalEntry<int>()
  };

  Character(/*this._gameModel*/);

  Character.fromMap(Map map) {
    _entries['name'] = new Entry<String>.fromMap(map['name']);
    _entries['initiativeTotal'] = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);
  }

  void addMod(Mod mod) {
    // loop through all affectedStats and send a copy of the mod to each of those entries
  }

  Map toMap() {
    Map map = {};
    _entries.forEach((String stat, Entry entry) => map[stat] = entry.toMap());
    return map;
  }

  // for access to entries
  Entry operator [](String stat) => _entries[stat];

  @override String toString() => "${this['name']}-> ${this['initiativeTotal']}";
}