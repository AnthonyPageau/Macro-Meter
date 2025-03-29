import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/models/aliment.dart';

class Meal {
  Meal({
    required String id,
    required String name,
    required Timestamp createdAt,
    List<Aliment>? aliments,
  })  : _id = id,
        _name = name,
        _createdAt = createdAt,
        _aliments = aliments ?? [];

  String _id;
  String _name;
  Timestamp _createdAt;
  List<Aliment> _aliments;

  String get id => _id;
  String get name => _name;
  Timestamp get createdAt => _createdAt;
  List<Aliment> get aliments => _aliments;

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

  set createdAt(Timestamp value) {
    _createdAt = value;
  }

  set aliments(List<Aliment> value) {
    _aliments = value;
  }

  num totalCalories() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.calories;
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalProteines() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.proteines;
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalCarbs() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.carbs;
    }

    return double.parse(total.toStringAsFixed(2));
  }

  num totalFats() {
    num total = 0;
    for (Aliment aliment in aliments) {
      total += aliment.fats;
    }

    return double.parse(total.toStringAsFixed(2));
  }
}
