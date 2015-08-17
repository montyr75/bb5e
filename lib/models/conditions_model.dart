library bb5e.models.conditions_model;

import 'global.dart';

class ConditionsModel {
  bool blinded = false;
  bool charmed = false;
  bool deafened = false;
  bool frightened = false;
  bool grappled = false;
  bool _incapacitated = false;
  bool invisible = false;
  bool _paralyzed = false;
  bool _petrified = false;
  bool poisoned = false;
  bool prone = false;
  bool restrained = false;
  bool _stunned = false;
  bool _surprised = false;
  bool _unconscious = false;

  bool get incapacitated => _incapacitated;
  void set incapacitated(bool newVal) {
    _incapacitated = newVal;

    if (_incapacitated) {
      grappled = false;
    }
  }

  bool get paralyzed => _paralyzed;
  void set paralyzed(bool newVal) {
    _paralyzed = newVal;

    if (_paralyzed) {
      incapacitated = true;
    }
  }

  bool get petrified => _petrified;
  void set petrified(bool newVal) {
    _petrified = newVal;

    if (_petrified) {
      incapacitated = true;
    }
  }

  bool get stunned => _stunned;
  void set stunned(bool newVal) {
    _stunned = newVal;

    if (_stunned) {
      incapacitated = true;
    }
  }

  bool get surprised => _surprised;
  void set surprised(bool newVal) {
    _surprised = newVal;

    if (_surprised) {
      incapacitated = true;
    }
  }

  bool get unconscious => _unconscious;
  void set unconscious(bool newVal) {
    _unconscious = newVal;

    if (_unconscious) {
      incapacitated = true;
    }
  }
}