import 'dart:async';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/models/global.dart';
import 'package:bb5e/server/database.dart';

PlayerModel model;

void main() {
  initLog();
  getGameData().then((_) => test());
}

Future getGameData() async {
  Database db = new Database();
  model = new PlayerModel(await db.getGameData());
}

void test() {
  model.character['name'].value = "Bob";
  model.character.addMod(model.gameModel['-JwnoPlDzNETWJ3aXle9']..value = 15);    // init roll
  model.character.addMod(model.gameModel['-JwnoPlFx3hz9pwAAYHn']..value = 2);     // DEX mod
  model.character.addMod(model.gameModel['-JwnoPlIvT4px-phgWlD']);                // melee, finesse
  model.character.addMod(model.gameModel['-JwnoPlNGljXXDbGim8_']..setValue(-5, statName: "initiativeTotal"));   // custom

  model.character.removeMod('-JwnoPlIvT4px-phgWlD');             // melee, finesse
}