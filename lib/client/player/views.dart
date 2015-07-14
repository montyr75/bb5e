library bb5e.client.player.views;

import 'dart:html';
import '../../client/shared.dart';
import '../../client/player/player_model.dart';

class PlayerInitiativeView implements View {
  PlayerModel _model;

  // UI refs
  InputElement charName;
  // ... and so on ...

  PlayerInitiativeView(PlayerModel this._model) {
    _getUIReferences();
    _setupListeners();
  }

  void _getUIReferences() {
    charName = querySelector("#char-name");
    // ... and so on ...
  }

  void _setupListeners() {
    charName.onInput.listen((Event event) {
      _model.charName = (event.target as InputElement).value.trim();
    });

    // example of adding a mod
//    _model.init.addMod(_model.gameModel.initiativeTotalMods[3].clone());

    // example of removing a mod
//    _model.init.removeMod(_model.gameModel.initiativeTotalMods[3]);

    // ... and so on ...
  }
}