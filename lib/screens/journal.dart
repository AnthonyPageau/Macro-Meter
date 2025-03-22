import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:macro_meter/main.dart';
import 'package:macro_meter/models/plan.dart';
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
  Plan? plan;

  String dateDisplayed = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
              if (plan == null) ...[
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
                                  setState(() {
                                    plan = choosePlan;
                                  });
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
                    meals: plan!.meals,
                    user: widget.user,
                    plan: plan!,
                    onAddMeal: (newMeal) {
                      setState(() {
                        plan!.meals.add(newMeal);
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
                        plan!.meals.remove(deletedMeal);
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
        ));
  }
}
