import 'package:bb5e/models/entries/initiative_total_entry.dart';
import 'package:bb5e/models/mod.dart';
import 'package:bb5e/models/game_model.dart';

GameModel model = new GameModel();
InitiativeTotalEntry<int> entry = new InitiativeTotalEntry<int>();

void main() {
  entry.addMod(model.initiativeTotalMods[0].clone()..value = 15);
  entry.addMod(model.initiativeTotalMods[1].clone()..value = 2);
  entry.addMod(model.initiativeTotalMods[2].clone()..value = -1);
  entry.addMod(model.initiativeTotalMods[12].clone());

  print(entry);
}