library bb5e.models.inititative_total_entry;

import 'mod.dart';
import 'entry.dart';
import '../client/shared.dart';

class InitiativeTotalEntry<T> extends CalculatedEntry {
  InitiativeTotalEntry(List<Mod<int>> initiativeTotalMods) {
    // listen for incapacitated events
    eventBus.on(IncapacitatedEvent).listen((_) {
      addMod(initiativeTotalMods[12].clone());
    });
  }

  // an entry created this way will not respond to IncapacitatedEvent
  InitiativeTotalEntry.fromMap(Map map) : super.fromMap(map);

  @override void addMod(Mod mod) {
    // preserve uniqueness
    if (mods.indexOf(mod) != -1) {
      super.removeMod(mod);
    }
    // there can be only one Size mod
    else if (mod.subtype == "Size") {
      removeSizeMods();
    }

    super.addMod(mod);
  }

  void removeSizeMods() {
    mods.removeWhere((Mod mod) => mod.subtype == "Size");
    calculate();
  }

  @override void calculate() {
    if (mods.any((Mod mod) => mod.name == "Incapacitated")) {
      value = 0;
    }
    else {
      super.calculate();
    }

    eventBus.fire(new InitiativeTotalCalculatedEvent(value));

    print(this);
  }

  @override String toString() => "Initiative Total: $value\n  $mods";

  Map toMap() => super.toMap();
}