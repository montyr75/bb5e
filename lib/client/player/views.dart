library bb5e.client.player.views;

import 'dart:html';
import '../../client/shared.dart';
import '../../client/player/player_model.dart';

class PlayerInitiativeView implements View {
  PlayerModel _model;

  // UI refs
  InputElement charName;
  InputElement d20;
  InputElement dexMod;
  CheckboxInputElement spell;
  ButtonInputElement  spellLevel;
  InputElement meleeHW;
  InputElement meleeLW;
  InputElement meleeTwoHand;
  InputElement ranged;
  InputElement creatureSize;
  InputElement tiny;
  InputElement small;
  InputElement large;
  InputElement huge;
  InputElement garg;
  InputElement custom;
  InputElement customVeryHard;
  InputElement customHard;
  InputElement customEasy;
  InputElement customVeryEasy;

  PlayerInitiativeView(PlayerModel this._model) {
    _getUIReferences();
    _setupListeners();
  }

  void _getUIReferences() {
    charName = querySelector("#char-name");
    d20 = querySelector("#d20");
    dexMod = querySelector("#dex-mod");
    spell = querySelector("#spell");
    spellLevel = querySelector("#spell-level");
    meleeHW = querySelector("#melee-hw");
    meleeLW = querySelector("#melee-lw");
    meleeTwoHand = querySelector("#melee-twohand");
    ranged = querySelector("#ranged");
    creatureSize = querySelector("#creature-size");
    tiny = querySelector("#tiny");
    small = querySelector("#small");
    large = querySelector("#large");
    huge = querySelector("#huge");
    garg = querySelector("#garg");
    custom = querySelector("#custom");
    customVeryHard = querySelector("#custom-very-hard");
    customHard = querySelector("#custom-hard");
    customEasy = querySelector("#custom-easy");
    customVeryEasy = querySelector("#custom-very-easy");
  }

  void _setupListeners() {
    charName.onInput.listen((Event event) {
      _model.charName = (event.target as InputElement).value.trim();
      print(_model.charName);
    });

    //Needs to check input first. This is not implemented yet.
//    d20.onInput.listen((Event event) {
//      d20 = (event.target as InputElement).value.trim();
//    });

    //Needs to check input first. This is not implemented yet.
//    dexMod.onInput.listen((Event event) {
//      dexMod = (event.target as InputElement).value.trim();
//    });

    // example of adding a mod
//    _model.init.addMod(_model.gameModel.initiativeTotalMods[0].clone());
//    _model.init.addMod(_model.gameModel.initiativeTotalMods[3].clone());

    // example of removing a mod
//    _model.init.removeMod(_model.gameModel.initiativeTotalMods[3]);

    // ... and so on ...
  }
}