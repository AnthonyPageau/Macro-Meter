import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/screens/account.dart';
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
      default:
        Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text("Macro-Meter", style: TextStyle(fontSize: 36))),
      ),
      drawer: Menu(
        onSelectScreen: _setScreen,
      ),
      body: const Center(
        child: Text("Logged in!"),
      ),
    );
  }
}
