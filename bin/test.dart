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
  c.addMod(model.gameModel['-JxlER7yTbE8jkNR0G8U']..value = 15);    // init roll
  c.addMod(model.gameModel['-JxlER83xf5vPpIlq5hd']..value = 2);     // DEX mod

  c.addMod(model.gameModel['-JxlET8yXcgHAJMu9pm4']);          // Creature Size: Medium

  c.addMod(model.gameModel['-Jy19_z40xsHO5J9N5Zb']);          // Condition: Incapacitated
  c.removeMod('-Jy19_z40xsHO5J9N5Zb');          // Condition: Incapacitated

  c.addMod(model.gameModel['-Jy19_zRaKPxh2tHiu_P']);          // Condition: Stunned (automatically adds Incapacitated)

  print("\n$c");
}