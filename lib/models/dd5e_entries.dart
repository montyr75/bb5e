library bb5e.models.dd5e_entries;

import 'mod.dart';
import 'entry.dart';
import 'global.dart';

class InitiativeTotalEntry<T> extends CalculatedEntry {
  InitiativeTotalEntry() : super("initiativeTotal");

  InitiativeTotalEntry.fromMap(Map map) : super.fromMap(map);

  @override void calculate() {
    super.calculate();
    eventBus.fire(new InitiativeTotalCalculatedEvent(value));
    log.info("$runtimeType::calculate() -- $this");
  }

  @override String toString() => "${super.toString()}\n  $mods";
}

class ConditionsEntry<T> extends ListEntry {
  ConditionsEntry() : super("conditions");

  ConditionsEntry.fromMap(Map map) : super.fromMap(map);

  @override void addMod(ModRef mod) {
    super.addMod(mod);
    eventBus.fire(new ConditionsChangedEvent(value));
    log.info("$runtimeType::addMod() -- $this");
  }

  @override void removeMod(String modID) {
    super.removeMod(modID);
    eventBus.fire(new ConditionsChangedEvent(value));
    log.info("$runtimeType::removeMod() -- $this");
  }
}