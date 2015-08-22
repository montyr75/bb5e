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

    void _setMod(String modID, {value}) {
      Mod mod = mods[modID];

      if (value != null) {
        char.addMod(mod..setValue(value, statName: 'initiativeTotal'));
      }
      else {
        char.removeMod(mod.id);
      }
    }

    initRoll.onInput.listen((_) {
      int value = int.parse(initRoll.value.trim(), onError: (_) => null);
      value = value != null && value >= 1 && value <= 20 ? value : null;
      _setMod(INIT_ROLL, value: value);
    });

    dexMod.onInput.listen((_) {
      int value = int.parse(dexMod.value.trim().replaceAll("+", ""), onError: (_) => null);
      value = value != null && value <= 5 ? value : null;
      _setMod(DEX_MOD, value: value);
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

class SpeedFactorView extends View {
  static const String SPELLCASTING = "-JwnoPlGm5tYgTJyp8pY";
  static const String MELEE_HW = "-JwnoPlHFgrIsZXmMYKE";
  static const String MELEE_LW = "-JwnoPlIvT4px-phgWlD";
  static const String MELEE_TWO_HAND = "-JwnoPlLXsiqHFXaNcm6";
  static const String RANGED_LOADING = "-JwnoPlMNtQEir2cFkUD";
  static const String CUSTOM_SPEED_FACTOR = "-JwnoPlNGljXXDbGim8_";

  CheckboxInputElement spell = querySelector("#spell-cb");
  SelectElement spellLevel = querySelector("#spell-level-sel");
  CheckboxInputElement meleeHW = querySelector("#melee-hw-cb");
  CheckboxInputElement meleeLW = querySelector("#melee-lw-cb");
  CheckboxInputElement meleeTwoHand = querySelector("#melee-twohand-cb");
  CheckboxInputElement rangedLoading = querySelector("#ranged-loading-cb");
  CheckboxInputElement creatureSize = querySelector("#creature-size-cb");
  SelectElement creatureSizeSel = querySelector("#creature-size-sel");
  CheckboxInputElement custom = querySelector("#custom-cb");
  SelectElement customSel = querySelector("#custom-sel");

  SpeedFactorView(PlayerModel model) : super(model);

  @override void setupListeners() {
    Character char = _model.character;
    Map<String, Mod> mods = _model.gameModel.mods;

    void _setMod(bool checked, String modID, {value}) {
      Mod mod = mods[modID];

      if (checked) {
        if (value != null) {
          mod.setValue(value, statName: 'initiativeTotal');
        }

        char.addMod(mod);
      }
      else {
        char.removeMod(mod.id);
      }
    }

    // TODO: Add creature size mods to database
//    void _setCreatureSizeMod(_) {
//      if (creatureSize.checked) {
//        char.addMod(_model.gameModel.initiativeTotalMods[int.parse(
//            creatureSizeSel.value)].clone());
//      }
//      else {
//        char.removeSizeMods();
//      }
//    }

    spell.onChange.listen((_) => _setMod(spell.checked, SPELLCASTING, value: int.parse(spellLevel.value)));
    spellLevel.onChange.listen((_) => _setMod(spell.checked, SPELLCASTING, value: int.parse(spellLevel.value)));

    meleeHW.onChange.listen((_) => _setMod(meleeHW.checked, MELEE_HW));
    meleeLW.onChange.listen((_) => _setMod(meleeLW.checked, MELEE_LW));
    meleeTwoHand.onChange.listen((_) => _setMod(meleeTwoHand.checked, MELEE_TWO_HAND));
    rangedLoading.onChange.listen((_) => _setMod(rangedLoading.checked, RANGED_LOADING));

    custom.onChange.listen((_) => _setMod(custom.checked, CUSTOM_SPEED_FACTOR, value: int.parse(customSel.value)));
    customSel.onChange.listen((_) => _setMod(custom.checked, CUSTOM_SPEED_FACTOR, value: int.parse(customSel.value)));

//    creatureSize.onChange.listen(_setCreatureSizeMod);
//    creatureSizeSel.onChange.listen(_setCreatureSizeMod);
  }
}