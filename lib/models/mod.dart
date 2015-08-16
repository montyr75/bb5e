library dd5.base.mod;

import 'dart:collection';

class Mod {
  // sources
  static const String CUSTOM = "CUSTOM";

  String id;                // Firebase ID
  int level;                // 1-20 or -1 = "all"
  String name;              // official name of the mod (if any)
  String source;            // source of mod (examples: User, Race:Elf, Class:Fighter, etc.)
  String description;       // full description of mod (if any)

  List<AffectedStat> affectedStats = <AffectedStat>[];

  Mod();

  Mod.fromMap(Map map) {
    id = map["id"];
    level = map["level"];
    name = map["name"];
    source = map["source"];
    description = map["description"];

    affectedStats = map['affectedStats'].map((Map asMap) => new AffectedStat.fromMap(asMap)).toList();
  }

  Map toMap() {
    return {
      "id": id,
      "level": level,
      "name": name,
      "source": source,
      "description": description,
      "affectedStats": affectedStats.map((AffectedStat stat) => stat.toMap()).toList()
    };
  }

  void setValue(value, {String statName}) {
    if (statName == null) {
      affectedStats[0].value = value;
    }
    else {
      // find all stats with the given name and update their values
      affectedStats.where((AffectedStat stat) => stat.name == statName).forEach((AffectedStat stat) => stat.value = value);
    }
  }

  Mod clone() => new Mod.fromMap(toMap());

  // this sets the value on just the first affectedStat (good for when there's only one)
  void set value(val) => setValue(val);

  @override bool operator ==(Mod other) => id == other.id;

  @override String toString() => "$name: $affectedStats";
}

class AffectedStat {
  String name;
  var value;
  HashMap<String, bool> tags;
  String ref;         // reference for mod in game books (examples: PHB 101, DMG 55)

  AffectedStat();

  AffectedStat.fromMap(Map map) : name = map['name'], value = map['value'], tags = map['tags'], ref = map['ref'];

  Map toMap() {
    return {
      "name": name,
      "value": value,
      "tags": tags,
      "ref": ref
    };
  }

  @override String toString() => "$name: $value";
}

// entries only need this, instead of the full Mod
class ModRef {
  String id;            // the ID of the source Mod
  String name;          // the name of the source Mod
  AffectedStat stat;    // just one affected stat

  ModRef(this.id, this.name, this.stat);

  ModRef.fromMap(Map map) {
    id = map['id'];
    name = map['name'];
    stat = new AffectedStat.fromMap(map);
  }

  Map toMap() {
    return {
      "id": id,
      "name": name,
      "stat": stat.toMap()
    };
  }

  get value => stat.value;
  get tags => stat.tags;
  get ref => stat.ref;

  @override String toString() => "$name (${stat.name}): $value";
}