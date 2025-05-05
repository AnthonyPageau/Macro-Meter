import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/journal.dart';

class DeleteMealAlertDialog extends StatefulWidget {
  const DeleteMealAlertDialog(
      {required this.user,
      required this.plan,
      required this.meal,
      this.journal,
      required this.onDeleteMeal,
      super.key});

  final User user;
  final Plan plan;
  final Meal meal;
  final Journal? journal;
  final void Function(Meal deletedMeal) onDeleteMeal;

  @override
  State<StatefulWidget> createState() {
    return _DeleteMealAlertDialogState();
  }
}

class _DeleteMealAlertDialogState extends State<DeleteMealAlertDialog> {
  /// Permet de supprimer un repas
  void deleteMeal() async {
    try {
      CollectionReference collection;
      var docMeal;
      if (widget.journal != null) {
        docMeal = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id);

        collection = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments");
      } else {
        docMeal = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id);

        collection = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments");
      }

      QuerySnapshot collectionSnapshot = await collection.get();
      for (var doc in collectionSnapshot.docs) {
        await doc.reference.delete();
      }

      docMeal.delete();
      widget.onDeleteMeal(widget.meal);
      Navigator.pop(context);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Voulez-vous supprimer le repas?"),
      actions: [
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Supprimer"),
          onPressed: () {
            deleteMeal();
          },
        ),
      ],
    );
  }
}
