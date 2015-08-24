//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/client/player/views.dart';
import 'package:bb5e/models/global.dart';
import 'package:bb5e/client/database.dart';

Database db = new Database();

PlayerModel model;
List<View> currentViews = [];
//ClientConnectionManager ccm = new ClientConnectionManager();

void main() {
  initLog();

  getGameData().then((_) {
    db.onSave.listen((bool saved) {
      JsObject jQuery = context['jQuery'];
      JsObject config = new JsObject.jsify({'width': 'auto'});
      jQuery.callMethod('bootstrapGrowl', ['Character Saved', config]);
    });

    currentViews.add(new CharacterBasicsView(model));
    currentViews.add(new InitiativeView(model));
    currentViews.add(new SpeedFactorView(model));

    // character SAVE button
    querySelector("#save-btn").onClick.listen((_) => db.saveCharacterData(model.character.toMap()));
  });
}

Future getGameData() async {
  model = new PlayerModel(await db.getGameData());
}