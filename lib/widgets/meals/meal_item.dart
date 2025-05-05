import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/widgets/meals/aliment_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/screens/aliment.dart';
import 'package:macro_meter/widgets/meals/delete_meal_alert_dialog.dart';

class MealItem extends StatefulWidget {
  MealItem(
      {required this.meal,
      required this.user,
      required this.plan,
      this.journal,
      this.fromPage,
      required this.onAddMeal,
      required this.onAddAliment,
      required this.onDeleteALiment,
      required this.onDeleteMeal,
      required this.onModifyQuantity,
      this.onCheckedMeal,
      this.onCheckedAliment,
      super.key});

  final Meal meal;
  final User user;
  final Plan plan;
  Journal? journal;
  final String? fromPage;
  final void Function(Meal newMeal) onAddMeal;
  final void Function(Aliment newAliment) onAddAliment;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Meal deletedMeal) onDeleteMeal;
  final void Function(Aliment modifiedAliment) onModifyQuantity;
  final void Function(bool checkedMeal)? onCheckedMeal;
  final void Function(bool checkedAliment)? onCheckedAliment;

  @override
  State<StatefulWidget> createState() {
    return _MealItemState();
  }
}

class _MealItemState extends State<MealItem> {
  bool _isEditingName = false;
  bool _isChecked = false;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.meal.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Permet d'ajouter un repas
  void addMeal() async {
    try {
      String refId;
      Timestamp createdAt = Timestamp.now();
      if (widget.journal != null) {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.journal!.plan.id)
            .collection("meals")
            .add({
          "name": widget.plan.meals.length.toString(),
          "createdAt": createdAt
        });
        refId = docRef.id;
      } else {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .add({
          "name": widget.plan.meals.length.toString(),
          "createdAt": createdAt
        });
        refId = docRef.id;
      }
      widget.onAddMeal(
        Meal(
          id: refId,
          name: "Meal ${widget.plan.meals.length.toString()}",
          createdAt: createdAt,
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
      String refId;

      if (widget.journal != null) {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.journal!.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .add({
          "name": addedAliment.name,
          "calories": addedAliment.calories,
          "proteines": addedAliment.proteines,
          "fat": addedAliment.fats,
          "carbs": addedAliment.carbs,
          "category": addedAliment.category.name,
          "unit": addedAliment.unit.name,
          "quantity": addedAliment.quantity,
          "isChecked": false
        });
        refId = docRef.id;
      } else {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .add({
          "name": addedAliment.name,
          "calories": addedAliment.calories,
          "proteines": addedAliment.proteines,
          "fat": addedAliment.fats,
          "carbs": addedAliment.carbs,
          "category": addedAliment.category.name,
          "unit": addedAliment.unit.name,
          "quantity": addedAliment.quantity,
          "isChecked": false
        });
        refId = docRef.id;
      }
      addedAliment.id = refId;
      widget.meal.aliments.add(addedAliment);
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
      if (widget.plan.meals.any((m) =>
          m.name.toUpperCase() == _controller.text.toUpperCase() &&
          m.id != widget.meal.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le repas existe déjà"),
          ),
        );
        return;
      }
      if (widget.journal != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .update({
          'name': _controller.text,
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .update({
          'name': _controller.text,
        });
      }
      widget.meal.name = _controller.text;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
  }

  void updateIsChecked() async {
    try {
      _isChecked = !_isChecked;
      for (Aliment aliment in widget.meal.aliments) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .doc(aliment.id)
            .update({"isChecked": _isChecked});
        aliment.isChecked = _isChecked;
      }
      widget.onCheckedMeal!(_isChecked);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
  }

  bool _isDiabled() {
    if (widget.fromPage == "PlanEdit") {
      return false;
    }
    if (widget.journal == null || widget.journal!.isComplete) {
      return true;
    }

    return false;
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
                                widget.meal.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                        IconButton(
                          onPressed: _isDiabled()
                              ? null
                              : () {
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
                            onPressed: _isDiabled()
                                ? null
                                : () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => DeleteMealAlertDialog(
                                        user: widget.user,
                                        meal: widget.meal,
                                        plan: widget.plan,
                                        journal: widget.journal,
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
                    child: widget.journal != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Cals",
                                style: TextStyle(fontSize: 16),
                              ),
                              Checkbox(
                                value: _isChecked,
                                onChanged: _isDiabled()
                                    ? null
                                    : (bool? value) {
                                        setState(() {
                                          updateIsChecked();
                                        });
                                      },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "Cals",
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 32, 12),
                    decoration: BoxDecoration(color: Colors.white),
                    child: widget.journal != null
                        ? AlimentList(
                            aliments: widget.meal.aliments,
                            user: widget.user,
                            plan: widget.plan,
                            meal: widget.meal,
                            journal: widget.journal,
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
                            onCheckedAliment: (checkedAliment) {
                              widget.onCheckedAliment!(checkedAliment);
                            },
                          )
                        : AlimentList(
                            aliments: widget.meal.aliments,
                            user: widget.user,
                            plan: widget.plan,
                            meal: widget.meal,
                            journal: widget.journal,
                            fromPage: widget.fromPage,
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
                          ),
                  ),
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
                              Text(widget.meal.totalProteines().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("Glu", style: TextStyle(fontSize: 16)),
                              Text(widget.meal.totalCarbs().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("Lip", style: TextStyle(fontSize: 16)),
                              Text(widget.meal.totalFats().toString(),
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Text("", style: TextStyle(fontSize: 16)),
                              Text(widget.meal.totalCalories().toString(),
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
                          onPressed: _isDiabled()
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => AlimentScreen(
                                        user: widget.user,
                                        fromPage: "PlanEdit",
                                        onAddAliment: (newAliment) {
                                          _addAliment(newAliment);
                                        },
                                        meal: widget.meal,
                                      ),
                                    ),
                                  );
                                },
                          child: Text("+ Ajouter aliment"))),
                ],
              ),
            ),
            if (widget.plan.meals.lastIndexOf(widget.meal) ==
                widget.plan.meals.length - 1) ...[
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
