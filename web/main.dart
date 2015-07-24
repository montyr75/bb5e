import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'package:bb5e/client/client_connection_manager.dart';
import 'package:bb5e/comms/comms.dart';
import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/client/player/views.dart';
import 'package:bb5e/client/shared.dart';

final Logger _logger = new Logger('bb5e');

PlayerModel model = new PlayerModel();
View currentView;
ClientConnectionManager ccm = new ClientConnectionManager();

void main() {
  configLogging();
  registerMdl();
  componentFactory().run().then((_) {
    currentView = new PlayerInitiativeView(model, ccm);
    ccm.connectToServer(SERVER_IP, SERVER_PORT);
  });
}

void configLogging() {
  hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogConsoleHandler());
}