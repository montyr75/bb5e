library client.dm.character;

import 'mod.dart';
import 'entry.dart';
import 'initiative_total_entry.dart';

class Character {

  Map<String, Mod> _mods = {};     // master mod list (using a Map, no mod can be applied more than once -- correct behavior?)

  Map<String, Entry> _entries = <String, Entry>{
    "name": new Entry<String>("name"),
    "initiativeTotal": new InitiativeTotalEntry<int>()
  };

  Character();

  Character.fromMap(Map map) {
    map['mods'].forEach((Map modMap) => _mods[modMap['id']] = new Mod.fromMap(modMap));

    _entries['name'] = new Entry<String>.fromMap(map['name']);
    _entries['initiativeTotal'] = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);

    // TODO: Test this! Also, this code is redundant and possibly computationally wasteful.
    // TODO: CalculatedEntry might need something like restoreMod that doesn't recalclate.
    // when loading a saved character, reapply all ModRefs
    _mods.forEach((String id, Mod mod) {
      mod.affectedStats.forEach((AffectedStat stat) {
        // add a ModRef to each affected stat
        if (_entries.containsKey(stat.name)) {
          (_entries[stat.name] as Modifiable).addMod(new ModRef(mod, stat));
        }
      });
    });
  }

  void addMod(Mod mod) {
    // only apply the same mod once -- correct behavior?
    if (!_mods.containsKey(mod.id)) {
      // save mod to master list
      _mods[mod.id] = mod;

      mod.affectedStats.forEach((AffectedStat stat) {
        // add a ModRef to each affected stat
        if (_entries.containsKey(stat.name)) {
          (_entries[stat.name] as Modifiable).addMod(new ModRef(mod, stat));
        }
      });
    }
  }

  void removeMod(String modID) {
    if (_mods.containsKey(modID)) {
      _mods[modID].affectedStats.forEach((AffectedStat stat) {
        (_entries[stat.name] as Modifiable).removeMod(modID);
      });
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

  @override String toString() => "${this['name']}-> ${this['initiativeTotal']}";
}