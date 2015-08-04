library bb5e.models.game_model;

import 'package:firebase/firebase.dart' as FB;
import 'dart:convert';
import 'mod.dart';
import 'initiative_total_entry.dart';
import '../client/shared.dart';

class GameModel {
  List<Mod<int>> initiativeTotalMods;

  GameModel() {
    _initializeGameData();
  }

  _initializeGameData() async {
    int i = 0;
    List<Map> initiativeTotalModsMaps = JSON.decode(initiativeTotalModsJSON);

//    FB.Firebase initiativeTotalModsRef = new FB.Firebase("$FIREBASE_PATH/gameData/initiativeTotalMods");
//    FB.DataSnapshot snapshot = await initiativeTotalModsRef.once("value");
//    List<Map> initiativeTotalModsMaps = snapshot.val();

    initiativeTotalMods = initiativeTotalModsMaps.map((Map map) => new Mod<int>.fromMap(map)..id = i++).toList();
  }
}