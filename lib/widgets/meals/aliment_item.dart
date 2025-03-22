import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/meals/delete_aliment_alert_dialog.dart';
import 'package:macro_meter/widgets/meals/edit_quantity_alert_dialog.dart';

class AlimentItem extends StatefulWidget {
  AlimentItem(
      {required this.aliment,
      required this.meal,
      required this.plan,
      required this.user,
      required this.onDeleteALiment,
      required this.onModifyQuantity,
      required this.isChecked,
      super.key});

  Aliment aliment;
  final User user;
  final Meal meal;
  final Plan plan;
  bool isChecked;
  final void Function(Aliment deletedAliment) onDeleteALiment;
  final void Function(Aliment modifiedAliment) onModifyQuantity;

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
        Container(
            // child: Row(
            //   children: [
            //     Text(
            //       widget.aliment.calories.toString(),
            //       textAlign: TextAlign.center,
            //     ),
            //     Checkbox(
            //       value: _isChecked,
            //       onChanged: (bool? value) {
            //         setState(() {
            //           _isChecked = !_isChecked;
            //         });
            //       },
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //   ],
            // ),
            ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            widget.aliment.calories.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Checkbox(
            value: widget.isChecked,
            onChanged: (bool? value) {
              setState(() {
                widget.isChecked = !widget.isChecked;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
