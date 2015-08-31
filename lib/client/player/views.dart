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
  static const List<String> sizeMods = const <String>[
    "-JxlET8tgFA5bewaPihl",   // Tiny
    "-JxlET8wBBbwQL-ez2sT",   // Small
    "-JxlET8yXcgHAJMu9pm4",   // Medium
    "-JxlET9-2lIpta7qHQbE",   // Large
    "-JxlET91Grqmn1qIBMdQ",   // Huge
    "-JxlET92Ey_0WFpjqm24"    // Gargantuan
  ];

  // UI refs (input)
  InputElement charName = querySelector("#char-name");
  SelectElement creatureSizeSel = querySelector("#creature-size-sel");

  CharacterBasicsView(PlayerModel model) : super(model);

  @override void setupListeners() {
    charName.onInput.listen((Event event) {
      _model.character['name'].value = (event.target as InputElement).value.trim();
    });

    creatureSizeSel.onChange.listen((_) => _model.character.addMod(_model.gameModel.mods[sizeMods[int.parse(creatureSizeSel.value)]]));
  }
}

class ConditionsView extends View {

  // TODO: Figure out the UI for Condition: Exhausted and Condition: Dead

  // UI refs (input)
  Map<CheckboxInputElement, String> ui = {
    querySelector("#cond-blinded"): "-Jy19_zArP0fdYJOQ1mZ",
    querySelector("#cond-charmed"): "-Jy19_zCnQwNiHWXp1vv",
    querySelector("#cond-deafened"): "-Jy19_zDg1LHglwsx2v6",
    querySelector("#cond-frightened"): "-Jy19_zG38O3q8-6Y3iw",
    querySelector("#cond-grappled"): "-Jy19_zHipxj_0GQ_91W",
    querySelector("#cond-incapacitated"): "-Jy19_z40xsHO5J9N5Zb",
    querySelector("#cond-invisible"): "-Jy19_zI8IB4pBvj0vv9",
    querySelector("#cond-paralyzed"): "-Jy19_zKG8yClNE_t9fM",
    querySelector("#cond-petrified"): "-Jy19_zKG8yClNE_t9fN",
    querySelector("#cond-poisoned"): "-Jy19_zOP_D-DBZGyI8h",
    querySelector("#cond-prone"): "-Jy19_zOP_D-DBZGyI8i",
    querySelector("#cond-restrained"): "-Jy19_zQWR7tLOzC4e5k",
    querySelector("#cond-stunned"): "-Jy19_zRaKPxh2tHiu_P",
    querySelector("#cond-unconscious"): "-Jy19_zSKh-yOG69Ao6v",
    querySelector("#cond-surprised"): "-Jy19_zVohhAnh4_Dw81",
    querySelector("#cond-bloodied"): "-Jy19_zYI7IoQenWICjK"
  };

  ConditionsView(PlayerModel model) : super(model);

  @override void setupListeners() {
    log.info("$runtimeType :: setupListeners()");

    Character char = _model.character;
    Map<String, Mod> mods = _model.gameModel.mods;

    void _setMod(bool checked, String modID) {
      if (checked) {
        char.addMod(mods[modID]);
      }
      else {
        char.removeMod(modID);
      }
    }

    // create listeners
    ui.keys.forEach((CheckboxInputElement cb) {
      log.info("${cb.id} listening...");
      cb.onChange.listen((Event event) {
        log.info("${event.target.id} changed");
        _setMod((event.target as CheckboxInputElement).checked, ui[event.target]);
      });
    });

    querySelector("#test-cb").onChange.listen((Event event) {
      log.info("${event.target.id} changed");
    });

    // listen for model changes and update UI to match
    eventBus.on(ConditionsChangedEvent).listen((ConditionsChangedEvent event) {
      ui.keys.forEach((CheckboxInputElement cb) {
        String condition = cb.id.substring(5);
        condition = "${condition[0].toUpperCase()}${condition.substring(1)}";

        if (event.value[condition] != null) {
          cb.checked = true;
        }
      });
    });
  }
}

class InitiativeView extends View {
  static const String INIT_ROLL = "-JxlER7yTbE8jkNR0G8U";
  static const String DEX_MOD = "-JxlER83xf5vPpIlq5hd";

  // UI refs (input)
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

    // listen for model changes
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
  static const String SPELLCASTING = "-JxlER85H3cOG0wIh5iX";
  static const String MELEE_HW = "-JxlER86mVUEsDVSbSnn";
  static const String MELEE_LW = "-JxlER88XgSMKri4Zv73";
  static const String MELEE_TWO_HAND = "-JxlER8AEzrLT8VlFOBD";
  static const String RANGED_LOADING = "-JxlER8B3Reg8DBFxh3G";
  static const String CUSTOM_SPEED_FACTOR = "-JxlER8C0m219GZyx0YL";

  // UI refs (input)
  CheckboxInputElement spell = querySelector("#spell-cb");
  SelectElement spellLevel = querySelector("#spell-level-sel");
  CheckboxInputElement meleeHW = querySelector("#melee-hw-cb");
  CheckboxInputElement meleeLW = querySelector("#melee-lw-cb");
  CheckboxInputElement meleeTwoHand = querySelector("#melee-twohand-cb");
  CheckboxInputElement rangedLoading = querySelector("#ranged-loading-cb");
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

    spell.onChange.listen((_) => _setMod(spell.checked, SPELLCASTING, value: int.parse(spellLevel.value)));
    spellLevel.onChange.listen((_) => _setMod(spell.checked, SPELLCASTING, value: int.parse(spellLevel.value)));

    meleeHW.onChange.listen((_) => _setMod(meleeHW.checked, MELEE_HW));
    meleeLW.onChange.listen((_) => _setMod(meleeLW.checked, MELEE_LW));
    meleeTwoHand.onChange.listen((_) => _setMod(meleeTwoHand.checked, MELEE_TWO_HAND));
    rangedLoading.onChange.listen((_) => _setMod(rangedLoading.checked, RANGED_LOADING));

    custom.onChange.listen((_) => _setMod(custom.checked, CUSTOM_SPEED_FACTOR, value: int.parse(customSel.value)));
    customSel.onChange.listen((_) => _setMod(custom.checked, CUSTOM_SPEED_FACTOR, value: int.parse(customSel.value)));
  }
}