library client.dm.character;

import 'game_model.dart';
import 'mod.dart';
import 'entry.dart';
import 'global.dart';
import 'dd5e_entries.dart';

class Character {
  GameModel _gameModel;

  Map<String, Mod> _mods = {};     // master mod list (using a Map, no mod can be applied more than once -- correct behavior?)

  Map<String, Entry> _entries;

  Character(GameModel this._gameModel) {
    _entries = <String, Entry>{
      "name": new Entry("name"),
      "size": new ModifiableEntry("size"),
      "conditions": new ConditionsEntry(),
      "initiativeTotal": new InitiativeTotalEntry()
    };
  }

  Character.fromMap(GameModel this._gameModel, Map map) {
    log.info(map);

    // restore master mod list
    map['mods'].forEach((String modID, Map modMap) => _mods[modID] = new Mod.fromMap(modMap));

    // restore entries
    _entries = {};
    _entries['name'] = new Entry.fromMap(map['entries']['name']);
    _entries['size'] = new ModifiableEntry.fromMap(map['entries']['size']);
    _entries['conditions'] = new ListEntry.fromMap(map['entries']['conditions']);
    _entries['initiativeTotal'] = new InitiativeTotalEntry.fromMap(map['entries']['initiativeTotal']);

    // TODO: Test this!
    // when loading a saved character, restore stat ModRef lists (which do not persist)
    _mods.forEach((String id, Mod mod) {
      mod.affectedStats.forEach((AffectedStat stat) {
        if (_entries.containsKey(stat.name)) {
          (_entries[stat.name] as Modifiable).restoreMod(new ModRef(mod, stat));
        }
      });
    });
  }

  void addMod(Mod modToAdd) {
    // TODO: This might not be the most efficient way to update an existing mod
    // make sure the new mod isn't already here, and remove it if it is
    removeMod(modToAdd.id);

    // if new mod should be exclusive by type, remove all existing mods of that type
    if (modToAdd.exclusiveByType) {
      List<Mod> foundMods = _mods.values.where((Mod mod) => mod.type == modToAdd.type).toList();
      foundMods.forEach((Mod mod) => removeMod(mod.id));
    }

    // save mod to master list
    _mods[modToAdd.id] = modToAdd;

    // add a ModRef to each affected stat
    modToAdd.affectedStats.forEach((AffectedStat stat) {
      if (_entries.containsKey(stat.name)) {
        (_entries[stat.name] as Modifiable).addMod(new ModRef(modToAdd, stat));
      }
    });

    // remove any mods that need to leave as modToAdd is added
    modToAdd.removeMods?.forEach((String modID) => removeMod(modID));

    // add any mods that need to accompany modToAdd
    // if the value is NULL, no affectedStat values need to be set before applying the mod
    //   otherwise, the value will be a List of Maps, each of which will be a mini AffectedStat (see Mod for example)
    modToAdd.addMods?.forEach((String modID, value) {
      Mod mod = _gameModel[modID];

      if (value != NULL) {
        (value as List).forEach((Map as) => mod.setValue(as['value'], statName: as['name']));
      }

      addMod(mod);
    });
  }

  void removeMod(String modID) {
    // remove ModRefs from affected stats
    if (_mods.containsKey(modID)) {
      _mods[modID].affectedStats.forEach((AffectedStat stat) {
        (_entries[stat.name] as Modifiable)?.removeMod(modID);
      });

      // remove mod from master list
      _mods.remove(modID);
    }
  }

  Map toMap() {
    Map map = {
      "mods": {},
      "entries": {}
    };

    _mods.forEach((String id, Mod mod) => map['mods'][id] = mod.toMap());
    _entries.forEach((String stat, Entry entry) => map['entries'][stat] = entry.toMap());

    return map;
  }

  // for access to individual entries
  Entry operator [](String stat) => _entries[stat];

  // convenience getters
  String get name => this['name'].value;

  Mod getModByID(String modID) => _mods[modID];

  @override String toString() => "${this['name']}-> ${_entries}";
}