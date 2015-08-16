library client.dm.character;

import 'mod.dart';
import 'entry.dart';
import 'initiative_total_entry.dart';

class Character {

  Map<String, Mod> mods = {};     // master mod list (using a Map, no mod can be applied more than once -- correct behavior?)

  Map<String, Entry> _entries = <String, Entry>{
    "name": new Entry<String>("name"),
    "initiativeTotal": new InitiativeTotalEntry<int>()
  };

  Character();

  Character.fromMap(Map map) {
    _entries['name'] = new Entry<String>.fromMap(map['name']);
    _entries['initiativeTotal'] = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);
  }

  void addMod(Mod mod) {
    // only apply the same mod once -- correct behavior?
    if (!mods.containsKey(mod.id)) {
      // save mod to master list
      mods[mod.id] = mod;

      mod.affectedStats.forEach((AffectedStat stat) {
        // add a ModRef to each affected stat
        if (_entries.containsKey(stat.name)) {
          (_entries[stat.name] as Modifiable).addMod(new ModRef(mod.id, mod.name, stat));
        }
      });
    }
  }

  void removeMod(String modID) {
    if (mods.containsKey(modID)) {
      mods[modID].affectedStats.forEach((AffectedStat stat) {
        (_entries[stat.name] as Modifiable).removeMod(modID);
      });
    }
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