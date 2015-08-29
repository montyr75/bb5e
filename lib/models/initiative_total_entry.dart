library bb5e.models.inititative_total_entry;

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