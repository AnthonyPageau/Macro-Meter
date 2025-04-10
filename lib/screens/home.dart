import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/screens/account.dart';
import 'package:macro_meter/screens/aliment.dart';
import 'package:macro_meter/screens/journal.dart';
import 'package:macro_meter/screens/plans.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:macro_meter/widgets/menu.dart';
import 'package:macro_meter/widgets/statistique/aliment_category_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<Journal> journals = [];
  void _setScreen(String identifier) {
    switch (identifier) {
      case "Compte":
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => Account(
              user: widget.user,
            ),
          ),
        );
        break;
      case "Aliment":
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AlimentScreen(
              user: widget.user,
              fromPage: "Home",
            ),
          ),
        );
      case "Plans":
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => PlanScreen(
              user: widget.user,
              fromPage: "Home",
            ),
          ),
        );
      case "Journal":
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (ctx) =>
                JournalScreen(user: widget.user, journals: journals),
          ),
        )
            .then((_) {
          fetchUserJournalData();
        });
      default:
        Navigator.of(context).pop();
    }
  }

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
      setState(() {
        journals = journalList;
      });
    }
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
        title: const Text(
          "Macro-Meter",
          style: TextStyle(fontSize: 36),
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 56),
            child: const Text(
              "Macro-Meter",
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
      ),
      drawer: Menu(
        onSelectScreen: _setScreen,
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
          child: journals.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : AlimentCategoryChart(journals: journals)),
    );
  }
}
