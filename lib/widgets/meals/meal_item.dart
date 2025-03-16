import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/aliment_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/screens/aliment.dart';
import 'package:macro_meter/widgets/meals/delete_meal_alert_dialog.dart';

class MealItem extends StatefulWidget {
  const MealItem(
      {required this.meal,
      required this.user,
      required this.plan,
      required this.onAddMeal,
      required this.onAddAliment,
      required this.onDeleteALiment,
      required this.onDeleteMeal,
      required this.onModifyQuantity,
      super.key});

  final Meal meal;
  final User user;
  final Plan plan;
  final void Function(Meal newMeal) onAddMeal;
  final void Function(Aliment newAliment) onAddAliment;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Meal deletedMeal) onDeleteMeal;
  final void Function(Aliment modifiedAliment) onModifyQuantity;

  @override
  State<StatefulWidget> createState() {
    return _MealItemState();
  }
}

class _MealItemState extends State<MealItem> {
  late Meal meal;
  late Plan plan;
  bool _isEditingName = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    meal = widget.meal;
    plan = widget.plan;
    _controller = TextEditingController(text: widget.meal.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void _addAliment(Aliment addedAliment) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("plans")
          .doc(plan.id)
          .collection("meals")
          .doc(meal.id)
          .collection("aliments")
          .add({
        "name": addedAliment.name,
        "calories": addedAliment.calories,
        "proteines": addedAliment.proteines,
        "fat": addedAliment.fat,
        "carbs": addedAliment.carbs,
        "category": addedAliment.category.name,
        "unit": addedAliment.unit.name,
        "quantity": addedAliment.quantity
      });
      addedAliment.id = docRef.id;
      meal.aliments.add(addedAliment);
      setState(() {});
      widget.onAddAliment(addedAliment);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
  }

  void _updateMealName() {
    try {
      if (plan.meals.any((m) =>
          m.name.toUpperCase() == _controller.text.toUpperCase() &&
          m.id != meal.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le repas existe déjà"),
          ),
        );
        return;
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection("plans")
          .doc(widget.plan.id)
          .collection("meals")
          .doc(meal.id)
          .update({
        'name': _controller.text,
      });
      meal.name = _controller.text;
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 17, 127, 112),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
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
                        _isEditingName
                            ? Expanded(
                                child: TextField(
                                  controller: _controller,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                  ),
                                ),
                              )
                            : Text(
                                meal.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_isEditingName) {
                                _updateMealName();
                              }
                              _isEditingName = !_isEditingName;
                            });
                          },
                          icon: Icon(
                            _isEditingName ? Icons.save : Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => DeleteMealAlertDialog(
                                  user: widget.user,
                                  meal: widget.meal,
                                  plan: widget.plan,
                                  onDeleteMeal: (deletedMeal) {
                                    widget.onDeleteMeal(deletedMeal);
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
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
                      padding: EdgeInsets.fromLTRB(12, 12, 32, 12),
                      decoration: BoxDecoration(color: Colors.white),
                      child: AlimentList(
                        aliments: meal.aliments,
                        user: widget.user,
                        plan: widget.plan,
                        meal: widget.meal,
                        onDeleteALiment: (deletedAliment) {
                          setState(() {
                            widget.onDeleteALiment(deletedAliment);
                            widget.meal.aliments.remove(deletedAliment);
                          });
                        },
                        onModifyQuantity: (modifiedAliment) {
                          setState(() {
                            widget.onModifyQuantity(modifiedAliment);
                          });
                        },
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 0, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(""),
                              Text("Total", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("Prot", style: TextStyle(fontSize: 16)),
                              Text(meal.totalProteines().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("Glu", style: TextStyle(fontSize: 16)),
                              Text(meal.totalCarbs().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("Lip", style: TextStyle(fontSize: 16)),
                              Text(meal.totalFats().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("", style: TextStyle(fontSize: 16)),
                              Text(meal.totalCalories().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
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
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => AlimentScreen(
                                  user: widget.user,
                                  fromPage: "PlanEdit",
                                  onAddAliment: (newAliment) {
                                    _addAliment(newAliment);
                                  },
                                  meal: meal,
                                ),
                              ),
                            );
                          },
                          child: Text("+ Ajouter aliment"))),
                ],
              ),
            ),
            if (plan.meals.lastIndexOf(meal) == plan.meals.length - 1) ...[
              Container(
                padding: EdgeInsets.only(left: 14),
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    addMeal();
                  },
                  child: const Text("Ajouter Repas"),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
