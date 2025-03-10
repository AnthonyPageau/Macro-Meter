import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/widgets/meals/meal_item.dart';

class MealList extends StatelessWidget {
  const MealList({super.key, required this.meals, required this.user});

  final List<Meal> meals;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(meal: meals[index], user: user);
      },
    );
  }
}
