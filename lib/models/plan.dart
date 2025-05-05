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

  set date(DateTime value) {
    _date = value;
  }

  set meals(List<Meal> value) {
    _meals = List<Meal>.from(value);
  }

  /// Calule le total calorique d'un plan
  num totalCalories() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalCalories();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  /// Calcule le total des protéines d'un plan
  num totalProteines() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalProteines();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  /// Calcule le total des glucides d'un plan
  num totalCarbs() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalCarbs();
    }

    return double.parse(total.toStringAsFixed(2));
  }

  /// Calcule le total des lipides d'un plan
  num totalFats() {
    num total = 0;
    for (Meal meal in meals) {
      total += meal.totalFats();
    }

    return double.parse(total.toStringAsFixed(2));
  }
}
