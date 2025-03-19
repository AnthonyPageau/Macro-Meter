import 'package:macro_meter/models/meal.dart';

class Plan {
  Plan(
      {required this.id,
      required this.name,
      required this.date,
      List<Meal>? meals})
      : meals = meals ?? [];

  String id;
  String name;
  DateTime date;
  List<Meal> meals;

  num totalCalories() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalCalories();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalProteines() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalProteines();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalCarbs() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalCarbs();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalFats() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalFats();
    }

    return double.parse(total.toStringAsFixed(2));
  }
}
