library server;

import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:redstone/server.dart' as Redstone;
import 'package:redstone_web_socket/redstone_web_socket.dart';
import 'package:bb5e/comms/comms.dart';

// define logger
final Logger log = new Logger("bb5e");

void main() {
  initLog();

//  Redstone.setupConsoleLog();
  Redstone.addPlugin(getWebSocketPlugin());
  Redstone.start(port: SERVER_PORT);
}


bool initLog() {
  DateFormat dateFormatter = new DateFormat("H:m:s.S");

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (rec.level > Level.FINE) {
      print('${rec.level.name} (${dateFormatter.format(rec.time)}): ${rec.message}');
    }
  });

  return true;
}

@WebSocketHandler("/ws")
class ServerEndPoint {

  @OnOpen()
  void onOpen(WebSocketSession session) {
    log.info("connection established");
  }

  @OnMessage()
  void onMessage(String message, WebSocketSession session) {
    log.info("message received: $message");
//    session.connection.add("echo $message");
  }

  @OnError()
  void onError(error, WebSocketSession session) {
    log.info("error: $error");
  }

  @OnClose()
  void onClose(WebSocketSession session) {
    log.info("connection closed");
  }
}