import 'dart:ffi';

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

  final String id;
  final String name;
  final int calories;
  final num protein;
  final num carbs;
  final num fat;
  final Unit unit;
  final num quantity;
  final Category category;
}
