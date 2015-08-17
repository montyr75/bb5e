//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
import 'dart:async';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/client/player/views.dart';
import 'package:bb5e/models/global.dart';
import 'package:bb5e/client/database.dart';

PlayerModel model;
View currentView;
//ClientConnectionManager ccm = new ClientConnectionManager();

void main() {
  initLog();

  getGameData().then((_) {
//    currentView = new PlayerInitiativeView(model/*, ccm*/);
  });
}

Future getGameData() async {
  Database db = new Database();
  model = new PlayerModel(await db.getGameData());
}