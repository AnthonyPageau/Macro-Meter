import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordAlertDialog extends StatefulWidget {
  PasswordAlertDialog({
    required this.user,
    super.key,
  });
  User user;
  dynamic _oldPassword;
  dynamic _newPassword;
  dynamic _verifyNewPassword;
  bool _wrongPassword = false;

  @override
  State<StatefulWidget> createState() {
    return PasswordAlertDialogState();
  }
}

class PasswordAlertDialogState extends State<PasswordAlertDialog> {
  void _submit() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.user.email!, password: widget._oldPassword);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mot de passe modifié!"),
        ),
      );
      Navigator.of(context).pop();
      widget.user.updatePassword(widget._newPassword);
    } on FirebaseAuthException catch (error) {
      setState(() {
        widget._wrongPassword = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();

    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Modifier"),
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
                widget._oldPassword = value!;
              },
            ),
            if (widget._wrongPassword)
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
                widget._newPassword = value!;
              },
              onChanged: (value) {
                widget._verifyNewPassword = value;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration:
                  InputDecoration(labelText: "Confirmer mot de passe :"),
              validator: (value) {
                if (value != widget._verifyNewPassword) {
                  return "Les mots de passe doivent être identique";
                }
                return null;
              },
              onSaved: (value) {
                widget._newPassword = value!;
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
