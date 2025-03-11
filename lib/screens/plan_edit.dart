import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/widgets/meals/meal_list.dart';
import 'package:macro_meter/widgets/plans/plan_edit_footer.dart';

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
  @override
  void initState() {
    super.initState();
  }

  void addMeal() async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection("plans")
          .doc(widget.plan.id)
          .collection("meals")
          .add({
        "name": widget.plan.meals.length.toString(),
      });

      widget.plan.meals.add(
        Meal(
          id: docRef.id,
          name: "Meal ${widget.plan.meals.length.toString()}",
        ),
      );
      setState(() {});
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
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
        children: [
          if (widget.plan.meals.isEmpty) ...[
            Container(
              padding: EdgeInsets.only(left: 14),
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  addMeal();
                },
                child: const Text("Ajouter Repas"),
              ),
            )
          ],
          Expanded(
            child: MealList(
              meals: widget.plan.meals,
              user: widget.user,
              plan: widget.plan,
              onAddMeal: (newMeal) {
                setState(() {
                  widget.plan.meals.add(newMeal);
                });
              },
            ),
          )
        ],
      ),
      bottomSheet: PlanEditFooter(),
    );
  }
}
