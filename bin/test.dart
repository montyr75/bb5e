import 'dart:async';
import 'package:bb5e/client/player/player_model.dart';

PlayerModel model;    // NOTE: This will not work without an alternate way for GameModel to get its data from Firebase (server-side style)

void main() {
  model = new PlayerModel()..onLoaded.first.then((_) {
    model.character.initiativeTotal.addMod(model.gameModel.initiativeTotalMods[0].clone()..value = 15);

    print(model.character.initiativeTotal);

    model.conditions.incapacitated = true;

//  model.init.removeMod(model.gameModel.initiativeTotalMods[8]);

    scheduleMicrotask(() {
      scheduleMicrotask(() => print(model.character.initiativeTotal.toMap()));
    });
  });
}