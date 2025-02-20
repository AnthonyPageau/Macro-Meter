import 'package:flutter/material.dart';

class ShowAlertDialog extends StatelessWidget {
  ShowAlertDialog({
    super.key,
    required this.titre,
    required this.action,
    required this.onPassword,
  });

  final String titre;
  final Function action;
  final void Function(String password) onPassword;

  var _password;

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Supprimer"),
      onPressed: () {
        _form.currentState!.save();
        onPassword(_password);
        action();
      },
    );

    return AlertDialog(
      title: Text(titre),
      content: Form(
        key: _form,
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(labelText: "Confirmer mot de passe :"),
          onSaved: (value) {
            _password = value!;
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
