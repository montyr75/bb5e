library bb5e.client.player.views;

import 'dart:html';
import '../../client/shared.dart';
import '../../client/player/player_model.dart';

class PlayerInitiativeView implements View {
  PlayerModel _model;

  // UI refs (global)
  InputElement charName;
  TextAreaElement actionDescription;

  // UI refs (initiative)
  InputElement d20;
  InputElement dexMod;
  CheckboxInputElement spell;
  SelectElement spellLevel;
  CheckboxInputElement meleeHW;
  CheckboxInputElement meleeLW;
  CheckboxInputElement meleeTwoHand;
  CheckboxInputElement rangedLoading;
  CheckboxInputElement creatureSize;
  SelectElement creatureSizeSel;
  CheckboxInputElement custom;
  SelectElement customSel;

  // UI refs (output)
  SpanElement initTotal;

  PlayerInitiativeView(PlayerModel this._model) {
    _getUIReferences();
    _setupListeners();
  }

  void _getUIReferences() {
    charName = querySelector("#char-name");
    actionDescription = querySelector("#description-txt");

    d20 = querySelector("#d20");
    dexMod = querySelector("#dex-mod");
    spell = querySelector("#spell-cb");
    spellLevel = querySelector("#spell-level-sel");
    creatureSize = querySelector("#creature-size-cb");
    creatureSizeSel = querySelector("#creature-size-sel");
    custom = querySelector("#custom-cb");
    customSel = querySelector("#custom-sel");
    meleeHW = querySelector("#melee-hw-cb");
    meleeLW = querySelector("#melee-lw-cb");
    meleeTwoHand = querySelector("#melee-twohand-cb");
    rangedLoading = querySelector("#ranged-loading-cb");

    initTotal = querySelector("#init-total");
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

    //Worst function ever.
    void _setCreatureSizeMod(Event event) {
      if (creatureSize.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[int.parse(creatureSizeSel.value)].clone());
      }
      else {
        _model.init.removeSizeMods();
      }
    }

    void _setCustomMod(Event event) {
      if (custom.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[13].clone()..value = int.parse(customSel.value));
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[13]);
      }
    }

    void _setMeleeHWMod(Event event) {
      if (meleeHW.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[3].clone());
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[3]);
      }
    }

    void _setMeleeLWMod(Event event) {
      if (meleeLW.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[4].clone());
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[4]);
      }
    }

    void _setMeleeTwoHandMod(Event event) {
      if (meleeTwoHand.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[5].clone());
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[5]);
      }
    }

    void _setRangedLoadingMod(Event event) {
      if (rangedLoading.checked) {
        _model.init.addMod(_model.gameModel.initiativeTotalMods[6].clone());
      }
      else {
        _model.init.removeMod(_model.gameModel.initiativeTotalMods[6]);
      }
    }

    charName.onInput.listen((Event event) {
      _model.charName = (event.target as InputElement).value.trim();
    });

    actionDescription.onInput.listen((Event event) {
      _model.actionDescription = (event.target as TextAreaElement).value.trim();
    });

    d20.onInput.listen((Event event) {
      int roll = int.parse(d20.value.trim(), onError: (_) => null);

      if (roll != null) {
        if (roll >= 1 && roll <= 20) {
          _model.init.addMod(_model.gameModel.initiativeTotalMods[0].clone()..value = roll);
        }
      }
    });

    dexMod.onInput.listen((Event event) {
    //Need to implement real text cleanup.
      int dMod = int.parse(dexMod.value.trim()..trimLeft(), onError: (_) => null);

      if (dMod != null) {
        if (dMod <= 5) {
          _model.init.addMod(_model.gameModel.initiativeTotalMods[1].clone()..value = dMod);
        }
      }
    });

    spell.onChange.listen(_setSpellMod);
    spellLevel.onChange.listen(_setSpellMod);

    creatureSize.onChange.listen(_setCreatureSizeMod);
    creatureSizeSel.onChange.listen(_setCreatureSizeMod);

    custom.onChange.listen(_setCustomMod);
    customSel.onChange.listen(_setCustomMod);

    meleeHW.onChange.listen(_setMeleeHWMod);
    meleeLW.onChange.listen(_setMeleeLWMod);
    meleeTwoHand.onChange.listen(_setMeleeTwoHandMod);
    rangedLoading.onChange.listen(_setRangedLoadingMod);

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