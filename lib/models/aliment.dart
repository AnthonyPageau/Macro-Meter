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
      required this.protein,
      required this.carbs,
      required this.fat,
      required this.unit,
      required this.quantity,
      required this.category});

  String name;
  String id;
  int calories;
  num protein;
  num carbs;
  num fat;
  Unit unit;
  num quantity;
  Category category;
}
