library dd5.base.entry;

import "mod.dart";

// any entry that can be arbitrarily set by a user
class Entry<T> {
  T value;
  String notes;

  Entry();

  Entry.fromMap(Map map) : value = map['value'], notes = map['notes'];

  Map toMap() {
    return {
      "value": value,
      "notes": notes
    };
  }
}

// takes only a single Mod and uses that as the Entry's value
class ModifiableEntry<T> extends Entry implements Modifiable {
  Mod mod;

  ModifiableEntry();

  void addMod(Mod newMod) {
    mod = mod;
    value = value;
  }

  void removeMod(Mod oldMod) {
    mod = value = null;
  }
}

// takes any number of mods and uses them to calculate the value (simple math)
class CalculatedEntry<T> extends Entry implements Modifiable {
  List<Mod> mods;
  num min;
  num max;

  CalculatedEntry({this.min: null, this.max: null}) {
    value = null;

    if (mods == null) {
      mods = [];
    }
  }

  CalculatedEntry.fromMap(Map map) : super.fromMap(map), min = map['min'], max = map['max'] {
    mods = map['mods'].map((Map modMap) => new Mod.fromMap(modMap));
  }

  Map toMap() {
    Map map = super.toMap();
    map.addAll({
      "mods": mods.map((Mod mod) => mod.toMap()).toList(),
      "min": min,
      "max": max
    });

    return map;
  }

  void addMod(Mod mod) {
    mods.add(mod);
    calculate();
  }

  void removeMod(Mod mod) {
    mods.remove(mod);
    calculate();
  }

  void calculate() {
    if (mods == null || mods.isEmpty) {
      value = null;
      return;
    }

    // calculate value as sum of Mod values
    List<num> values = mods.map((Mod mod) => mod.value).toList();
    value = values.reduce((num totalValue, num currentValue) => totalValue + currentValue);

    // enforce min/max
    if (min != null) {
      value = value < min ? min : value;
    }
    if (max != null) {
      value = value > max ? max : value;
    }
  }
}
