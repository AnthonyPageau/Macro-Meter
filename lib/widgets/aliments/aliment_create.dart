import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class AlimentCreate extends StatefulWidget {
  const AlimentCreate(
      {required this.user,
      required this.onAddAliment,
      super.key,
      required this.aliments});

  final User user;
  final List<Aliment> aliments;
  final void Function(Aliment newAliment) onAddAliment;
  @override
  State<StatefulWidget> createState() {
    return _AlimentCreateState();
  }
}

class _AlimentCreateState extends State<AlimentCreate> {
  String? alimentName;
  num? fatsValue;
  num? proteinesValue;
  num? carbsValue;
  int? caloriesValue;
  num? quantityValue;
  Category? categoryValue;
  Unit? unitValue;
  Aliment? newAliment;

  final form = GlobalKey<FormState>();

  void _submit() async {
    try {
      final isValid = form.currentState!.validate();

      if (widget.aliments.any((aliment) => aliment.name == alimentName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("L'aliment existe déjà"),
          ),
        );
        return;
      }

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
        "calories": caloriesValue,
        "proteines": proteinesValue,
        "fat": fatsValue,
        "carbs": carbsValue,
        "category": categoryValue!.name,
        "unit": unitValue!.name,
        "quantity": quantityValue
      });

      widget.onAddAliment(
        Aliment(
            id: docRef.id,
            name: alimentName!,
            calories: caloriesValue!,
            proteines: proteinesValue!,
            carbs: carbsValue!,
            fat: fatsValue!,
            unit: unitValue!,
            quantity: quantityValue!,
            category: categoryValue!),
      );

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
                  child: buildAlimentNameField(
                    alimentName,
                    null,
                    widget.aliments,
                    (value) {
                      alimentName = value!;
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    child: buildMacroField(caloriesValue ?? 0, "Calories",
                        (value) {
                  caloriesValue = int.parse(value!);
                }))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    proteinesValue ?? 0,
                    "Protéines",
                    (value) {
                      proteinesValue = num.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    carbsValue ?? 0,
                    "Glucides",
                    (value) {
                      carbsValue = num.parse(value!);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: buildMacroField(
                    fatsValue ?? 0,
                    "Lipides",
                    (value) {
                      fatsValue = num.parse(value!);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: buildMacroField(
                    quantityValue ?? 0,
                    "Quantité",
                    (value) {
                      quantityValue = num.parse(value!);
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
