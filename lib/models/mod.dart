library dd5.base.mod;

import 'dart:collection';

class Mod {
  // sources
  static const String CUSTOM = "CUSTOM";

  int id;                   // unique ID of mod (typically db-defined)
  int level;                // 1-20 or -1 = "all"
  String name;              // official name of the mod (if any)
  String type;              // type of mod (examples: ModType.BASE, ModType.BONUS, ModType.PENALTY)
  String subtype;           // more specific type of mod (examples: Speed.GROUND, Proficiencies.SKILL)
  String source;            // source of mod (examples: Mod.CUSTOM [user-provided], Race:Elf, Class:Fighter, etc.)
  String description;       // full description of mod (if any)

  List<AffectedStat> affectedStats = <AffectedStat>[];

  Mod();

  Mod.fromMap(Map map) {
    id = map["id"];
    level = map["level"];
    name = map["name"];
    type = map["type"];
    subtype = map["subtype"];
    source = map["source"];
    description = map["description"];

    map['affectedStats'].forEach((String key, Map map) => affectedStats.add(new AffectedStat.fromMap(map)));
  }

  Map toMap() {
    // in JS, null values in here end up as undefined and cause Firebase.set to fail
    Map map = {};
    if (id != null) map['id'] = id;
    if (level != null) map['level'] = level;
    if (name != null) map['name'] = name;
    if (type != null) map['type'] = type;
    if (subtype != null) map['subtype'] = subtype;
    if (source != null) map['source'] = source;
    if (description != null) map['description'] = description;

    if (affectedStats.isNotEmpty) {
      map['affectedStats'] = affectedStats.map((AffectedStat af) => af.toMap());
    }

    return map;
  }

  Mod clone() => new Mod.fromMap(toMap());

  @override bool operator ==(Mod other) => name == other.name;

  @override String toString() => "$name: $affectedStats";
}

class ModType {
  static const String BASE = "BASE";
  static const String BONUS = "BONUS";
  static const String PENALTY = "PENALTY";
  static const String MODIFIER = "MODIFIER";
}

abstract class Modifiable {
  void addMod(Mod mod);
  void removeMod(Mod mod);
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
  String id;          // the ID of the source Mod
  AffectedStat stat;    // the value for just one affected stat

  ModRef(this.id, this.stat);

  ModRef.fromMap(Map map) {
    id = map['id'];
    stat = new AffectedStat.fromMap(map);
  }

  Map toMap() {
    return {
      "id": id,
      "stat": stat.toMap()
    };
  }
}