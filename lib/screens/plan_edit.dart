import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/widgets/meals/meal_list.dart';
import 'package:macro_meter/main.dart';

class PlanEdit extends StatefulWidget {
  const PlanEdit(
      {required this.plan, required this.user, required this.plans, super.key});
  final Plan plan;
  final List<Plan> plans;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _PlanEditState();
  }
}

class _PlanEditState extends State<PlanEdit> {
  bool _isEditingName = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.plan.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Permet d'ajouter un repas
  void addMeal() async {
    try {
      Timestamp createdAt = Timestamp.now();

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

      widget.plan.meals.add(
        Meal(
            id: docRef.id,
            name: "Meal ${widget.plan.meals.length.toString()}",
            createdAt: createdAt),
      );
      setState(() {});
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
  }

  void _updatePlanName() {
    try {
      if (widget.plans.any((p) =>
          p.name.toUpperCase() == _controller.text.toUpperCase() &&
          p.id != widget.plan.id)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le plan existe déjà"),
          ),
        );
        return;
      }
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .collection("plans")
          .doc(widget.plan.id)
          .update({
        'name': _controller.text,
      });
      widget.plan.name = _controller.text;
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isEditingName
                  ? Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(
                            fontSize: 36, color: kColorScheme.primaryContainer),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    )
                  : Text(
                      widget.plan.name,
                      style: TextStyle(fontSize: 36),
                    ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (_isEditingName) {
                      _updatePlanName();
                    }
                    _isEditingName = !_isEditingName;
                  });
                },
                icon: Icon(
                  _isEditingName ? Icons.save : Icons.edit,
                  color: kColorScheme.primaryContainer,
                  size: 36,
                ),
              )
            ],
          )),
      body: Container(
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
            Flexible(
              child: MealList(
                meals: widget.plan.meals,
                user: widget.user,
                plan: widget.plan,
                fromPage: "PlanEdit",
                onAddMeal: (newMeal) {
                  setState(() {
                    widget.plan.meals.add(newMeal);
                  });
                },
                onAddAliment: (newAliment) {
                  setState(() {});
                },
                onDeleteALiment: (deletedAliment) {
                  setState(() {});
                },
                onDeleteMeal: (deletedMeal) {
                  setState(() {
                    widget.plan.meals.remove(deletedMeal);
                  });
                },
                onModifyQuantity: (modifiedAliment) {
                  setState(() {});
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(""),
                  Text("Total",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("Prot",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text(widget.plan.totalProteines().toString(),
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Glu",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    widget.plan.totalCarbs().toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Lip",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    widget.plan.totalFats().toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    "Cal",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    widget.plan.totalCalories().toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
