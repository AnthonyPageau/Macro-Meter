import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';

class Journal {
  Journal(
      {required String id,
      required DateTime date,
      required Plan plan,
      required num targetCalories,
      required num targetProteines,
      required num targetFats,
      required num targetCarbs})
      : _id = id,
        _date = date,
        _plan = plan,
        _targetCalories = targetCalories,
        _targetProteines = targetProteines,
        _targetFats = targetFats,
        _targetCarbs = targetCarbs;

  String _id;
  DateTime _date;
  Plan _plan;
  num _targetCalories;
  num _targetProteines;
  num _targetFats;
  num _targetCarbs;

  String get id => _id;
  DateTime get date => _date;
  Plan get plan => _plan;
  num get targetCalories => _targetCalories;
  num get targetProteines => _targetProteines;
  num get targetFats => _targetFats;
  num get targetCarbs => _targetCarbs;

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
}
