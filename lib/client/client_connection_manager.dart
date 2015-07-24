library client.ccm;

import 'dart:html';
import 'dart:async';
import '../comms/message.dart';

class ClientConnectionManager {

  String _wsURL;
  WebSocket _webSocket;

  // event streams
  StreamController _onConnect = new StreamController.broadcast();
  StreamController _onDisconnect = new StreamController.broadcast();
  StreamController _onMessage = new StreamController.broadcast();

  bool connecting = false;
  bool connected = false;

  bool connectionPending = false;

  bool loggedIn = false;

  ClientConnectionManager();

  void connectToServer(serverIP, serverPort) {
    // reset status properties
    connecting = false;
    connected = false;
    connectionPending = false;

    _wsURL = "ws://$serverIP:$serverPort/ws";

    print("$runtimeType:: Connecting to $_wsURL");

    connecting = true;

    _webSocket = new WebSocket(_wsURL);

    _webSocket.onOpen.first.then((_) {
      print("$runtimeType:: Now connected on: ${_webSocket.url}");

      _webSocket.onMessage.listen((MessageEvent event) {
        _messageReceived(event.data);
      });

      _webSocket.onClose.first.then((_) {
        print("$runtimeType:: Disconnected on: ${_webSocket.url}");

        _disconnected();
      });

      // set status properties
      connecting = false;
      connected = true;
      connectionPending = false;

      _onConnect.add("Connected to server on ${_webSocket.url}");
    });

    _webSocket.onError.first.then((_) {
      _onConnect.addError(new StateError("Error connecting to server at ${_webSocket.url}"));
      _disconnected();
    });
  }

  void _messageReceived(String jsonStr) {
    Message message = new Message.fromJSON(jsonStr);

    print("$runtimeType::_messageReceived():\n  ${message}");

    _onMessage.add(message);
  }

  void _disconnected() {
    // if this is already being handled, don't repeat the onDisconnect event
    if (connectionPending) {
      return;
    }

    connecting = false;
    connected = false;
    connectionPending = true;

    _onDisconnect.add("No server connection.");
  }

  void sendMessage(String charName, String type, [var payload = null]) {
    _webSocket.sendString(new Message("Player", charName, type, payload).toJSON());
  }

  void disconnect() {
    _webSocket.close();
  }

  // event streams
  Stream<String> get onConnect => _onConnect.stream;
  Stream<String> get onDisconnect => _onDisconnect.stream;
  Stream<Message> get onMessage => _onMessage.stream;
}
