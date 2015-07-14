library bb5e.client.shared;

import 'package:event_bus/event_bus.dart';

abstract class View {
  // save references to all pertinent UI elements
  void _getUIReferences();

  // set up event listeners for UI elements
  void _setupListeners();
}

EventBus eventBus = new EventBus();
class IncapacitatedEvent {}