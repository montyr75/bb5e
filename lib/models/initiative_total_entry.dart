library bb5e.models.inititative_total_entry;

import 'mod.dart';
import 'entry.dart';
import 'global.dart';

class InitiativeTotalEntry<T> extends CalculatedEntry {
  InitiativeTotalEntry() : super("initiativeTotal");

  InitiativeTotalEntry.fromMap(Map map) : super.fromMap(map);

  @override void addMod(ModRef newMod) {
    // there can be only one Size mod
    if (newMod.tags.containsKey("creature size")) {
      mods.removeWhere((ModRef mod) => mod.tags.containsKey("creature size"));
    }

    super.addMod(newMod);
  }

  @override void calculate() {
    if (mods.any((ModRef mod) => mod.name == "Incapacitated")) {
      value = 0;
    }
    else {
      super.calculate();
    }

    eventBus.fire(new InitiativeTotalCalculatedEvent(value));

    log.info("$runtimeType::attached() -- $this");
  }

  @override String toString() => "${super.toString()}\n  $mods";
}