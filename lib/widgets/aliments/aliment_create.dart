import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class AlimentCreate extends StatefulWidget {
  const AlimentCreate(
      {required this.user, required this.onAddAliment, super.key});

  final User user;
  final void Function(Aliment newAliment) onAddAliment;
  @override
  State<StatefulWidget> createState() {
    return _AlimentCreateState();
  }
}

class _AlimentCreateState extends State<AlimentCreate> {
  var alimentName = "";
  var fatsValue = "";
  var proteinesValue = "";
  var carbsValue = "";
  var caloriesValue = "";
  var quantityValue = "";
  Category? categoryValue;
  Unit? unitValue;
  Aliment? newAliment;

  final form = GlobalKey<FormState>();

  void _submit() async {
    try {
      final isValid = form.currentState!.validate();

      if (!isValid) {
        return;
      }

      form.currentState!.save();
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("aliments")
          .add({
        "name": alimentName,
        "calories": int.parse(caloriesValue),
        "proteines": num.parse(proteinesValue),
        "fat": num.parse(fatsValue),
        "carbs": num.parse(carbsValue),
        "category": categoryValue!.name,
        "unit": unitValue!.name,
        "quantity": int.parse(quantityValue)
      });

      widget.onAddAliment(Aliment(
          id: docRef.id,
          name: alimentName,
          calories: int.parse(caloriesValue),
          protein: num.parse(proteinesValue),
          carbs: num.parse(carbsValue),
          fat: num.parse(fatsValue),
          unit: unitValue!,
          quantity: int.parse(quantityValue),
          category: categoryValue!));

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Aliment Ajouté!"),
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
      child: const Text("Ajouter"),
    );
    return AlertDialog(
      title: const Text("Ajouter un aliment"),
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
                  child: buildSurnameField(
                    alimentName,
                    null,
                    (value) {
                      alimentName = value!;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: buildMacroField(caloriesValue, null, "Calories",
                        (value) {
                  caloriesValue = value!;
                }))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    proteinesValue,
                    null,
                    "Protéines",
                    (value) {
                      proteinesValue = value!;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    carbsValue,
                    null,
                    "Glucides",
                    (value) {
                      carbsValue = value!;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    fatsValue,
                    null,
                    "Lipides",
                    (value) {
                      fatsValue = value!;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    quantityValue,
                    null,
                    "Quantité",
                    (value) {
                      quantityValue = value!;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildCategoryField(
                    categoryValue,
                    (value) {
                      setState(() {
                        categoryValue = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                    child: buildUnitField(unitValue, (value) {
                  setState(() {
                    unitValue = value!;
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
