import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class PlanCreate extends StatefulWidget {
  const PlanCreate({required this.user, required this.onAddPlan, super.key});

  final User user;
  final void Function(Plan newPlan) onAddPlan;

  @override
  State<StatefulWidget> createState() {
    return _PlanCreateState();
  }
}

class _PlanCreateState extends State<PlanCreate> {
  String? planName;
  final form = GlobalKey<FormState>();

  void _submit() async {
    final isValid = form.currentState!.validate();

    if (!isValid) {
      return;
    }
    form.currentState!.save();

    widget.onAddPlan(Plan(id: "test", name: planName!, date: DateTime.now()));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Plan Ajouté!"),
      ),
    );
    Navigator.of(context).pop();
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
            buildSurnameField(
              planName,
              null,
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
