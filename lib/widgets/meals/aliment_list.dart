import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/aliment_item.dart';

class AlimentList extends StatefulWidget {
  const AlimentList({super.key, required this.aliments, required this.user});

  final List<Aliment> aliments;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _AlimentListState();
  }
}

class _AlimentListState extends State<AlimentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.aliments.length,
      itemBuilder: (context, index) {
        return AlimentItem(aliment: widget.aliments[index], user: widget.user);
      },
    );
  }
}
