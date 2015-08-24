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

    // if character exists in FB, remove it (necessary to make FB send events correctly)
    if (_charRef != null) {
      _charRef.remove();
    }

    // push the character data to FB
    _charRef = _fbRef.push()..set(characterMap)/*.then(showSuccess)*/;
    _charRef.onDisconnect.remove();
  }
}