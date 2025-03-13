import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/meals/aliment_item.dart';

class AlimentList extends StatefulWidget {
  const AlimentList(
      {super.key,
      required this.aliments,
      required this.user,
      required this.meal,
      required this.plan,
      required this.onDeleteALiment});

  final List<Aliment> aliments;
  final User user;
  final Meal meal;
  final Plan plan;
  final void Function(Aliment deletedAliment) onDeleteALiment;

  @override
  State<StatefulWidget> createState() {
    return _AlimentListState();
  }
}

class _AlimentListState extends State<AlimentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.aliments.length,
      itemBuilder: (context, index) {
        return AlimentItem(
          aliment: widget.aliments[index],
          user: widget.user,
          meal: widget.meal,
          plan: widget.plan,
          onDeleteALiment: (deletedAliment) {
            widget.onDeleteALiment(deletedAliment);
          },
        );
      },
    );
  }
}
