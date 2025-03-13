import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/meal_item.dart';

class MealList extends StatelessWidget {
  const MealList(
      {super.key,
      required this.meals,
      required this.user,
      required this.plan,
      required this.onAddMeal,
      required this.onAddAliment,
      required this.onDeleteALiment});

  final List<Meal> meals;
  final User user;
  final Plan plan;
  final void Function(Meal newMeal) onAddMeal;
  final void Function(Aliment newAliment) onAddAliment;
  final void Function(Aliment deletedAliment) onDeleteALiment;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return MealItem(
          meal: meals[index],
          user: user,
          plan: plan,
          onAddMeal: (newMeal) {
            onAddMeal(newMeal);
          },
          onAddAliment: (newAliment) {
            onAddAliment(newAliment);
          },
          onDeleteALiment: (deletedAliment) {
            onDeleteALiment(deletedAliment);
          },
        );
      },
    );
  }
}
