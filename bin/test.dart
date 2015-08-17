import 'package:firebase_rest/firebase_rest.dart';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/models/global.dart';

PlayerModel model;    // NOTE: This will not work without an alternate way for GameModel to get its data from Firebase (server-side style)

void main() {
  initLog();

  getGameData();
}

getGameData() async {
  DataSnapshot snapshot = await new Firebase(Uri.parse("$FIREBASE_PATH/gameData/mods")).get();
  model = new PlayerModel(snapshot.val);
  test();
}

void test() {
  model.character['name'].value = "Bob";
  model.character.addMod(model.gameModel['-JwnoPlDzNETWJ3aXle9']..value = 15);    // init roll
  model.character.addMod(model.gameModel['-JwnoPlFx3hz9pwAAYHn']..value = 2);     // DEX mod
  model.character.addMod(model.gameModel['-JwnoPlIvT4px-phgWlD']);                // melee, finesse
  model.character.addMod(model.gameModel['-JwnoPlNGljXXDbGim8_']..setValue(-5, statName: "initiativeTotal"));   // custom

  model.character.removeMod('-JwnoPlIvT4px-phgWlD');             // melee, finesse
}