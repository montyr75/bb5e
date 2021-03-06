library dd5.base.entry;

import "mod.dart";
import "global.dart";

abstract class Modifiable {
  void addMod(ModRef mod);          // add mod to entry and recalculate value (if necessary)
  void removeMod(String modID);     // remove mod from entry and recalculate value (if necessary)
  void restoreMod(ModRef mod);      // restore mod to entry after a reload, which should typically not trigger recalculation
}

// any entry that can be arbitrarily set by a user
class Entry {
  String name;          // the name of the entry (often a stat name)
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

  @override String toString() => "$value";

  String toStringWithName() => "$name: $value";
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

  CalculatedEntry(String name, {num this.min: null, num this.max: null}) : super(name);

  CalculatedEntry.fromMap(Map map) : super.fromMap(map), min = map['min'], max = map['max'];

  @override Map toMap() {
    Map map = super.toMap();
    map.addAll({
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

  bool containsModByName(String modName) {
    return mods.firstWhere((ModRef mod) => mod.name == modName, orElse: () => null) != null ? true : false;
  }

  void calculate() {
    // NOTE: supports only one exclusive effect (the first found)
    // NOTE: supports only one multiplier (the last found)

    // if there are no mods, value is null
    if (mods == null || mods.isEmpty) {
      value = null;
      return;
    }

    // check for any exclusive mods, which would dictate the final value
    ModRef exclusiveMod = mods.firstWhere((ModRef mod) => mod.exclusive, orElse: () => null);

    // if there are no exclusive mods, calculate final value normally
    if (exclusiveMod == null) {
      String multiplier;

      // construct list of mod values, saving out any multipliers
      List<num> values = mods.map((ModRef mod) {
        if (mod.value is num) {
          return mod.value;
        }
        else if (mod.value is String) {
          multiplier = mod.value;
        }

        return 0;
      }).toList();

      // calculate value as sum of Mod values
      value = values.reduce((num totalValue, num currentValue) => totalValue + currentValue);

      // apply any multipliers
      if (multiplier != null) {
        num operand = num.parse(multiplier.substring(1));

        switch (multiplier[0]) {
          case "*": value *= operand; break;
          case "/": value /= operand; break;
        }
      }

      // enforce min/max
      if (min != null && value != null) {
        value = value < min ? min : value;
      }
      if (max != null && value != null) {
        value = value > max ? max : value;
      }
    }
    else {
      value = exclusiveMod.value == NULL ? null : exclusiveMod.value;
    }
  }
}

// takes any number of mods and uses them to construct a list of string values
class ListEntry extends Entry implements Modifiable {
  List<ModRef> mods = [];

  ListEntry(String name) : super(name) {
    value = <String, bool>{};
  }

  ListEntry.fromMap(Map map) : super.fromMap(map);

  void addMod(ModRef mod) {
    mods.add(mod);
    value[mod.value] = true;
  }

  void removeMod(String modID) {
    ModRef mod = mods.firstWhere((ModRef mod) => mod.id == modID, orElse: () => null);

    if (mod != null) {
      mods.remove(mod);
      value.remove(mod.value);
    }
  }

  void restoreMod(ModRef mod) {
    mods.add(mod);
  }

  @override Map toMap() {
    Map map = super.toMap();
    map['value'] = value;
    return map;
  }

  @override toString() {
    List<String> items = value.keys.toList()..sort();
    return items.toString().replaceAll(new RegExp(r"[\[\]]"), "");
  }
}