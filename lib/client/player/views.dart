library bb5e.client.player.views;

import 'dart:html';
import '../../client/player/player_model.dart';
import '../../models/global.dart';
import '../../models/character.dart';
import '../../models/mod.dart';
//import '../client_connection_manager.dart';
//import '../../comms/message.dart';

abstract class View {
  PlayerModel _model;

  View(PlayerModel this._model) {
    setupListeners();
  }

  // set up event listeners for UI elements
  void setupListeners();
}

class CharacterBasicsView extends View {
  InputElement charName = querySelector("#char-name");

  CharacterBasicsView(PlayerModel model) : super(model);

  @override void setupListeners() {
    charName.onInput.listen((Event event) {
      _model.character['name'].value = (event.target as InputElement).value.trim();
    });
  }
}

class InitiativeView extends View {
  static const String INIT_ROLL = "-JwnoPlDzNETWJ3aXle9";
  static const String DEX_MOD = "-JwnoPlFx3hz9pwAAYHn";

  InputElement initRoll = querySelector("#init-roll");
  InputElement dexMod = querySelector("#dex-mod");
  TextAreaElement actionDescription = querySelector("#action-description");

  // UI refs (output)
  SpanElement initTotal = querySelector("#init-total");

  InitiativeView(PlayerModel model) : super(model);

  @override void setupListeners() {
    Character char = _model.character;
    Map<String, Mod> mods = _model.gameModel.mods;

    initRoll.onInput.listen((Event event) {
      int roll = int.parse(initRoll.value.trim(), onError: (_) => null);

      if (roll != null) {
        if (roll >= 1 && roll <= 20) {
          char.addMod(mods[INIT_ROLL]..value = roll);
        }
      }
    });

    dexMod.onInput.listen((Event event) {
      int dMod = int.parse(dexMod.value.trim().replaceAll("+", ""), onError: (_) => 0);

      if (dMod <= 5) {
        char.addMod(mods[DEX_MOD]..value = dMod);
      }
    });

    actionDescription.onInput.listen((Event event) {
      char['initiativeTotal'].notes = (event.target as TextAreaElement).value.trim();
    });

    eventBus.on(InitiativeTotalCalculatedEvent).listen((InitiativeTotalCalculatedEvent event) {
      if (event.value != null) {
        initTotal.text = event.value.toString();
      }
      else {
        initTotal.text = "";
      }
    });
  }
}

//class SpeedFactorView extends View {
//  CheckboxInputElement spell;
//  SelectElement spellLevel;
//  CheckboxInputElement meleeHW;
//  CheckboxInputElement meleeLW;
//  CheckboxInputElement meleeTwoHand;
//  CheckboxInputElement rangedLoading;
//  CheckboxInputElement creatureSize;
//  SelectElement creatureSizeSel;
//  CheckboxInputElement custom;
//  SelectElement customSel;
//
//  SpeedFactorView(PlayerModel model) : super(model);
//
//  @override void setupListeners() {
//    charName.onInput.listen((Event event) {
//      _model.character['name'].value =
//          (event.target as InputElement).value.trim();
//    });
//  }
//
//  void _getUIReferences() {
//    spell = querySelector("#spell-cb");
//    spellLevel = querySelector("#spell-level-sel");
//    creatureSize = querySelector("#creature-size-cb");
//    creatureSizeSel = querySelector("#creature-size-sel");
//    custom = querySelector("#custom-cb");
//    customSel = querySelector("#custom-sel");
//    meleeHW = querySelector("#melee-hw-cb");
//    meleeLW = querySelector("#melee-lw-cb");
//    meleeTwoHand = querySelector("#melee-twohand-cb");
//    rangedLoading = querySelector("#ranged-loading-cb");
//  }
//
//  @override void setupListeners() {
//    Character char = _model.character;
//    Map<String, Mod> mods = _model.gameModel.mods;
//
//    void _setSpellMod(Event event) {
//      Mod mod = mods['crazyID'];
//
//      if (spell.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[2].clone()
//          ..value = int.parse(spellLevel.value));
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[2]);
//      }
//    }
//
//    //Worst function ever.
//    void _setCreatureSizeMod(Event event) {
//      if (creatureSize.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[int.parse(
//            creatureSizeSel.value)].clone());
//      }
//      else {
//        initTotalEntry.removeSizeMods();
//      }
//    }
//
//    void _setCustomMod(Event event) {
//      if (custom.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[13].clone()
//          ..value = int.parse(customSel.value));
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[13]);
//      }
//    }
//
//    void _setMeleeHWMod(Event event) {
//      if (meleeHW.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[3].clone());
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[3]);
//      }
//    }
//
//    void _setMeleeLWMod(Event event) {
//      if (meleeLW.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[4].clone());
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[4]);
//      }
//    }
//
//    void _setMeleeTwoHandMod(Event event) {
//      if (meleeTwoHand.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[5].clone());
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[5]);
//      }
//    }
//
//    void _setRangedLoadingMod(Event event) {
//      if (rangedLoading.checked) {
//        initTotalEntry.addMod(_model.gameModel.initiativeTotalMods[6].clone());
//      }
//      else {
//        initTotalEntry.removeMod(_model.gameModel.initiativeTotalMods[6]);
//      }
//    }
//
//    spell.onChange.listen(_setSpellMod);
//    spellLevel.onChange.listen(_setSpellMod);
//
//    creatureSize.onChange.listen(_setCreatureSizeMod);
//    creatureSizeSel.onChange.listen(_setCreatureSizeMod);
//
//    custom.onChange.listen(_setCustomMod);
//    customSel.onChange.listen(_setCustomMod);
//
//    meleeHW.onChange.listen(_setMeleeHWMod);
//    meleeLW.onChange.listen(_setMeleeLWMod);
//    meleeTwoHand.onChange.listen(_setMeleeTwoHandMod);
//    rangedLoading.onChange.listen(_setRangedLoadingMod);
//  }
//}