library bb5e.client.player.views;

import 'dart:html';
import 'dart:async';
import '../../client/shared.dart';
import '../../client/player/player_model.dart';
import 'package:firebase/firebase.dart' as FB;
//import '../client_connection_manager.dart';
//import '../../comms/message.dart';

class PlayerInitiativeView implements View {
  FB.Firebase _fbRef = new FB.Firebase("$FIREBASE_CHARACTER_PATH");
  FB.Firebase _charRef;

  PlayerModel _model;
//  ClientConnectionManager _ccm;

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
  ButtonElement submit;

  // UI refs (output)
  SpanElement initTotal;

  PlayerInitiativeView(PlayerModel this._model/*, ClientConnectionManager this._ccm*/) {
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
    submit = querySelector("#submit-to-dm");

    initTotal = querySelector("#init-total");
  }

  void _setupListeners() {
    void _setSpellMod(Event event) {
      if (spell.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[2].clone()..value = int.parse(spellLevel.value));
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[2]);
      }
    }

    //Worst function ever.
    void _setCreatureSizeMod(Event event) {
      if (creatureSize.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[int.parse(creatureSizeSel.value)].clone());
      }
      else {
        _model.initiativeTotal.removeSizeMods();
      }
    }

    void _setCustomMod(Event event) {
      if (custom.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[13].clone()..value = int.parse(customSel.value));
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[13]);
      }
    }

    void _setMeleeHWMod(Event event) {
      if (meleeHW.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[3].clone());
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[3]);
      }
    }

    void _setMeleeLWMod(Event event) {
      if (meleeLW.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[4].clone());
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[4]);
      }
    }

    void _setMeleeTwoHandMod(Event event) {
      if (meleeTwoHand.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[5].clone());
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[5]);
      }
    }

    void _setRangedLoadingMod(Event event) {
      if (rangedLoading.checked) {
        _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[6].clone());
      }
      else {
        _model.initiativeTotal.removeMod(_model.gameModel.initiativeTotalMods[6]);
      }
    }

    charName.onInput.listen((Event event) {
      _model.charName = (event.target as InputElement).value.trim();
    });

    actionDescription.onInput.listen((Event event) {
      _model.initiativeTotal.notes = (event.target as TextAreaElement).value.trim();
    });

    d20.onInput.listen((Event event) {
      int roll = int.parse(d20.value.trim(), onError: (_) => null);

      if (roll != null) {
        if (roll >= 1 && roll <= 20) {
          _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[0].clone()..value = roll);
        }
      }
    });

    dexMod.onInput.listen((Event event) {
      int dMod = int.parse(dexMod.value.trim().replaceAll("+", ""), onError: (_) => null);

      if (dMod != null) {
        if (dMod <= 5) {
          _model.initiativeTotal.addMod(_model.gameModel.initiativeTotalMods[1].clone()..value = dMod);
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

    submit.onClick.listen(_submitInit);

    eventBus.on(InitiativeTotalCalculatedEvent).listen((InitiativeTotalCalculatedEvent event) {
      if (event.value != null) {
        initTotal.text = event.value.toString();
      }
      else {
        initTotal.text = "";
      }
    });
  }

  void _submitInit(Event event) {
//    _ccm.sendMessage(charName.value, Message.INIT, _model.init.toMap());

    void showAlert(String type, String msg) {
      SpanElement alert = new SpanElement()..classes.addAll(["alert", "alert-$type"])..setAttribute("role", "alert");
      alert.appendHtml('<span>$msg</span>');
      DivElement totalCard = querySelector("#total-card")..children.add(alert);
      new Timer(const Duration(seconds: 2), () => totalCard.children.remove(alert));
    }

    void showSuccess([_]) {
      showAlert("success", '<strong>Success!</strong>');
    }

    void showError([_]) {
      showAlert("danger", '<strong>Error!</strong>');
    }

    if (_model.charName.isEmpty) {
      return;
    }

    Map characterDataMap = _model.toCharacterDataMap();

    if (_charRef != null) {
      _charRef.set(characterDataMap).then(showSuccess);
    }
    else {
      _charRef = _fbRef.push()..set(characterDataMap).then(showSuccess);
      _charRef.onDisconnect.remove();
    }

  }
}