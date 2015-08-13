library client.dm.character;

import 'package:bb5e/models/game_model.dart';
import 'initiative_total_entry.dart';

class Character {
  GameModel _gameModel;     // reference to game rules and mods

  String charName = "";
  InitiativeTotalEntry<int> initiativeTotal;    // initiative total during combat

  Character(this._gameModel) {
    initiativeTotal = new InitiativeTotalEntry<int>(_gameModel.initiativeTotalMods);
  }

  Character.fromMap(Map map) {
    charName = map['charName'];
    initiativeTotal = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);
  }

  Map toMap() {
    return {
      "charName": charName,
      "initiativeTotal": initiativeTotal.toMap()
    };
  }

  @override String toString() => "$charName-> ${initiativeTotal}";
}