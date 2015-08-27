import 'dart:html';
import 'dart:convert';
import 'package:firebase/firebase.dart' as FB;

FB.Firebase ref = new FB.Firebase("https://incandescent-heat-2470.firebaseio.com/gameData/mods");

// UI refs
InputElement jsonFileName_txt = querySelector("#json-file-txt");
ButtonElement insertMods_btn = querySelector("#insert-mods-btn");

void main() {
  insertMods_btn.onClick.listen((_) => insertMods());
}

insertMods() async {
  String filename = jsonFileName_txt.value;
  String modsJSON = await HttpRequest.getString("assets/data/$filename");
  List<Map> modMaps = JSON.decode(modsJSON);

  modMaps.forEach((Map mod) {
    ref.push(value: mod);
  });
}
