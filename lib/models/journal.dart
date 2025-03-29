import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/aliment.dart';

class Journal {
  Journal(
      {required String id,
      required DateTime date,
      required Plan plan,
      required num targetCalories,
      required num targetProteines,
      required num targetFats,
      required num targetCarbs,
      required bool isComplete})
      : _id = id,
        _date = date,
        _plan = plan,
        _targetCalories = targetCalories,
        _targetProteines = targetProteines,
        _targetFats = targetFats,
        _targetCarbs = targetCarbs,
        _isComplete = isComplete;

  String _id;
  DateTime _date;
  Plan _plan;
  num _targetCalories;
  num _targetProteines;
  num _targetFats;
  num _targetCarbs;
  bool _isComplete;

  String get id => _id;
  DateTime get date => _date;
  Plan get plan => _plan;
  num get targetCalories => _targetCalories;
  num get targetProteines => _targetProteines;
  num get targetFats => _targetFats;
  num get targetCarbs => _targetCarbs;
  bool get isComplete => _isComplete;

  set id(String value) {
    if (value.isNotEmpty) {
      _id = value;
    }
  }

  set date(DateTime value) {
    _date = value;
  }

  set plan(Plan value) {
    _plan = value;
  }

  set targetCalories(num value) {
    if (value >= 0) {
      _targetCalories = value;
    }
  }

  set targetProteines(num value) {
    if (value >= 0) {
      _targetProteines = value;
    }
  }

  set targetFats(num value) {
    if (value >= 0) {
      _targetFats = value;
    }
  }

  set targetCarbs(num value) {
    if (value >= 0) {
      _targetCarbs = value;
    }
  }

  set isComplete(bool value) {
    _isComplete = value;
  }

  num totalCalories() {
    num total = 0;
    for (Meal meal in plan.meals) {
      for (Aliment aliment in meal.aliments) {
        if (aliment.isChecked) {
          total += aliment.calories;
        }
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  num totalProteines() {
    num total = 0;
    for (Meal meal in plan.meals) {
      for (Aliment aliment in meal.aliments) {
        if (aliment.isChecked) {
          total += aliment.proteines;
        }
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  num totalCarbs() {
    num total = 0;
    for (Meal meal in plan.meals) {
      for (Aliment aliment in meal.aliments) {
        if (aliment.isChecked) {
          total += aliment.carbs;
        }
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  num totalFats() {
    num total = 0;
    for (Meal meal in plan.meals) {
      for (Aliment aliment in meal.aliments) {
        if (aliment.isChecked) {
          total += aliment.fats;
        }
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  num remaningCalories() {
    num remaining = targetCalories - totalCalories();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  num remaningProteines() {
    num remaining = targetProteines - totalProteines();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  num remaningCarbs() {
    num remaining = targetCarbs - totalCarbs();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  num remaningFats() {
    num remaining = targetFats - totalFats();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }
}
