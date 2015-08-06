library bb5e.client.shared;

import 'package:event_bus/event_bus.dart';

const String FIREBASE_PATH = "https://incandescent-heat-2470.firebaseio.com";
const String FIREBASE_CHARACTER_PATH = "$FIREBASE_PATH/characterData";

abstract class View {
  // save references to all pertinent UI elements
  void _getUIReferences();

  // set up event listeners for UI elements
  void _setupListeners();
}

EventBus eventBus = new EventBus();

class IncapacitatedEvent {}

class InitiativeTotalCalculatedEvent {
  final int value;
  InitiativeTotalCalculatedEvent(this.value);
}