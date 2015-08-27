library client.dm.character;

import 'mod.dart';
import 'entry.dart';
import 'initiative_total_entry.dart';

class Character {

  Map<String, Mod> _mods = {};     // master mod list (using a Map, no mod can be applied more than once -- correct behavior?)

  Map<String, Entry> _entries = <String, Entry>{
    "name": new Entry<String>("name"),
    "size": new ModifiableEntry<String>("size"),
    "initiativeTotal": new InitiativeTotalEntry<int>()
  };

  Character();

  Character.fromMap(Map map) {
    // restore master mod list
    map['mods'].forEach((Map modMap) => _mods[modMap['id']] = new Mod.fromMap(modMap));

    // restore entries
    _entries['name'] = new Entry<String>.fromMap(map['name']);
    _entries['initiativeTotal'] = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);

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
  }

  void removeMod(String modID) {
    if (_mods.containsKey(modID)) {
      _mods[modID].affectedStats.forEach((AffectedStat stat) {
        (_entries[stat.name] as Modifiable).removeMod(modID);
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

  // for access to entries
  Entry operator [](String stat) => _entries[stat];

  @override String toString() => "${this['name']}-> ${_entries}";
}