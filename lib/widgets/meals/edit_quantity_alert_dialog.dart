import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/journal.dart';

class EditQuantityAlertDialog extends StatefulWidget {
  const EditQuantityAlertDialog(
      {required this.aliment,
      required this.plan,
      required this.meal,
      required this.user,
      this.journal,
      required this.onModifyQuantity,
      super.key});

  final User user;
  final Aliment aliment;
  final Plan plan;
  final Meal meal;
  final Journal? journal;
  final void Function(Aliment aliment) onModifyQuantity;

  @override
  State<StatefulWidget> createState() => _EditQuantityAlertDialogState();
}

class _EditQuantityAlertDialogState extends State<EditQuantityAlertDialog> {
  final form = GlobalKey<FormState>();

  late num quanity;

  /// Permet de modifier la quantité d'un aliment
  void _submit() async {
    try {
      widget.aliment.updateValues(quanity);
      if (widget.journal != null) {
        FirebaseFirestore.instance
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
            .update({
          "calories": widget.aliment.calories,
          "proteines": widget.aliment.proteines,
          "carbs": widget.aliment.carbs,
          "fat": widget.aliment.fats,
          "quantity": widget.aliment.quantity,
        });
      } else {
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .doc(widget.aliment.id)
            .update({
          "calories": widget.aliment.calories,
          "proteines": widget.aliment.proteines,
          "carbs": widget.aliment.carbs,
          "fat": widget.aliment.fats,
          "quantity": widget.aliment.quantity,
        });
      }
      widget.onModifyQuantity(widget.aliment);
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
    return AlertDialog(
      title: const Text("Modifier quantité"),
      content: Form(
        key: form,
        child: TextFormField(
          decoration: InputDecoration(labelText: "Nouvelle quantité :"),
          keyboardType:
              TextInputType.numberWithOptions(signed: false, decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "La quantité ne peut pas être vide";
            }
            if (int.tryParse(value) == null) {
              return "La quantité doit être un nombre entier";
            }
            return null;
          },
          onSaved: (value) {
            quanity = num.parse(value!);
          },
        ),
      ),
      actions: [
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Modifer"),
          onPressed: () {
            final isValid = form.currentState!.validate();
            if (!isValid) {
              return;
            }

            form.currentState!.save();
            _submit();
          },
        ),
      ],
    );
  }
}
