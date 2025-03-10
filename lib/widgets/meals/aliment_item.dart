import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlimentItem extends StatefulWidget {
  const AlimentItem({required this.aliment, required this.user, super.key});

  final Aliment aliment;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _AlimentItemState();
  }
}

class _AlimentItemState extends State<AlimentItem> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(widget.aliment.name),
      const Spacer(),
      IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever_outlined)),
      Container(
        width: 50.0,
        height: 30.0,
        decoration: BoxDecoration(color: Colors.grey),
        child: TextFormField(),
      ),
      const Spacer(),
      Text(widget.aliment.calories.toString())
    ]);
  }
}
