library dd5.base.entry;

import "mod.dart";

abstract class Modifiable {
  void addMod(ModRef mod);          // add mod to entry and recalculate value (if necessary)
  void removeMod(String modID);     // remove mod from entry and recalculate value (if necessary)
  void restoreMod(ModRef mod);      // restore mod to entry after a reload, which should typically not trigger recalculation
}

// any entry that can be arbitrarily set by a user
class Entry {
  String name;        // the name of the entry (often a stat name)
  var value;            // the value of the entry
  String notes;

  Entry(String this.name);

  Entry.fromMap(Map map) : name = map['name'], value = map['value'], notes = map['notes'];

  Map toMap() {
    return {
      "name": name,
      "value": value,
      "notes": notes
    };
  }

  @override String toString() => "$name: $value";
}

// takes only a single Mod and uses that as the Entry's value
class ModifiableEntry extends Entry implements Modifiable {
  ModRef mod;

  ModifiableEntry(String name) : super(name);

  ModifiableEntry.fromMap(Map map) : super.fromMap(map);

  void addMod(ModRef newMod) {
    mod = newMod;
    value = newMod.value;
  }

  void removeMod(String oldModID) {
    mod = value = null;
  }

  void restoreMod(ModRef oldMod) {
    mod = oldMod;
  }
}

// takes any number of mods and uses them to calculate the value (simple math)
class CalculatedEntry extends Entry implements Modifiable {
  List<ModRef> mods = [];
  num min;
  num max;

  CalculatedEntry(String name, {num this.min: null, num this.max: null}) : super(name) {
    value = null;
  }

  CalculatedEntry.fromMap(Map map) : super.fromMap(map), min = map['min'], max = map['max'] {
//    mods = map['mods'].map((Map modMap) => new ModRef.fromMap(modMap)).toList();
  }

  Map toMap() {
    Map map = super.toMap();
    map.addAll({
//      "mods": mods.map((ModRef mod) => mod.toMap()).toList(),
      "min": min,
      "max": max
    });

    return map;
  }

  void addMod(ModRef mod) {
    mods.add(mod);
    calculate();
  }

  void removeMod(String modID) {
    mods.removeWhere((ModRef mod) => mod.id == modID);
    calculate();
  }

  void restoreMod(ModRef mod) {
    mods.add(mod);
  }

  void calculate() {
    // if there are no mods, value is null
    if (mods == null || mods.isEmpty) {
      value = null;
      return;
    }

    // check for any exclusive mods, which would dictate the final value
    ModRef exclusiveMod = mods.firstWhere((ModRef mod) => mod.exclusive, orElse: () => null);

    // calculate final value
    if (exclusiveMod == null) {
      // TODO: check for nullifiers and multipliers

      // calculate value as sum of Mod values
      List<num> values = mods.map((ModRef mod) => mod.value).toList();
      value = values.reduce((num totalValue, num currentValue) => totalValue + currentValue);

      // enforce min/max
      if (min != null) {
        value = value < min ? min : value;
      }
      if (max != null) {
        value = value > max ? max : value;
      }
    }
    else {
      value = exclusiveMod.value;
    }
  }
}
