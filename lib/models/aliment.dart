import 'package:flutter/material.dart';

enum AlimentCategory { protein, fruitsAndVegetable, dairy, cereal, other }

enum AlimentUnit { grams, cup, tbsp, tsp, ounces, item, ml }

const categoryIcons = {
  AlimentCategory.protein: Icons.egg_alt_outlined,
  AlimentCategory.fruitsAndVegetable: Icons.apple,
  AlimentCategory.dairy: Icons.local_drink,
  AlimentCategory.cereal: Icons.breakfast_dining,
  AlimentCategory.other: Icons.fastfood
};

class Aliment {
  Aliment(
      {required String id,
      required String name,
      required int calories,
      required num proteines,
      required num carbs,
      required num fats,
      required AlimentUnit unit,
      required num quantity,
      required AlimentCategory category,
      required bool isChecked})
      : _id = id,
        _name = name,
        _calories = calories,
        _proteines = proteines,
        _carbs = carbs,
        _fats = fats,
        _unit = unit,
        _quantity = quantity,
        _category = category,
        _isChecked = isChecked;

  String _id;
  String _name;
  int _calories;
  num _proteines;
  num _carbs;
  num _fats;
  AlimentUnit _unit;
  num _quantity;
  AlimentCategory _category;
  bool _isChecked;

  String get id => _id;
  String get name => _name;
  int get calories => _calories;
  num get proteines => _proteines;
  num get carbs => _carbs;
  num get fats => _fats;
  AlimentUnit get unit => _unit;
  num get quantity => _quantity;
  AlimentCategory get category => _category;
  bool get isChecked => _isChecked;

  set id(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _id = trimmed;
    } else {
      throw ArgumentError("L'ID ne peut pas être vide.");
    }
  }

  set name(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _name = trimmed;
    } else {
      throw ArgumentError("Le nom ne peut pas être vide.");
    }
  }

  set calories(int value) {
    if (value >= 0) {
      _calories = value;
    } else {
      throw ArgumentError(
          "Les calories doivent être supérieures ou égales à zéro.");
    }
  }

  set proteines(num value) {
    if (value >= 0) {
      _proteines = value;
    } else {
      throw ArgumentError(
          "Les protéines doivent être supérieures ou égales à zéro.");
    }
  }

  set carbs(num value) {
    if (value >= 0) {
      _carbs = value;
    } else {
      throw ArgumentError(
          "Les glucides doivent être supérieurs ou égaux à zéro.");
    }
  }

  set fats(num value) {
    if (value >= 0) {
      _fats = value;
    } else {
      throw ArgumentError(
          "Les lipides doivent être supérieurs ou égaux à zéro.");
    }
  }

  set quantity(num value) {
    if (value >= 0) {
      _quantity = value;
    } else {
      throw ArgumentError("La quantité doit être supérieure ou égale à zéro.");
    }
  }

  set unit(AlimentUnit value) {
    _unit = value;
  }

  set category(AlimentCategory value) {
    _category = value;
  }

  set isChecked(bool value) {
    _isChecked = value;
  }

  String unitToString(AlimentUnit type) {
    switch (type) {
      case AlimentUnit.grams:
        return "G";
      case AlimentUnit.cup:
        return "Tasse";
      case AlimentUnit.tbsp:
        return "Tbsp";
      case AlimentUnit.tsp:
        return "Tsp";
      case AlimentUnit.ounces:
        return "Onces";
      case AlimentUnit.item:
        return "Item";
      case AlimentUnit.ml:
        return "mL";
    }
  }

  void updateValues(num updatedQuantity) {
    num ratio = updatedQuantity / quantity;

    calories = (calories * ratio).toInt();
    proteines *= ratio;
    carbs *= ratio;
    fats *= ratio;
    quantity = updatedQuantity;
  }
}
