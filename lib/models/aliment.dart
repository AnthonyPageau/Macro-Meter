import 'package:flutter/material.dart';

enum Category { protein, fruitsAndVegetable, dairy, cereal, other }

enum Unit { grams, cup, tbsp, tsp, ounces, item, ml }

const categoryIcons = {
  Category.protein: Icons.egg_alt_outlined,
  Category.fruitsAndVegetable: Icons.apple,
  Category.dairy: Icons.local_drink,
  Category.cereal: Icons.breakfast_dining,
  Category.other: Icons.fastfood
};

class Aliment {
  Aliment(
      {required this.id,
      required this.name,
      required this.calories,
      required this.proteines,
      required this.carbs,
      required this.fat,
      required this.unit,
      required this.quantity,
      required this.category});

  String name;
  String id;
  int calories;
  num proteines;
  num carbs;
  num fat;
  Unit unit;
  num quantity;
  Category category;

  String unitToString(Unit type) {
    switch (type) {
      case Unit.grams:
        return "G";
      case Unit.cup:
        return "Tasse";
      case Unit.tbsp:
        return "Tbsp";
      case Unit.tsp:
        return "Tsp";
      case Unit.ounces:
        return "Onces";
      case Unit.item:
        return "Item";
      case Unit.ml:
        return "mL";
    }
  }

  void updateValues(num updatedQuantity) {
    num ratio = updatedQuantity / quantity;

    calories = (calories * ratio).toInt();
    proteines *= ratio;
    carbs *= ratio;
    fat *= ratio;
    quantity = updatedQuantity;
  }
}
