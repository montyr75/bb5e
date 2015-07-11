library dd5.base.entry;

import "mod.dart";

// any entry that can be arbitrarily set by a user
class Entry<T> {
  T _value;
  String notes;

  Entry();

//  Entry.fromMap(Map map) {
//    _value = map["value"];
//    notes = map["notes"];
//  }

  T get value => _value;
  void set value(T newValue) {
    _value = newValue;
  }
}

// takes only a single Mod and uses that as the Entry's value
class ModifiableEntry<T> extends Entry implements Modifiable {
  Mod mod;

  ModifiableEntry();

//  ModifiableEntry.fromMap(Map map) : super.fromMap(map) {
//    mod = new Mod.fromMap(map);
//  }

  void addMod(Mod newMod) {
    mod = mod;
    _value = value;
  }

  void removeMod(Mod oldMod) {
    mod = _value = null;
  }

  @override set value(T newValue) {
    // throw exception -- only mods should ever set the value
  }
}

// takes any number of mods and uses them to calculate the value (simple math)
class CalculatedEntry<T> extends Entry implements Modifiable {
  List<Mod> mods;
  num min;
  num max;

  CalculatedEntry({this.min: null, this.max: null}) {
    _value = null;

    if (mods == null) {
      mods = [];
    }
  }

//  CalculatedEntry.fromMap(Map map) : super.fromMap(map) {
//    min = map["min"];
//    max = map["max"];
//  }

  @override void addMod(Mod mod) {
    mods.add(mod);
    calculate();
  }

  @override void removeMod(Mod mod) {
    mods.remove(mod);
    calculate();
  }

  void calculate() {
    if (mods == null || mods.isEmpty) {
      _value = null;
      return;
    }

    // calculate value as sum of Mod values
    List<num> values = mods.map((Mod mod) => mod.value).toList();
    _value = values.reduce((num totalValue, num currentValue) => totalValue + currentValue);

    // enforce min/max
    if (min != null) {
      _value = _value < min ? min : _value;
    }
    if (max != null) {
      _value = _value > max ? max : _value;
    }
  }

  @override set value(T newValue) {
    // throw exception -- only mods should ever set the value
  }
}
