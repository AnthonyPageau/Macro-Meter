import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class PlanCreate extends StatefulWidget {
  const PlanCreate(
      {required this.user,
      required this.onAddPlan,
      required this.plans,
      super.key});

  final User user;
  final List<Plan> plans;
  final void Function(Plan newPlan) onAddPlan;

  @override
  State<StatefulWidget> createState() {
    return _PlanCreateState();
  }
}

class _PlanCreateState extends State<PlanCreate> {
  String? planName;
  final form = GlobalKey<FormState>();

  /// Permet de créer un plan
  void _submit() async {
    try {
      final isValid = form.currentState!.validate();

      if (!isValid) {
        return;
      }
      form.currentState!.save();
      DateTime date = DateTime.now();
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .collection("plans")
          .add({"name": planName, "date": date.toString()});

      widget.onAddPlan(
          Plan(id: docRef.id, name: planName!, date: DateTime.now()));
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Plan Ajouté!"),
        ),
      );
      Navigator.of(context).pop();
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
      onPressed: Navigator.of(context).pop,
      child: const Text("Cancel"),
    );

    Widget addButton = ElevatedButton(
      onPressed: () {
        _submit();
      },
      child: const Text("Ajouter"),
    );

    return AlertDialog(
      title: const Text("Ajouter un plan"),
      content: Form(
        key: form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPlanNameField(
              planName,
              null,
              widget.plans,
              (value) {
                planName = value!;
              },
            )
          ],
        ),
      ),
      actions: [cancelButton, addButton],
    );
  }
}
