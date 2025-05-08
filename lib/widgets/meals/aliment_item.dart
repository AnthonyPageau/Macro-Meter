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
  const AlimentItem({
    required this.aliment,
    required this.meal,
    required this.plan,
    required this.user,
    this.journal,
    this.fromPage,
    required this.onDeleteALiment,
    required this.onModifyQuantity,
    this.onCheckedAliment,
    super.key,
  });

  final Aliment aliment;
  final User user;
  final Meal meal;
  final Plan plan;
  final Journal? journal;
  final String? fromPage;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Aliment modifiedAliment) onModifyQuantity;
  final void Function(bool checkedAliment)? onCheckedAliment;

  @override
  State<AlimentItem> createState() => _AlimentItemState();
}

class _AlimentItemState extends State<AlimentItem> {
  late Aliment _aliment;

  @override
  void initState() {
    super.initState();
    _aliment = widget.aliment;
  }

  /// Permet de cocher les aliments d'un repas
  void updateIsChecked() async {
    try {
      bool isChecked = !_aliment.isChecked;
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
          .doc(_aliment.id)
          .update({"isChecked": isChecked});

      setState(() {
        _aliment.isChecked = isChecked;
      });

      widget.onCheckedAliment?.call(isChecked);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.code)),
      );
    }
  }

  /// Permet de désactivé les fonctionnalités de la page
  bool _isDiabled() {
    if (widget.fromPage == "PlanEdit") {
      return false;
    }
    if (widget.journal == null || widget.journal!.isComplete) {
      return true;
    }

    return false;
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
          onPressed: _isDiabled()
              ? null
              : () {
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
                  onTap: _isDiabled()
                      ? null
                      : () {
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
                                  _aliment = aliment;
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
            onChanged: _isDiabled()
                ? null
                : (bool? value) {
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
