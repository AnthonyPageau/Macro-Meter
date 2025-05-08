import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class AlimentModify extends StatefulWidget {
  const AlimentModify(
      {required this.user,
      required this.aliment,
      required this.onModifyAliment,
      required this.aliments,
      super.key});

  final User user;
  final Aliment aliment;
  final List<Aliment> aliments;
  final void Function(Aliment modifiedAliment) onModifyAliment;

  @override
  State<StatefulWidget> createState() {
    return _AlimentModifyState();
  }
}

class _AlimentModifyState extends State<AlimentModify> {
  AlimentCategory? categoryValue;
  AlimentUnit? unitValue;
  Aliment? newAliment;

  final form = GlobalKey<FormState>();

  /// Permet de modifier un aliment
  void _submit() async {
    try {
      final isValid = form.currentState!.validate();

      if (!isValid) {
        return;
      }

      form.currentState!.save();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("aliments")
          .doc(widget.aliment.id)
          .update({
        "name": widget.aliment.name,
        "calories": widget.aliment.calories,
        "proteines": widget.aliment.proteines,
        "fat": widget.aliment.fats,
        "carbs": widget.aliment.carbs,
        "category": widget.aliment.category.name,
        "unit": widget.aliment.unit.name,
        "quantity": widget.aliment.quantity
      });

      widget.onModifyAliment(widget.aliment);
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aliment Modifié!"),
        ),
      );
      Navigator.pop(context);
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
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"),
    );

    Widget addButton = ElevatedButton(
      onPressed: () {
        final isValid = form.currentState!.validate();
        if (!isValid) {
          return;
        }
        form.currentState!.save();
        _submit();
      },
      child: const Text("Modifier"),
    );
    return AlertDialog(
      title: const Text("Modifier l'aliment"),
      content: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildAlimentNameField(
                    widget.aliment.name,
                    widget.aliment.name,
                    widget.aliments,
                    widget.aliment.id,
                    (value) {
                      widget.aliment.name = value!;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: buildMacroField(widget.aliment.calories, "Calories",
                        (value) {
                  widget.aliment.calories = int.parse(value!);
                }))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    widget.aliment.proteines,
                    "Protéines",
                    (value) {
                      widget.aliment.proteines = num.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    widget.aliment.carbs,
                    "Glucides",
                    (value) {
                      widget.aliment.carbs = num.parse(value!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    widget.aliment.fats,
                    "Lipides",
                    (value) {
                      widget.aliment.fats = num.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    widget.aliment.quantity,
                    "Quantité",
                    (value) {
                      widget.aliment.quantity = num.parse(value!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildCategoryField(
                    widget.aliment.category,
                    (value) {
                      setState(() {
                        widget.aliment.category = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                    child: buildUnitField(widget.aliment.unit, (value) {
                  setState(() {
                    widget.aliment.unit = value!;
                  });
                }))
              ],
            )
          ],
        ),
      ),
      actions: [
        cancelButton,
        addButton,
      ],
    );
  }
}
