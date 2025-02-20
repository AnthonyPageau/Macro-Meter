import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:macro_meter/screens/authentication.dart';
import 'package:macro_meter/screens/home.dart';
import 'package:macro_meter/widgets/show_alert_dialog.dart';
import 'package:macro_meter/widgets/user_avatar.dart';

class Account extends StatefulWidget {
  const Account({super.key, required this.user});

  final dynamic user;

  @override
  State<StatefulWidget> createState() {
    return _AccountState();
  }
}

class _AccountState extends State<Account> {
  final _form = GlobalKey<FormState>();

  dynamic userData;

  String? avatarUrl;
  String? _updatedSurname;
  String? _updatedName;
  String? _updatedAge;
  String? _updatedWeight;
  String? _updatedHeight;
  String? _updatedObjectif;

  var _password;

  File? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .get();

    final storageRef = FirebaseStorage.instance
        .ref()
        .child("user_images")
        .child("${widget.user.uid}.jpg");

    final url = await storageRef.getDownloadURL();

    setState(() {
      userData = doc;
      avatarUrl = url;
    });
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid && _selectedAvatar == null) {
      return;
    }

    _form.currentState!.save();

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.user.uid)
          .update({
        "avatar": avatarUrl,
        "surname": _updatedSurname,
        "name": _updatedName,
        "age": _updatedAge,
        "weight": _updatedWeight,
        "height": _updatedHeight,
        "objective": _updatedObjectif
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${widget.user!.uid}.jpg");

      await storageRef.putFile(_selectedAvatar!);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Compte modifié"),
        ),
      );
    } catch (e) {}
  }

  Future<void> deleteCurrentUser() async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user.email!, password: _password);

        await user.delete();
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AuthenticationScreen(),
          ),
        );
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mot de passe non valide"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Compte",
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 17, 127, 112),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: userData == null
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        margin: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: _form,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UserAvatar(
                                    action: "Modifier",
                                    avatarUrl: avatarUrl,
                                    onPickAvatar: (pickedAvatar) {
                                      _selectedAvatar = pickedAvatar;
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Prenom :"),
                                    autocorrect: false,
                                    initialValue: userData!["surname"],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Le Prenom ne peut pas être vide";
                                      }

                                      return null;
                                    },
                                    onSaved: (value) {
                                      _updatedSurname = value!;
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Nom :"),
                                    autocorrect: false,
                                    initialValue: userData!["name"],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Le Nom ne peut pas être vide";
                                      }

                                      return null;
                                    },
                                    onSaved: (value) {
                                      _updatedName = value!;
                                    },
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: "Âge :"),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: false, decimal: true),
                                          autocorrect: false,
                                          initialValue: userData!["age"],
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "L'Âge ne peut pas être vide";
                                            }

                                            if (int.tryParse(value) == null) {
                                              return "L'Âge doit être un nombre entier";
                                            }

                                            return null;
                                          },
                                          onSaved: (value) {
                                            _updatedAge = value!;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: "Taille (cm):"),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: false, decimal: true),
                                          autocorrect: false,
                                          initialValue: userData!["height"],
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "La Taille ne peut pas être vide";
                                            }

                                            if (int.tryParse(value) == null) {
                                              return "La Taille doit être un nombre entier";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _updatedHeight = value!;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: DropdownButton<String>(
                                          value: userData!["objective"],
                                          hint: Text("Objectif"),
                                          items: <String>[
                                            'Maintient',
                                            'Perte de poids',
                                            'Prise de poids'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _updatedObjectif = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              labelText: "Poids (lbs):"),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  signed: false, decimal: true),
                                          autocorrect: false,
                                          initialValue: userData!["weight"],
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Le Poids ne peut pas être vide";
                                            }

                                            if (int.tryParse(value) == null) {
                                              return "Le poids doit être un nombre entier";
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _updatedWeight = value!;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(170, 40)),
                                    onPressed: () {
                                      _submit();
                                    },
                                    child: Text("Modifier"),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => ShowAlertDialog(
                                          titre:
                                              "Voulez-vous vraiment supprimer votre compte?",
                                          action: deleteCurrentUser,
                                          onPassword: (onPickPassword) {
                                            _password = onPickPassword;
                                          },
                                        ),
                                      );
                                    },
                                    child: Text("Supprimer"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
