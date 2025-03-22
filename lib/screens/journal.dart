import 'package:flutter/material.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JournalScreenState();
  }
}

class _JournalScreenState extends State<JournalScreen> {
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
    );
  }
}
