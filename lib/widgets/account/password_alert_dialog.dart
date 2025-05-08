import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordAlertDialog extends StatefulWidget {
  const PasswordAlertDialog({
    required this.user,
    super.key,
  });
  final User user;

  @override
  State<StatefulWidget> createState() => PasswordAlertDialogState();
}

class PasswordAlertDialogState extends State<PasswordAlertDialog> {
  String _oldPassword = '';
  String _newPassword = '';
  String _verifyNewPassword = '';
  bool _wrongPassword = false;

  /// Permet de modifier le mot de passe
  void _submit() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.user.email!,
        password: _oldPassword,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mot de passe modifié!"),
        ),
      );

      Navigator.of(context).pop();

      widget.user.updatePassword(_newPassword);
    } on FirebaseAuthException catch (_) {
      if (!mounted) return;

      setState(() {
        _wrongPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();

    Widget cancelButton = ElevatedButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Modifier"),
      onPressed: () {
        final isValid = form.currentState!.validate();
        if (!isValid) {
          return;
        }

        form.currentState!.save();
        _submit();
      },
    );

    return AlertDialog(
      title: Text("Modifier mot de passe"),
      content: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Ancien mot de passe :"),
              onSaved: (value) {
                _oldPassword = value!;
              },
            ),
            if (_wrongPassword)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mot de passe invalide",
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Nouveau mot de passe :"),
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return "Le mot de passe doit contenir au minimum 6 caractères";
                }

                return null;
              },
              onSaved: (value) {
                _newPassword = value!;
              },
              onChanged: (value) {
                _verifyNewPassword = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration:
                  InputDecoration(labelText: "Confirmer mot de passe :"),
              validator: (value) {
                if (value != _verifyNewPassword) {
                  return "Les mots de passe doivent être identique";
                }
                return null;
              },
              onSaved: (value) {
                _newPassword = value!;
              },
            ),
          ],
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
  }
}
