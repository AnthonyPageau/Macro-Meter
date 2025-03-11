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
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            widget.aliment.name,
            textAlign: TextAlign.center, // Ensures it aligns in the middle
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete_forever_outlined),
          iconSize: 30,
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          width: 110.0,
          height: 30.0,
          decoration: BoxDecoration(color: Colors.grey),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: InkWell(
                  onTap: () {
                    print('salut');
                  },
                  child: Center(
                    child: Text(
                      widget.aliment.quantity.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  widget.aliment.unitToString(widget.aliment.unit),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 84, 84, 84),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            widget.aliment.calories.toString(),
            textAlign: TextAlign.center, // Ensures it aligns in the middle
          ),
        ),
      ],
    );
  }
}
