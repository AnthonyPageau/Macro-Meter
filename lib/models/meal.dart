import 'package:macro_meter/models/aliment.dart';

class Meal {
  Meal({
    required this.id,
    required this.name,
    List<Aliment>? aliments,
  }) : aliments = aliments ?? [];

  String id;
  String name;
  List<Aliment> aliments;

  num totalCalories() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.calories;
    }

    return total;
  }

  num totalProteines() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.proteines;
    }

    return total;
  }

  num totalCarbs() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.carbs;
    }

    return total;
  }

  num totalFats() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.fat;
    }

    return total;
  }
}
