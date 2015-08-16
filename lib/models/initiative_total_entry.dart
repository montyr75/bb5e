library bb5e.models.inititative_total_entry;

import 'mod.dart';
import 'entry.dart';
import '../client/shared.dart';

class InitiativeTotalEntry<T> extends CalculatedEntry {
  InitiativeTotalEntry() : super("initiativeTotal");

  InitiativeTotalEntry.fromMap(Map map) : super.fromMap(map);

  @override void addMod(ModRef mod) {
    // TODO: restore size checks using tags
    // there can be only one Size mod
//    else if (mod.subtype == "Size") {
//      removeSizeMods();
//    }

    super.addMod(mod);
  }

//  void removeSizeMods() {
//    mods.removeWhere((ModRef mod) => mod.subtype == "Size");
//    calculate();
//  }

  @override void calculate() {
    if (mods.any((ModRef mod) => mod.name == "Incapacitated")) {
      value = 0;
    }
    else {
      super.calculate();
    }

    eventBus.fire(new InitiativeTotalCalculatedEvent(value));

    print(this);
  }

  @override String toString() => "Initiative Total: $value\n  $mods";
}