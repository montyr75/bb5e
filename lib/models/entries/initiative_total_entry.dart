library bb5e.models.entries.inititative_total_entry;

import '../mod.dart';
import '../entry.dart';

class InitiativeTotalEntry extends CalculatedEntry {
  @override void addMod(Mod mod) {
    // preserve uniqueness
    if (mods.indexOf(mod) == -1) {
      // only one size allowed
      if (mod.subtype == "Size") {
        mods.removeWhere((Mod mod) => mod.subtype == "Size");
      }

      super.addMod(mod);
    }

  }

  @override void calculate() {
    super.calculate();
  }

  @override String toString() => "Initiative Total: $value\n  $mods";
}

// ** MODS **
String initiativeTotalModsJSON = '''
  [
    {
      "level": null,
      "name": "Initiative Roll",
      "type": "BASE",
      "subtype": null,
      "source": "CUSTOM",
      "affectedStat": "initiativeTotal",
      "value": null,
      "description": "Base initiative roll (DEX check).",
      "ref": "PHB 189"
    },
    {
      "level": null,
      "name": "Dexterity Modifier",
      "type": "MODIFIER",
      "subtype": null,
      "source": "CUSTOM",
      "affectedStat": "initiativeTotal",
      "value": null,
      "description": "Modifier based on Dexterity score.",
      "ref": null
    },
    {
      "level": null,
      "name": "Spellcasting",
      "type": "PENALTY",
      "subtype": null,
      "source": "CUSTOM",
      "affectedStat": "initiativeTotal",
      "value": null,
      "description": "Speed factor initiative modifier based on spell level.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Melee, heavy weapon",
      "type": "PENALTY",
      "subtype": null,
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -2,
      "description": "Speed factor initiative modifier based on size/weight of weapon.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Melee, light or finesse weapon",
      "type": "BONUS",
      "subtype": null,
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 2,
      "description": "Speed factor initiative modifier based on size/weight of weapon.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Melee, two-handed weapon",
      "type": "PENALTY",
      "subtype": null,
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -2,
      "description": "Speed factor initiative modifier based on size/weight of weapon.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Ranged, loading weapon",
      "type": "PENALTY",
      "subtype": null,
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -5,
      "description": "Speed factor initiative modifier for using a ranged weapon requiring effort to reload.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Creature Size: Tiny",
      "type": "BONUS",
      "subtype": "Size",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 5,
      "description": "Speed factor initiative modifier based on creature size.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Creature Size: Small",
      "type": "BONUS",
      "subtype": "Size",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 2,
      "description": "Speed factor initiative modifier based on creature size.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Creature Size: Large",
      "type": "PENALTY",
      "subtype": "Size",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -2,
      "description": "Speed factor initiative modifier based on creature size.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Creature Size: Huge",
      "type": "PENALTY",
      "subtype": "Size",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -5,
      "description": "Speed factor initiative modifier based on creature size.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Creature Size: Gargantuan",
      "type": "PENALTY",
      "subtype": "Size",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": -8,
      "description": "Speed factor initiative modifier based on creature size.",
      "ref": "DMG 270"
    },
    {
      "level": null,
      "name": "Incapacitated",
      "type": "PENALTY",
      "subtype": "Condition",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 0,
      "description": "Incapacitated characters cannot move or take actions, and they have an initiative total of 0.",
      "ref": "PHB 291"
    },
    {
      "level": null,
      "name": "Unconscious",
      "type": "PENALTY",
      "subtype": "Condition",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 0,
      "description": "Unconscious characters are incapcitated.",
      "ref": "PHB 292"
    },
    {
      "level": null,
      "name": "Surprised",
      "type": "PENALTY",
      "subtype": "Condition",
      "source": "null",
      "affectedStat": "initiativeTotal",
      "value": 0,
      "description": "Surprised characters are incapcitated for one round.",
      "ref": "PHB 189"
    },
    {
      "level": null,
      "name": "Other",
      "type": "MODIFIER",
      "subtype": null,
      "source": "CUSTOM",
      "affectedStat": "initiativeTotal",
      "value": 0,
      "description": null,
      "ref": null
    },
    {
      "level": null,
      "name": "Stunned",
      "type": "MODIFIER",
      "subtype": "Condition",
      "source": null,
      "affectedStat": "initiativeTotal",
      "value": null,
      "description": "Stunned characters are incapcitated.",
      "ref": null
    }
  ]
''';