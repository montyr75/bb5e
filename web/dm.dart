import 'dart:html';
import 'package:bb5e/client/client_connection_manager.dart';
import 'package:bb5e/comms/comms.dart';
import 'package:bb5e/comms/message.dart';

ClientConnectionManager ccm = new ClientConnectionManager();

Map initModel;

void main() {
  ccm.connectToServer(SERVER_IP, SERVER_PORT);

  ccm.onMessage.listen((Message msg) {
    initModel = msg.payload;

    initModel.keys.forEach((String charName) {
      querySelector('#${charName.toLowerCase()}-init').text = initModel[charName];
    });
  });

  querySelector('#get-btn').onClick.listen((Event event) {
    ccm.sendMessage("DM", Message.GET_INIT);
  });
}
