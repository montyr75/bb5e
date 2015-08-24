import 'dart:html';
import 'package:bb5e/models/global.dart';
import 'package:bb5e/models/mod.dart';
import 'package:bb5e/models/character.dart';
import 'package:firebase/firebase.dart' as FB;
//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
//import 'package:bb5e/comms/message.dart';

//ClientConnectionManager ccm = new ClientConnectionManager();

Map charModel = {};

// UI refs
DivElement initList = querySelector("#init-list");

void main() {
//  ccm.connectToServer(SERVER_IP, SERVER_PORT);

//  ccm.onMessage.listen((Message msg) {
//    initModel = msg.payload;
//
//    initModel.keys.forEach((String charName) {
//      querySelector('#${charName.toLowerCase()}-init').text = initModel[charName].toString();
//    });
//  });
//
//  querySelector('#get-btn').onClick.listen((Event event) {
//    ccm.sendMessage("DM", Message.GET_INIT);
//  });

  FB.Firebase ref = new FB.Firebase(FIREBASE_CHARACTER_PATH);

  ref.onChildAdded.listen((FB.Event event) {
    Map char = event.snapshot.val();
    charModel[getCharID(char)] = char;
    renderCharacters();
  });

  ref.onChildChanged.listen((FB.Event event) {
    Map char = event.snapshot.val();
    charModel[getCharID(char)] = char;
    renderCharacters();
  });

  ref.onChildRemoved.listen((FB.Event event) {
    Map char = event.snapshot.val();
    charModel.remove(getCharID(char));
    renderCharacters();
  });

  querySelector("#clear-btn").onClick.listen((_) {
    ref.remove();
    charModel = {};
    initList.children.clear();
  });
}

String getCharID(Map char) => (char['entries']['name']['value'] as String).toLowerCase().trim();

void renderCharacters() {
  if (charModel != null) {
    initList.children.clear();

    charModel.forEach((String charID, Map char) {
      String name = char['entries']['name']['value'];
      var roll = char['mods']['-JwnoPlDzNETWJ3aXle9']['affectedStats'][0]['value'];
      var dexMod = char['mods']['-JwnoPlFx3hz9pwAAYHn']['affectedStats'][0]['value'];
      var initTotal = char['entries']['initiativeTotal']['value'];

      initList.appendHtml('''
        <div class="row list-group-item">
          <div class="col-sm-4">
            <h4 class="list-group-item-heading">$name</h4>
            <p class="list-group-item-text"></p>
          </div>
          <div class="col-sm-6">
            <p class="list-group-item-text">Initiative Roll: $roll</p>
            <p class="list-group-item-text list-group-item-text-small">DEX Modifier: ${dexMod > 0 ? "+" : ""}${dexMod}</p>
          </div>
          <div class="col-sm-2">
            <h4 class="list-group-item-heading">$initTotal</h4>
          </div>
        </div>'''
      );
    });
  }
}