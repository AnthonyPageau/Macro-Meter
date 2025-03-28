import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/meal_item.dart';

class MealList extends StatelessWidget {
  const MealList(
      {super.key,
      required this.meals,
      required this.user,
      required this.plan,
      this.journal,
      required this.onAddMeal,
      required this.onAddAliment,
      required this.onDeleteALiment,
      required this.onDeleteMeal,
      required this.onModifyQuantity,
      this.onCheckedMeal,
      this.onCheckedAliment});

  final List<Meal> meals;
  final User user;
  final Plan plan;
  final Journal? journal;
  final void Function(Meal newMeal) onAddMeal;
  final void Function(Aliment newAliment) onAddAliment;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Meal deletedMeal) onDeleteMeal;
  final void Function(Aliment modifiedAliment) onModifyQuantity;
  final void Function(bool checkedMeal)? onCheckedMeal;
  final void Function(bool checkedAliment)? onCheckedAliment;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        return journal != null
            ? MealItem(
                meal: meals[index],
                user: user,
                plan: plan,
                journal: journal,
                onAddMeal: (newMeal) {
                  onAddMeal(newMeal);
                },
                onAddAliment: (newAliment) {
                  onAddAliment(newAliment);
                },
                onDeleteALiment: (deletedAliment) {
                  onDeleteALiment(deletedAliment);
                },
                onDeleteMeal: (deletedMeal) {
                  onDeleteMeal(deletedMeal);
                },
                onModifyQuantity: (modifiedAliment) {
                  onModifyQuantity(modifiedAliment);
                },
                onCheckedMeal: (checkedMeal) {
                  onCheckedMeal!(checkedMeal);
                },
                onCheckedAliment: (checkedAliment) {
                  onCheckedAliment!(checkedAliment);
                },
              )
            : MealItem(
                meal: meals[index],
                user: user,
                plan: plan,
                journal: journal,
                onAddMeal: (newMeal) {
                  onAddMeal(newMeal);
                },
                onAddAliment: (newAliment) {
                  onAddAliment(newAliment);
                },
                onDeleteALiment: (deletedAliment) {
                  onDeleteALiment(deletedAliment);
                },
                onDeleteMeal: (deletedMeal) {
                  onDeleteMeal(deletedMeal);
                },
                onModifyQuantity: (modifiedAliment) {
                  onModifyQuantity(modifiedAliment);
                },
              );
      },
    );
  }
}
