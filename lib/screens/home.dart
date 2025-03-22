import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/screens/account.dart';
import 'package:macro_meter/screens/aliment.dart';
import 'package:macro_meter/screens/journal.dart';
import 'package:macro_meter/screens/plans.dart';
import 'package:macro_meter/widgets/menu.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
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
            ),
          ),
        );
      case "Journal":
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => JournalScreen(),
          ),
        );
      default:
        Navigator.of(context).pop();
    }
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
        child: const Center(
          child: Text(
            "Connecté!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
