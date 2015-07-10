import 'package:bb5e/models/entries/initiative_total_entry.dart';
import 'package:bb5e/models/mod.dart';
import 'package:bb5e/models/game_model.dart';

GameModel model = new GameModel();
InitiativeTotalEntry entry = new InitiativeTotalEntry();

void main() {
  entry.addMod(model.initiativeTotalMods[0].clone()..value = 15);
  entry.addMod(model.initiativeTotalMods[1].clone()..value = 2);

  print(entry);
}