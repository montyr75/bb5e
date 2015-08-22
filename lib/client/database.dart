library server.database;

import 'dart:async';
import 'package:firebase/firebase.dart';
import '../models/global.dart';

class Database implements DatabaseInterface {

  Firebase _fbRef = new Firebase("$FIREBASE_CHARACTER_PATH");
  Firebase _charRef;

  Database();

  Future<Map> getGameData() async {
    Completer completer = new Completer();
    DataSnapshot snapshot = await new Firebase("$FIREBASE_PATH/gameData/mods").once("value");
    completer.complete(snapshot.val());
    return completer.future;
  }

  void saveCharacterData(Map characterMap) {
    log.info("$runtimeType::saveCharacterData() -- $characterMap");

    // if character exists, just update it
    if (_charRef != null) {
      _charRef.set(characterMap)/*.then(showSuccess)*/;
    }
    // otherwise, create the character in the database
    else {
      _charRef = _fbRef.push()..set(characterMap)/*.then(showSuccess)*/;
      _charRef.onDisconnect.remove();
    }
  }
}