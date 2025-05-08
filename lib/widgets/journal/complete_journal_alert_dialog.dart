import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteJournalAlertDialog extends StatefulWidget {
  const CompleteJournalAlertDialog(
      {required this.user,
      required this.journal,
      required this.onCompleteJournal,
      super.key});

  final User user;
  final Journal journal;
  final void Function(Journal journal) onCompleteJournal;

  @override
  State<StatefulWidget> createState() => _CompleteJournalAlertDialogState();
}

class _CompleteJournalAlertDialogState
    extends State<CompleteJournalAlertDialog> {
  /// Permet de compléter un journal
  void _submit() async {
    try {
      for (Meal meal in widget.journal.plan.meals) {
        if (meal.aliments.isEmpty) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Aucun repas ne peut être vide"),
            ),
          );
          return;
        }
      }
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("journals")
          .doc(widget.journal.id)
          .update({"isComplete": true});
      widget.journal.isComplete = true;
      widget.onCompleteJournal(widget.journal);
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
      title: const Text("Compléter le journal"),
      actions: [
        ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: Text("Compléter"),
          onPressed: () {
            _submit();
          },
        ),
      ],
    );
  }
}
