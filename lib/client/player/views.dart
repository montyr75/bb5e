library bb5e.client.player.views;

import 'dart:html';
import 'package:bb5e/client/shared.dart';
import 'package:bb5e/models/models.dart';

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