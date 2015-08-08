import 'dart:html' as HTML;
import 'package:bb5e/client/shared.dart';
import 'package:bb5e/models/mod.dart';
import 'package:bb5e/client/dm/character_data.dart';
import 'package:firebase/firebase.dart' as FB;
//import 'package:bb5e/client/client_connection_manager.dart';
//import 'package:bb5e/comms/comms.dart';
//import 'package:bb5e/comms/message.dart';

//ClientConnectionManager ccm = new ClientConnectionManager();

Map charModel;

// UI refs
HTML.DivElement initList = HTML.querySelector("#init-list");

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

  FB.Firebase ref = new FB.Firebase(FIREBASE_CHARACTER_PATH);

  ref.onValue.listen((FB.Event event) {
    charModel = event.snapshot.val();

    if (charModel != null) {
      initList.children.clear();

      charModel.keys.forEach((String charID) {
        CharacterData cd = new CharacterData.fromMap(charModel[charID]);
        Mod roll = cd.initiativeTotal.mods.firstWhere((Mod mod) => mod.id == 0, orElse: () => null);
        Mod dexMod = cd.initiativeTotal.mods.firstWhere((Mod mod) => mod.id == 1, orElse: () => null);
        int init = cd.initiativeTotal.value;

        if (roll != null && dexMod != null) {
          initList.appendHtml('''
            <a class="list-group-item" href="#">
              <div class="row">
                <div class="col-sm-4">
                  <h4 class="list-group-item-heading">$charID</h4>
                  <p class="list-group-item-text"></p>
                </div>
                <div class="col-sm-6">
                  <p class="list-group-item-text">Initiative Roll: ${roll.value}</p>
                  <p class="list-group-item-text list-group-item-text-small">Dexterity Modifier: ${dexMod.value > 0 ? "+" : ""}${dexMod.value}</p>
                </div>
                <div class="col-sm-2">
                  <h4 class="list-group-item-heading">$init</h4>
                </div>
              </div>
            </a>'''
          );
        }
      });
    }
  });
}
