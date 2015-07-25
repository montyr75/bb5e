library server;

import 'package:logging/logging.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:redstone/server.dart' as Redstone;
import 'package:redstone_web_socket/redstone_web_socket.dart';
import 'package:bb5e/comms/comms.dart';
import 'package:bb5e/comms/message.dart';

// define logger
final Logger log = new Logger("bb5e");

Map initModel = {};

@WebSocketHandler("/ws")
class ServerEndPoint {

  @OnOpen()
  void onOpen(WebSocketSession session) {
    log.info("connection established");
  }

  @OnMessage()
  void onMessage(String message, WebSocketSession session) {
    log.info("message received: $message");

    Message msg = new Message.fromJSON(message);

    switch (msg.type) {
      case Message.INIT: initModel[msg.charName] = msg.payload['value']; break;
      case Message.GET_INIT: session.connection.add(new Message(null, null, Message.INIT, initModel)); break;
    }

    log.info(initModel);
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

