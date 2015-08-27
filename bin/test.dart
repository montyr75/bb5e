import 'dart:async';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/models/global.dart';
import 'package:bb5e/models/character.dart';
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
  Character c = model.character;
  c['name'].value = "Bob";
//  c.addMod(model.gameModel['-JwnoPlDzNETWJ3aXle9']..value = 15);    // init roll
//  c.addMod(model.gameModel['-JwnoPlFx3hz9pwAAYHn']..value = 2);     // DEX mod
//  c.addMod(model.gameModel['-JwnoPlIvT4px-phgWlD']);                // melee, finesse
//  c.addMod(model.gameModel['-JwnoPlNGljXXDbGim8_']..setValue(-5, statName: "initiativeTotal"));   // custom

//  c.removeMod('-JwnoPlIvT4px-phgWlD');             // melee, finesse

  c.addMod(model.gameModel['-JxlET8yXcgHAJMu9pm4']);          // Creature Size: Medium
  c.addMod(model.gameModel['-JxlET8tgFA5bewaPihl']);          // Creature Size: Medium

  print(c);
}