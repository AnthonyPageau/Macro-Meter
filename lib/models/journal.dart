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
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _id = trimmed;
    } else {
      throw ArgumentError("L'ID ne peut pas être vide.");
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
    } else {
      throw ArgumentError("Les calories cibles doivent être positives.");
    }
  }

  set targetProteines(num value) {
    if (value >= 0) {
      _targetProteines = value;
    } else {
      throw ArgumentError("Les protéines cibles doivent être positives.");
    }
  }

  set targetFats(num value) {
    if (value >= 0) {
      _targetFats = value;
    } else {
      throw ArgumentError("Les lipides cibles doivent être positifs.");
    }
  }

  set targetCarbs(num value) {
    if (value >= 0) {
      _targetCarbs = value;
    } else {
      throw ArgumentError("Les glucides cibles doivent être positifs.");
    }
  }

  set isComplete(bool value) {
    _isComplete = value;
  }

  /// Calcule le total calorie d'un journal
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

  /// Calcule le totale protéine d'un journal
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

  /// Calcule le totale des glucides d'un journal
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

  /// Calcule le totale des lipides d'un journal
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

  /// Calcule les calories restantes à manger
  num remaningCalories() {
    num remaining = targetCalories - totalCalories();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  /// Calcule les protéines restantes à manger
  num remaningProteines() {
    num remaining = targetProteines - totalProteines();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  /// Calcule les glucides restantes à manger
  num remaningCarbs() {
    num remaining = targetCarbs - totalCarbs();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }

  /// Calcule les lipides restantes à manger
  num remaningFats() {
    num remaining = targetFats - totalFats();
    remaining = remaining < 0 ? 0 : remaining;
    return double.parse(remaining.toStringAsFixed(2));
  }
}
