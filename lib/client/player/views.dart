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
  SelectElement spellLevel;
  InputElement meleeHW;
  InputElement meleeLW;
  InputElement meleeTwoHand;
  InputElement rangedLoading;
  InputElement creatureSize;
  InputElement custom;

  PlayerInitiativeView(PlayerModel this._model) {
    _getUIReferences();
    _setupListeners();
  }

  void _getUIReferences() {
    charName = querySelector("#char-name");
    d20 = querySelector("#d20");
    dexMod = querySelector("#dex-mod");
    spell = querySelector("#spell-cb");
    spellLevel = querySelector("#spell-level-sel");
  }

  void _setupListeners() {
    void _setSpellMod(Event event) {
      if (spell.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[2].clone()..value = int.parse(spellLevel.value));
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[2]);
      }
    }

    charName.onInput.listen((Event event) {
      _model.charName = (event.target as InputElement).value.trim();
    });

    d20.onInput.listen((Event event) {
      int roll = int.parse(d20.value.trim(), onError: (_) => null);

      if (roll != null) {
        if (roll >= 1 && roll <= 20) {
          _model.init.addMod(_model.gameModel.initiativeTotalMods[0].clone()..value = roll);
        }
      }
    });

    spell.onChange.listen(_setSpellMod);
    spellLevel.onChange.listen(_setSpellMod);

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