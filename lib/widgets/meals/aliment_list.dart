import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/meals/aliment_item.dart';

class AlimentList extends StatefulWidget {
  const AlimentList(
      {super.key,
      required this.aliments,
      required this.user,
      required this.meal,
      required this.plan,
      this.journal,
      this.fromPage,
      required this.onDeleteALiment,
      required this.onModifyQuantity,
      this.onCheckedAliment});

  final List<Aliment> aliments;
  final User user;
  final Meal meal;
  final Plan plan;
  final Journal? journal;
  final String? fromPage;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Aliment modifiedAliment) onModifyQuantity;
  final void Function(bool checkedAliment)? onCheckedAliment;

  @override
  State<StatefulWidget> createState() => _AlimentListState();
}

class _AlimentListState extends State<AlimentList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.aliments.length,
      itemBuilder: (context, index) {
        return widget.journal != null
            ? AlimentItem(
                aliment: widget.aliments[index],
                user: widget.user,
                meal: widget.meal,
                plan: widget.plan,
                journal: widget.journal,
                onDeleteALiment: (deletedAliment) {
                  widget.onDeleteALiment(deletedAliment);
                },
                onModifyQuantity: (modifiedAliment) {
                  widget.onModifyQuantity(modifiedAliment);
                },
                onCheckedAliment: (checkedAliment) {
                  widget.onCheckedAliment!(checkedAliment);
                },
              )
            : AlimentItem(
                aliment: widget.aliments[index],
                user: widget.user,
                meal: widget.meal,
                plan: widget.plan,
                journal: widget.journal,
                fromPage: widget.fromPage,
                onDeleteALiment: (deletedAliment) {
                  widget.onDeleteALiment(deletedAliment);
                },
                onModifyQuantity: (modifiedAliment) {
                  widget.onModifyQuantity(modifiedAliment);
                },
              );
      },
    );
  }
}
