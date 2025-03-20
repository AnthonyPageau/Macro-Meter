import 'package:macro_meter/models/meal.dart';

class Plan {
  Plan(
      {required String id,
      required String name,
      required DateTime date,
      List<Meal>? meals})
      : _id = id,
        _name = name,
        _date = date,
        _meals = meals ?? [];

  String _id;
  String _name;
  DateTime _date;
  List<Meal> _meals;

  String get id => _id;
  String get name => _name;
  DateTime get date => _date;
  List<Meal> get meals => _meals;

  set id(String value) {
    if (value.isNotEmpty) {
      _id = value;
    }
  }

  set name(String value) {
    if (value.isNotEmpty) {
      _name = value;
    }
  }

  set date(DateTime value) {
    _date = value;
  }

  set meals(List<Meal> value) {
    meals = value;
  }

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
