library bb5e.client.player.model;

import 'package:bb5e/models/game_model.dart';
import '../../models/conditions_model.dart';
import '../../models/character.dart';

class PlayerModel {
  GameModel gameModel;
  Character character;

  ConditionsModel conditions = new ConditionsModel();

  PlayerModel(Map modMaps) {
    gameModel = new GameModel(modMaps);
    character = new Character(gameModel);
  }
}