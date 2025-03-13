import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/aliment.dart';

class DeleteAlimentAlertDialog extends StatefulWidget {
  const DeleteAlimentAlertDialog(
      {required this.user,
      required this.aliment,
      required this.plan,
      required this.meal,
      required this.onDeleteALiment,
      super.key});

  final User user;
  final Plan plan;
  final Meal meal;
  final Aliment aliment;
  final void Function(Aliment deletedAliment) onDeleteALiment;

  @override
  State<StatefulWidget> createState() {
    return _DeleteAlimentAlertDialogState();
  }
}

class _DeleteAlimentAlertDialogState extends State<DeleteAlimentAlertDialog> {
  void deleteAliment() async {
    try {
      var doc = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("plan")
          .doc(widget.plan.id)
          .collection("repas")
          .doc(widget.meal.id)
          .collection("aliments")
          .doc(widget.aliment.id);

      doc.delete();
      widget.onDeleteALiment(widget.aliment);
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
      title: Text("Voulez-vous supprimer l'aliment?"),
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
            deleteAliment();
          },
        ),
      ],
    );
  }
}
