import 'package:bb5e/client/player/player_model.dart';

import 'dart:async';

PlayerModel model = new PlayerModel();

void main() {
  model.init.addMod(model.gameModel.initiativeTotalMods[0].clone()..value = 15);

  print(model.init);

  model.conditions.incapacitated = true;

  model.init.removeMod(model.gameModel.initiativeTotalMods[8]);

  scheduleMicrotask(() => print(model.init));
}