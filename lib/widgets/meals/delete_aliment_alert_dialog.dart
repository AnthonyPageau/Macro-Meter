import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';

class DeleteAlimentAlertDialog extends StatefulWidget {
  const DeleteAlimentAlertDialog(
      {required this.user,
      required this.aliment,
      required this.plan,
      required this.meal,
      this.journal,
      required this.onDeleteALiment,
      super.key});

  final User user;
  final Plan plan;
  final Meal meal;
  final Aliment aliment;
  final Journal? journal;
  final void Function(Aliment deletedAliment) onDeleteALiment;

  @override
  State<StatefulWidget> createState() {
    return _DeleteAlimentAlertDialogState();
  }
}

class _DeleteAlimentAlertDialogState extends State<DeleteAlimentAlertDialog> {
  void deleteAliment() async {
    try {
      var doc;

      if (widget.journal != null) {
        doc = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("journals")
            .doc(widget.journal!.id)
            .collection("plan")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .doc(widget.aliment.id);
      } else {
        doc = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("plans")
            .doc(widget.plan.id)
            .collection("meals")
            .doc(widget.meal.id)
            .collection("aliments")
            .doc(widget.aliment.id);
      }

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
