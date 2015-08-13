//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/client/player/views.dart';
import 'package:bb5e/client/shared.dart';

PlayerModel model;
View currentView;
//ClientConnectionManager ccm = new ClientConnectionManager();

void main() {
  model = new PlayerModel()..onLoaded.first.then((_) {
//  ccm.connectToServer(SERVER_IP, SERVER_PORT);
    currentView = new PlayerInitiativeView(model/*, ccm*/);
  });
}
