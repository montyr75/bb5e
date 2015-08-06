import 'package:bb5e/client/player/player_model.dart';

import 'dart:async';

PlayerModel model = new PlayerModel();

void main() {
  model.initiativeTotal.addMod(model.gameModel.initiativeTotalMods[0].clone()..value = 15);

  print(model.initiativeTotal);

  model.conditions.incapacitated = true;

//  model.init.removeMod(model.gameModel.initiativeTotalMods[8]);

  scheduleMicrotask(() {
    scheduleMicrotask(() => print(model.initiativeTotal.toMap()));
  });
}