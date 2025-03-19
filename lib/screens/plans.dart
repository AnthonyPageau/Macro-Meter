import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/widgets/plans/plan_create.dart';
import 'package:macro_meter/widgets/plans/plan_list.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({required this.user, super.key});

  final User user;
  @override
  State<StatefulWidget> createState() {
    return _PlanScreenState();
  }
}

class _PlanScreenState extends State<PlanScreen> {
  dynamic plans;

  @override
  void initState() {
    super.initState();
    fetchUserPlanData();
  }

  void fetchUserPlanData() async {
    var plansCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("plans")
        .get();

    List<Plan> planList =
        await Future.wait(plansCollection.docs.map((planDoc) async {
      var planData = planDoc.data();
      var mealsCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("plans")
          .doc(planDoc.id)
          .collection("meals")
          .get();

      List<Meal> mealList =
          await Future.wait(mealsCollection.docs.map((mealDoc) async {
        var mealData = mealDoc.data();
        var alimentCollection = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(planDoc.id)
            .collection("meals")
            .doc(mealDoc.id)
            .collection("aliments")
            .get();

        List<Aliment> alimentList = alimentCollection.docs.map((alimentDoc) {
          var alimentData = alimentDoc.data();
          return Aliment(
            id: alimentDoc.id,
            name: alimentData["name"],
            calories: alimentData["calories"],
            proteines: alimentData["proteines"],
            carbs: alimentData["carbs"],
            fat: alimentData["fat"],
            unit: Unit.values.byName(alimentData["unit"]),
            quantity: alimentData["quantity"],
            category: Category.values.byName(
              alimentData["category"],
            ),
          );
        }).toList();

        return Meal(
            id: mealDoc.id, name: mealData["name"], aliments: alimentList);
      }).toList());

      return Plan(
          id: planDoc.id,
          name: planData["name"],
          date: DateTime.parse(planData["date"] as String),
          meals: mealList);
    }).toList());

    setState(() {
      plans = planList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Plans",
          style: TextStyle(fontSize: 36),
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 56),
            child: const Text(
              "Plans",
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => PlanCreate(
                    user: widget.user,
                    onAddPlan: (newPlan) {
                      setState(() {
                        plans.add(newPlan);
                      });
                    },
                    plans: plans),
              );
            },
            icon: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
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
        child: plans == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(child: PlanList(plans: plans, user: widget.user))
                ],
              ),
      ),
    );
  }
}
