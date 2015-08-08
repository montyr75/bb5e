library client.dm.character_data;

import '../../models/initiative_total_entry.dart';

class CharacterData {
  String charName = "";
  InitiativeTotalEntry<int> initiativeTotal;

  CharacterData();

  CharacterData.fromMap(Map map) {
    charName = map['charName'];
    initiativeTotal = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);
  }

  @override String toString() => "$charName-> ${initiativeTotal}";
}