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
  List<Mod> mods;

  ModifiableEntry() {
    mods = new List(1);
  }

//  ModifiableEntry.fromMap(Map map) : super.fromMap(map) {
//    mods = map["mods"].map((Map map) => new Mod.fromMap(map)).toList();
//  }

  void addMod(Mod mod) {
    mods[0] = mod;

    _value = mods[0].value;
  }

  void removeMod(Mod mod) {
    mods[0] = _value = null;
  }

  @override void set value(T newVal) {
    // throw exception
  }
}

// takes any number of mods and uses them to calculate the value (simple math)
class CalculatedEntry<T> extends ModifiableEntry {
  num min;
  num max;

  CalculatedEntry({this.min: null, this.max: null}) {
    _value = null;
    mods = [];
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

    List<num> values = mods.map((Mod mod) => mod.value).toList();
    _value = values.reduce((num totalValue, num currentValue) => totalValue + currentValue);

    if (min != null) {
      _value = _value < min ? min : _value;
    }

    if (max != null) {
      _value = _value > max ? max : _value;
    }
  }
}
