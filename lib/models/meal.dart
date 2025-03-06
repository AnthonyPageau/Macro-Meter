import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';

class Meal {
  Meal({
    required this.id,
    required this.name,
    List<Aliment>? aliments,
    this.totalCalories = 0,
    this.totalProteines = 0,
    this.totalCarbs = 0,
    this.totalFats = 0,
  }) : aliments = aliments ?? [];

  String id;
  String name;
  List<Aliment> aliments;
  num totalCalories;
  num totalProteines;
  num totalCarbs;
  num totalFats;
}
