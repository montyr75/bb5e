library client.dm.character;

import '../../models/initiative_total_entry.dart';

class Character {
  String charName = "";
  InitiativeTotalEntry<int> initiativeTotal;

  Character();

  Character.fromMap(Map map) {
    charName = map['charName'];
    initiativeTotal = new InitiativeTotalEntry<int>.fromMap(map['initiativeTotal']);
  }

  @override String toString() => "$charName-> ${initiativeTotal}";
}