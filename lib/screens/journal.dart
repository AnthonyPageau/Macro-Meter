import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:macro_meter/main.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/screens/plans.dart';
import 'package:macro_meter/widgets/meals/meal_list.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({required this.user, super.key});

  final User user;
  @override
  State<StatefulWidget> createState() {
    return _JournalScreenState();
  }
}

class _JournalScreenState extends State<JournalScreen> {
  dynamic date = DateTime.now();
  DateTime? selectedDate;
  Journal? journal;
  Plan? plan;
  String dateDisplayed = DateFormat('yyyy-MM-dd').format(DateTime.now());

  void fetchUserJournalData() async {
    var journalsCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("journals")
        .get();

    List<Journal> journalList =
        await Future.wait(journalsCollection.docs.map((journalDoc) async {
      var journalData = journalDoc.data();

      var mealsList = List<Meal>.from(
        journalData['meals'].map((mealData) {
          var alimentsList = List<Aliment>.from(
            mealData['aliments'].map((alimentData) {
              return Aliment(
                id: alimentData['id'],
                name: alimentData['name'],
                calories: alimentData['calories'],
                proteines: alimentData['proteines'],
                carbs: alimentData['carbs'],
                fats: alimentData['fats'],
                unit: AlimentUnit.values.byName(alimentData['unit']),
                quantity: alimentData['quantity'],
                category:
                    AlimentCategory.values.byName(alimentData['category']),
              );
            }),
          );

          return Meal(
            id: mealData['id'],
            name: mealData['name'],
            aliments: alimentsList,
          );
        }),
      );

      return Journal(
        id: journalDoc.id,
        plan: journalData['planId'],
        date: DateTime.parse(journalData['date']),
      );
    }));
  }

  void _createJournal(Plan plan) async {
    Plan journalPlan;
    List<Meal> meals = [];
    DocumentReference journalRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("journals")
        .add({"date": date.toString()});

    DocumentReference planRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("journals")
        .doc(journalRef.id)
        .collection("plan")
        .add({"name": plan.name, "date": date.toString()});
    journalPlan = Plan(id: planRef.id, name: plan.name, date: date);
    for (Meal meal in plan.meals) {
      List<Aliment> aliments = [];
      DocumentReference mealRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("journals")
          .doc(journalRef.id)
          .collection("plan")
          .doc(planRef.id)
          .collection("meals")
          .add({"name": meal.name});
      meals.add(Meal(id: mealRef.id, name: meal.name, aliments: aliments));
      for (Aliment aliment in meal.aliments) {
        DocumentReference alimentRef = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(journalRef.id)
            .collection("plan")
            .doc(planRef.id)
            .collection("meals")
            .doc(mealRef.id)
            .collection("aliments")
            .add({
          "name": aliment.name,
          "calories": aliment.calories,
          "proteines": aliment.proteines,
          "fat": aliment.fats,
          "carbs": aliment.carbs,
          "category": aliment.category.name,
          "unit": aliment.unit.name,
          "quantity": aliment.quantity
        });
        aliments.add(Aliment(
            id: alimentRef.id,
            name: aliment.name,
            calories: aliment.calories,
            proteines: aliment.proteines,
            fats: aliment.fats,
            carbs: aliment.carbs,
            category: aliment.category,
            unit: aliment.unit,
            quantity: aliment.quantity));
      }
    }
    journalPlan.meals = meals;
    journal = Journal(id: journalRef.id, date: date, plan: journalPlan);
    setState(() {});
  }

  void displayDate(DateTime newDate) {
    if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      dateDisplayed = "Aujourd'hui";
    } else if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 1)))) {
      dateDisplayed = "Hier";
    } else if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1)))) {
      dateDisplayed = "Demain";
    } else {
      dateDisplayed = DateFormat('yyyy-MM-dd').format(newDate);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    setState(() {
      if (pickedDate != null) {
        date = pickedDate;
        displayDate(pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Journal",
          style: TextStyle(fontSize: 36),
        ),
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
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.black),
              height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            date = date.subtract(const Duration(days: 1));
                            displayDate(date);
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _selectDate();
                        },
                        child: Text(
                          dateDisplayed,
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            date = date.add(const Duration(days: 1));
                            displayDate(date);
                          });
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            if (journal == null) ...[
              Column(
                children: [
                  Icon(
                    Icons.food_bank_outlined,
                    color: kColorScheme.primaryContainer,
                    size: 80,
                  ),
                  Text(
                    "Vous n'avez pas encore enregistrer\nde nourrite pour cette journée",
                    style: TextStyle(
                        color: kColorScheme.primaryContainer, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => PlanScreen(
                              user: widget.user,
                              fromPage: "Journal",
                              onChoosePlan: (choosePlan) {
                                _createJournal(choosePlan);
                                plan = choosePlan;
                              },
                            ),
                          ),
                        );
                      },
                      child: Text("Choisir plan"))
                ],
              ),
            ] else ...[
              Flexible(
                child: MealList(
                  meals: journal!.plan.meals,
                  user: widget.user,
                  plan: journal!.plan,
                  journal: journal,
                  onAddMeal: (newMeal) {
                    setState(() {
                      journal!.plan.meals.add(newMeal);
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
                      journal!.plan.meals.remove(deletedMeal);
                    });
                  },
                  onModifyQuantity: (modifiedAliment) {
                    setState(() {});
                  },
                ),
              )
            ]
          ],
        ),
      ),
      bottomNavigationBar: journal != null
          ? BottomAppBar(
              height: 130,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        SizedBox(height: 21),
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          "But",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Restant",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
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
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalCalories().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          plan!.totalCalories().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalCalories().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text("Prot",
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text(plan!.totalProteines().toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Divider(color: Colors.white, thickness: 1),
                        Text(plan!.totalProteines().toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text(plan!.totalProteines().toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          "Glu",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalCarbs().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          plan!.totalCarbs().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalCarbs().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
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
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalFats().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          plan!.totalFats().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          plan!.totalFats().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
