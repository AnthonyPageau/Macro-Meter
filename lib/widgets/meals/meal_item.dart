import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/aliment_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealItem extends StatefulWidget {
  const MealItem(
      {required this.meal,
      required this.user,
      required this.plan,
      required this.onAddMeal,
      super.key});

  final Meal meal;
  final User user;
  final Plan plan;
  final void Function(Meal newMeal) onAddMeal;

  @override
  State<StatefulWidget> createState() {
    return _MealItemState();
  }
}

class _MealItemState extends State<MealItem> {
  late Meal meal;
  late Plan plan;

  @override
  void initState() {
    super.initState();
    meal = widget.meal;
    plan = widget.plan;
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

      widget.onAddMeal(
        Meal(
          id: docRef.id,
          name: "Meal ${widget.plan.meals.length.toString()}",
        ),
      );
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
    return Material(
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 36, 12),
                  decoration: BoxDecoration(color: Colors.grey),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Cals",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 48, 12),
                    decoration: BoxDecoration(color: Colors.white),
                    child: AlimentList(
                        aliments: meal.aliments, user: widget.user)),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 48, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(""),
                          Text("Total", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Prot", style: TextStyle(fontSize: 16)),
                          Text(meal.totalProteines().toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Glu", style: TextStyle(fontSize: 16)),
                          Text(meal.totalCarbs().toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Lip", style: TextStyle(fontSize: 16)),
                          Text(meal.totalFats().toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("", style: TextStyle(fontSize: 16)),
                          Text(meal.totalCalories().toString(),
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {}, child: Text("+ Ajouter aliment"))),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 14),
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                  onPressed: () {
                    addMeal();
                  },
                  child: const Text("Ajouter Repas")))
        ],
      ),
    );
  }
}
