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
}
