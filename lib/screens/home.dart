import 'package:flutter/material.dart';
import 'package:macro_meter/widgets/menu.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text("Macro-Meter", style: TextStyle(fontSize: 40))),
      ),
      drawer: const Menu(),
      body: const Center(
        child: Text("Logged in!"),
      ),
    );
  }
}
