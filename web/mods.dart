import 'dart:html';
import 'dart:convert';
import 'package:firebase/firebase.dart' as FB;

FB.Firebase ref = new FB.Firebase("https://incandescent-heat-2470.firebaseio.com/gameData/mods");

void main() {
  insertMods();
}

insertMods() async {
  String modsJSON = await HttpRequest.getString("assets/data/mods.json");
  List<Map> modMaps = JSON.decode(modsJSON);

  modMaps.forEach((Map mod) {
    ref.push(value: mod);
  });
}
