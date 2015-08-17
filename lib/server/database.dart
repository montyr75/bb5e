library server.database;

import 'dart:async';
import 'package:firebase_rest/firebase_rest.dart';
import '../models/global.dart';

class Database implements DatabaseInterface {

  Database();

  Future<Map> getGameData() async {
    Completer completer = new Completer();
    DataSnapshot snapshot = await new Firebase(Uri.parse("$FIREBASE_PATH/gameData/mods")).get();
    completer.complete(snapshot.val);
    return completer.future;
  }
}