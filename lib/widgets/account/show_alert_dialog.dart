import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  const ShowAlertDialog({
    super.key,
    required this.titre,
    required this.action,
    required this.onPassword,
  });

  final String titre;
  final Function action;
  final void Function(String password) onPassword;

  @override
  Widget build(BuildContext context) {
    String password = "";

    final form = GlobalKey<FormState>();

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Supprimer"),
      onPressed: () {
        form.currentState!.save();
        onPassword(password);
        action();
        Navigator.of(context).pop();
      },
    );

    return AlertDialog(
      title: Text(titre),
      content: Form(
        key: form,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(labelText: "Confirmer mot de passe :"),
          onSaved: (value) {
            password = value!;
          },
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
