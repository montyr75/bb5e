library dd5.base.mod;

class Mod<T> {
  // sources
  static const String CUSTOM = "CUSTOM";

  int id;                   // unique ID of mod (typically db-defined)
  int level;                // 1-20 or null = "all"
  String name;              // official name of the mod (if any)
  String type;              // type of mod (examples: ModType.BASE, ModType.BONUS, ModType.PENALTY)
  String subtype;           // more specific type of mod (examples: Speed.GROUND, Proficiencies.SKILL)
  String source;            // source of mod (examples: Mod.CUSTOM [user-provided], Race:Elf, Class:Fighter, etc.)
  String affectedStat;      // stat affected by this mod (examples: size, speed, traits)
  T value;                  // value of mod for calculation purposes (if any)
  String description;       // full description of mod (if any)
  String ref;               // reference for mod in game books (examples: PHB 101, DMG 55)

  Mod();

  Mod.fromMap(Map map) {
    id = map["id"];
    level = map["level"];
    name = map["name"];
    type = map["type"];
    subtype = map["subtype"];
    source = map["source"];
    affectedStat = map["affectedStat"];
    value = map["value"];
    description = map["description"];
    ref = map["ref"];
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
    if (affectedStat != null) map['affectedStat'] = affectedStat;
    if (value != null) map['value'] = value;
    if (description != null) map['description'] = description;
    if (ref != null) map['ref'] = ref;

    return map;

//    return {
//      "id": id,
//      "level": level,
//      "name": name,
//      "type": type,
//      "subtype": subtype,
//      "source": source,
//      "affectedStat": affectedStat,
//      "value": value,
//      "description": description,
//      "ref": ref
//    };
  }

  Mod clone() => new Mod.fromMap(toMap());

  @override bool operator ==(Mod other) => id == other.id;

  @override String toString() => "$name: $value";
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