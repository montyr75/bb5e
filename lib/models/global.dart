library model.global;

import 'dart:async';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:event_bus/event_bus.dart';

const String FIREBASE_PATH = "https://incandescent-heat-2470.firebaseio.com";
const String FIREBASE_CHARACTER_PATH = "$FIREBASE_PATH/characterData";

// define logger
final Logger log = new Logger("bb5e");

bool initLog() {
  DateFormat dateFormatter = new DateFormat("H:m:s.S");

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.level > Level.FINE) {
      print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
    }
  });

  return true;
}

abstract class DatabaseInterface {
  Future<Map> getGameData();
}

abstract class View {
  // save references to all pertinent UI elements
  void _getUIReferences();

  // set up event listeners for UI elements
  void _setupListeners();
}

EventBus eventBus = new EventBus();

class InitiativeTotalCalculatedEvent {
  final int value;
  InitiativeTotalCalculatedEvent(this.value);
}