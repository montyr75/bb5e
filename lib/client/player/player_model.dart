library bb5e.client.player.model;

import 'package:bb5e/models/game_model.dart';
import '../../models/initiative_total_entry.dart';
import '../../models/conditions_model.dart';

class PlayerModel {
  GameModel gameModel = new GameModel();

  String charName = "";
  String actionDescription = "";
  InitiativeTotalEntry<int> init;
  ConditionsModel conditions = new ConditionsModel();

  PlayerModel() {
    init = new InitiativeTotalEntry<int>(gameModel.initiativeTotalMods);
  }
}