library bb5e.client.shared;

abstract class View {
  // save references to all pertinent UI elements
  void _getUIReferences();

  // set up event listeners for UI elements
  void _setupListeners();
}
