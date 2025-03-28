import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/meals/delete_aliment_alert_dialog.dart';
import 'package:macro_meter/widgets/meals/edit_quantity_alert_dialog.dart';

class AlimentItem extends StatefulWidget {
  AlimentItem(
      {required this.aliment,
      required this.meal,
      required this.plan,
      required this.user,
      this.journal,
      required this.onDeleteALiment,
      required this.onModifyQuantity,
      this.onCheckedAliment,
      super.key});

  Aliment aliment;
  final User user;
  final Meal meal;
  final Plan plan;
  final Journal? journal;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Aliment modifiedAliment) onModifyQuantity;
  final void Function(bool checkedAliment)? onCheckedAliment;

  @override
  State<StatefulWidget> createState() {
    return _AlimentItemState();
  }
}

class _AlimentItemState extends State<AlimentItem> {
  void updateIsChecked() async {
    try {
      bool isChecked = !widget.aliment.isChecked;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("journals")
          .doc(widget.journal!.id)
          .collection("plan")
          .doc(widget.plan.id)
          .collection("meals")
          .doc(widget.meal.id)
          .collection("aliments")
          .doc(widget.aliment.id)
          .update({"isChecked": isChecked});
      widget.aliment.isChecked = isChecked;
      widget.onCheckedAliment!(isChecked);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            widget.aliment.name,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => DeleteAlimentAlertDialog(
                user: widget.user,
                aliment: widget.aliment,
                meal: widget.meal,
                plan: widget.plan,
                journal: widget.journal,
                onDeleteALiment: (deletedAliment) {
                  widget.onDeleteALiment(deletedAliment);
                },
              ),
            );
          },
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
                    showDialog(
                      context: context,
                      builder: (ctx) => EditQuantityAlertDialog(
                        aliment: widget.aliment,
                        user: widget.user,
                        meal: widget.meal,
                        plan: widget.plan,
                        journal: widget.journal,
                        onModifyQuantity: (aliment) {
                          setState(() {
                            widget.aliment = aliment;
                            widget.onModifyQuantity(aliment);
                          });
                        },
                      ),
                    );
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
        const SizedBox(
          width: 20,
        ),
        Text(
          widget.aliment.calories.toString(),
          textAlign: TextAlign.center,
        ),
        if (widget.journal != null) ...[
          Checkbox(
            value: widget.aliment.isChecked,
            onChanged: (bool? value) {
              setState(() {
                updateIsChecked();
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ]
      ],
    );
  }
}
