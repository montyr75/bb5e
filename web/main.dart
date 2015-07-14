import 'dart:html';

import 'package:logging/logging.dart';
import 'package:console_log_handler/console_log_handler.dart';

import 'package:mdl/mdl.dart';

import 'package:bb5e/client/player/player_model.dart';
import 'package:bb5e/client/player/views.dart';

final Logger _logger = new Logger('bb5e');

//PlayerModel model = new PlayerModel();
//View currentView;

void main() {
  configLogging();
  registerMdl();
  componentFactory().run().then((_) {
//    currentView = new PlayerInitiativeView(model);
  });
}

void configLogging() {
  hierarchicalLoggingEnabled = false; // set this to true - its part of Logging SDK

  // now control the logging.
  // Turn off all logging first
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen(new LogConsoleHandler());
}
