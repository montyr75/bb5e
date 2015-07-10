library bb5e.client.player.views;

import 'dart:html';
import '../../client/shared.dart';
import '../../models/entries/initiative_total_entry.dart';

class PlayerInitiativeView implements View {
  InitiativeTotalEntry _init;

  // UI refs
  InputElement charName;
  // ... and so on ...

  PlayerInitiativeView(this._init) {
    _getUIReferences();
    _setupListeners();
  }

  void _getUIReferences() {
    charName = querySelector("#char-name");
    // ... and so on ...
  }

  void _setupListeners() {
    charName.onInput.listen((Event event) {

    });

    // ... and so on ...
  }
}