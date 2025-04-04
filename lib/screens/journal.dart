import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:macro_meter/main.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/screens/plans.dart';
import 'package:macro_meter/widgets/meals/meal_list.dart';
import 'package:macro_meter/widgets/journal/complete_journal_alert_dialog.dart';

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
  List<Meal>? meals;
  List<Journal> journals = [];
  String dateDisplayed = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final AudioPlayer _audioPlayer = AudioPlayer();

  void fetchUserJournalData() async {
    var journalsCollection = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("journals")
        .get();

    List<Journal> journalList =
        await Future.wait(journalsCollection.docs.map((journalDoc) async {
      var journalData = journalDoc.data();
      var planCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("journals")
          .doc(journalDoc.id)
          .collection("plan")
          .get();
      var planDoc = planCollection.docs[0];
      var planData = planDoc.data();
      var mealsCollection = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("journals")
          .doc(journalDoc.id)
          .collection("plan")
          .doc(planDoc.id)
          .collection("meals")
          .orderBy("createdAt", descending: false)
          .get();

      List<Meal> mealList =
          await Future.wait(mealsCollection.docs.map((mealDoc) async {
        var mealData = mealDoc.data();
        var alimentCollection = await FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(journalDoc.id)
            .collection("plan")
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
            fats: alimentData["fat"],
            unit: AlimentUnit.values.byName(alimentData["unit"]),
            quantity: alimentData["quantity"],
            category: AlimentCategory.values.byName(
              alimentData["category"],
            ),
            isChecked: alimentData["isChecked"],
          );
        }).toList();

        return Meal(
            id: mealDoc.id,
            name: mealData["name"],
            createdAt: mealData["createdAt"],
            aliments: alimentList);
      }).toList());
      Plan plan = Plan(
          id: planDoc.id,
          name: planData["name"],
          date: DateTime.parse(planData["date"] as String),
          meals: mealList);
      return Journal(
        id: journalDoc.id,
        plan: plan,
        date: DateTime.parse(journalData['date'] as String),
        targetCalories: journalData["targetCalories"],
        targetProteines: journalData["targetProteines"],
        targetCarbs: journalData["targetCarbs"],
        targetFats: journalData["targetFats"],
        isComplete: journalData["isComplete"],
      );
    }).toList());
    if (journalList.isNotEmpty) {
      journals = journalList;
      findJournal(DateTime.now());
    }
  }

  void _createJournal(Plan plan) async {
    Plan journalPlan;
    List<Meal> meals = [];
    DocumentReference journalRef = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("journals")
        .add({
      "date": date.toString(),
      "targetCalories": plan.totalCalories(),
      "targetProteines": plan.totalProteines(),
      "targetFats": plan.totalFats(),
      "targetCarbs": plan.totalCarbs(),
      "isComplete": false
    });

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
          .add({"name": meal.name, "createdAt": meal.createdAt});
      meals.add(Meal(
          id: mealRef.id,
          name: meal.name,
          createdAt: meal.createdAt,
          aliments: aliments));
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
          "quantity": aliment.quantity,
          "isChecked": false
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
            quantity: aliment.quantity,
            isChecked: aliment.isChecked));
      }
    }
    journalPlan.meals = meals;
    journal = Journal(
        id: journalRef.id,
        date: date,
        plan: journalPlan,
        targetCalories: plan.totalCalories(),
        targetProteines: plan.totalProteines(),
        targetCarbs: plan.totalCarbs(),
        targetFats: plan.totalCarbs(),
        isComplete: false);
    journals.add(journal!);
    meals = journalPlan.meals;
    setState(() {});
  }

  void _onArrowClick(bool isNext) {
    setState(() {
      if (isNext) {
        date = date.add(const Duration(days: 1));
      } else {
        date = date.subtract(const Duration(days: 1));
      }
      displayDate(date);
      findJournal(date);
    });
  }

  void findJournal(DateTime date) {
    DateTime todayStartOfDay = DateTime(date.year, date.month, date.day);
    bool found = false;
    Journal? foundJournal;

    int index = 0;
    while (!found && index < journals.length) {
      var j = journals[index];
      DateTime journalDate = DateTime(j.date.year, j.date.month, j.date.day);

      if (journalDate.isAtSameMomentAs(todayStartOfDay)) {
        found = true;
        foundJournal = j;
      }
      index++;
    }

    setState(() {
      journal = found ? foundJournal : null;
      meals = found ? foundJournal!.plan.meals : null;
    });
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
      initialDate: date,
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    setState(() {
      if (pickedDate != null) {
        date = pickedDate;
        displayDate(pickedDate);
        findJournal(date);
      }
    });
  }

  void _playSound() {
    _audioPlayer.play(AssetSource("sounds/complete_sound.mp3"));
  }

  bool _isDiabled() {
    if (journal == null || journal!.isComplete) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchUserJournalData();
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
                          _onArrowClick(false);
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
                          _onArrowClick(true);
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
                      onPressed: _isDiabled()
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (ctx) => CompleteJournalAlertDialog(
                                  user: widget.user,
                                  journal: journal!,
                                  onCompleteJournal: (journal) {
                                    setState(() {});
                                    _playSound();
                                  },
                                ),
                              );
                            },
                      icon: _isDiabled()
                          ? Icon(
                              Icons.check_box_outlined,
                              color: kColorScheme.primaryContainer,
                              size: 30,
                            )
                          : Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            )),
                ],
              ),
            ),
            Flexible(
              child: journal != null
                  ? MealList(
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
                      onCheckedMeal: (checkedMeal) {
                        setState(() {});
                      },
                      onCheckedAliment: (checkedAliment) {
                        setState(() {});
                      },
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.food_bank_outlined,
                          color: kColorScheme.primaryContainer,
                          size: 80,
                        ),
                        Text(
                          "Vous n'avez pas encore enregistrer\nde nourrite pour cette journée",
                          style: TextStyle(
                              color: kColorScheme.primaryContainer,
                              fontSize: 20),
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
            )
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
                          journal!.totalCalories().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          journal!.targetCalories.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          journal!.remaningCalories().toString(),
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
                        Text(journal!.totalProteines().toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Divider(color: Colors.white, thickness: 1),
                        Text(journal!.targetProteines.toString(),
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text(journal!.remaningProteines().toString(),
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
                          journal!.totalCarbs().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          journal!.targetCarbs.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          journal!.remaningCarbs().toString(),
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
                          journal!.totalFats().toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Divider(color: Colors.white, thickness: 1),
                        Text(
                          journal!.targetFats.toString(),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          journal!.remaningFats().toString(),
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
