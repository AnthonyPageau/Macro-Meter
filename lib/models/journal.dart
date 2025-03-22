import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';

class Journal {
  Journal({required String id, required DateTime date, required Plan plan})
      : _id = id,
        _date = date,
        _plan = plan;

  String _id;
  DateTime _date;
  Plan _plan;

  String get id => _id;
  DateTime get date => _date;
  Plan get plan => _plan;

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
}
