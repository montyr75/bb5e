library bb5e.client.player.model;

import 'dart:async';
import 'package:bb5e/models/game_model.dart';
import '../../models/conditions_model.dart';
import '../../models/character.dart';

class PlayerModel {
  GameModel gameModel;
  Character character;

  ConditionsModel conditions = new ConditionsModel();

  // event controllers
  StreamController _onLoaded = new StreamController();

  PlayerModel() {
    gameModel = new GameModel()..onLoaded.first.then((bool loaded) {
      character = new Character(gameModel);

      // fire Loaded event
      _onLoaded.add(loaded);
    });
  }

  // events
  Stream<bool> get onLoaded => _onLoaded.stream;
}