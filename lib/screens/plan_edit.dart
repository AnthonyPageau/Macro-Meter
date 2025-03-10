import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/widgets/meals/meal_list.dart';

class PlanEdit extends StatefulWidget {
  PlanEdit({required this.plan, required this.user, super.key});
  Plan plan;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _PlanEditState();
  }
}

class _PlanEditState extends State<PlanEdit> {
  Meal meal = Meal(id: "test", name: "salut");
  List<Meal> meals = [];

  @override
  void initState() {
    super.initState();

    meals.add(meal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.plan.name,
          style: TextStyle(fontSize: 36),
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 56),
            child: Text(
              widget.plan.name,
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
      ),
      body: Column(
        children: [Expanded(child: MealList(meals: meals, user: widget.user))],
      ),
    );
  }
}
