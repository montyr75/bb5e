import 'dart:html' as HTML;
import 'package:bb5e/client/shared.dart';
import 'package:firebase/firebase.dart' as FB;
//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
//import 'package:bb5e/comms/message.dart';

//ClientConnectionManager ccm = new ClientConnectionManager();

Map initModel;

void main() {
//  ccm.connectToServer(SERVER_IP, SERVER_PORT);

//  ccm.onMessage.listen((Message msg) {
//    initModel = msg.payload;
//
//    initModel.keys.forEach((String charName) {
//      HTML.querySelector('#${charName.toLowerCase()}-init').text = initModel[charName].toString();
//    });
//  });
//
//  HTML.querySelector('#get-btn').onClick.listen((HTML.Event event) {
//    ccm.sendMessage("DM", Message.GET_INIT);
//  });

  FB.Firebase ref = new FB.Firebase("$FIREBASE_PATH/characterData");

  ref.onValue.listen((FB.Event event) {
    Map characterData = event.snapshot.val();
    print(characterData);
  });
}
