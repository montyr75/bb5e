library server.database;

import 'dart:async';
import 'package:firebase/firebase.dart';
import '../models/global.dart';

class Database implements DatabaseInterface {

  Database();

  Future<Map> getGameData() async {
    Completer completer = new Completer();
    DataSnapshot snapshot = await new Firebase("$FIREBASE_PATH/gameData/mods").once("value");
    completer.complete(snapshot.val());
    return completer.future;
  }
}