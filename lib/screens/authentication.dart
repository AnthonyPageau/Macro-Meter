import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:macro_meter/widgets/user_avatar.dart';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreenState();
  }
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _form = GlobalKey<FormState>();

  var _enteredEmail = "";
  var _enteredPassword = "";
  var _verifyPassword = "";
  var _isLogin = true;

  var _enteredName = "";
  var _enteredSurname = "";
  var _enteredAge = "";
  var _enteredWeight = "";
  var _enteredHeight = "";
  var _enteredCalories = "";
  var _enteredObjectif = "Maintient";
  var _enteredSexe = "Homme";

  File? _selectedAvatar;
  bool _isAvatarChosen = true;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    setState(() {
      if (_selectedAvatar == null) {
        _isAvatarChosen = false;
      }
    });

    if (!isValid || !_isLogin && _selectedAvatar == null) {
      return;
    }

    _form.currentState!.save();

    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredentials.user!.uid}.jpg");

        await storageRef.putFile(_selectedAvatar!);
        final avatarUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({
          "avatar": avatarUrl,
          "email": _enteredEmail,
          "surname": _enteredSurname,
          "name": _enteredName,
          "age": _enteredAge,
          "weight": _enteredWeight,
          "height": _enteredHeight,
          "objective": _enteredObjectif,
          "sexe": _enteredSexe,
          "calories": _enteredCalories
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Authentification échoué"),
          ),
        );
      }
    }
  }

  Widget buildAgeField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Âge :"),
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "L'Âge ne peut pas être vide";
        }
        if (int.tryParse(value) == null) {
          return "L'Âge doit être un nombre entier";
        }
        return null;
      },
      onSaved: (value) {
        _enteredAge = value!;
      },
    );
  }

  Widget buildHeightField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Taille (cm):"),
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "La Taille ne peut pas être vide";
        }
        if (int.tryParse(value) == null) {
          return "La Taille doit être un nombre entier";
        }
        return null;
      },
      onSaved: (value) {
        _enteredHeight = value!;
      },
    );
  }

  Widget buildSexeField() {
    return DropdownButton<String>(
      hint: Text("Objectif"),
      value: _enteredSexe,
      items: <String>["Homme", "Femme", "Autres"].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _enteredSexe = value!;
        });
      },
    );
  }

  Widget buildWeightField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Poids (lbs):"),
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Le Poids ne peut pas être vide";
        }

        if (int.tryParse(value) == null) {
          return "Le poids doit être un nombre entier";
        }
        return null;
      },
      onSaved: (value) {
        _enteredWeight = value!;
      },
    );
  }

  Widget buildObjectiveField() {
    return DropdownButton<String>(
      hint: Text("Objectif"),
      value: _enteredObjectif,
      items: <String>['Maintient', 'Perte de poids', 'Prise de poids']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _enteredObjectif = value!;
        });
      },
    );
  }

  Widget buildCaloriesField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Objectif Calorique :"),
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: true),
      autocorrect: false,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "L'objectif ne peut pas être vide";
        }

        if (int.tryParse(value) == null) {
          return "L'objectif doit être un nombre entier";
        }
        return null;
      },
      onSaved: (value) {
        _enteredCalories = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 17, 127, 112),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 200,
                  child: Image.asset("assets/images/logo.png"),
                ),
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
                            if (!_isLogin) ...[
                              UserAvatar(
                                action: "Ajouter",
                                onPickAvatar: (pickedAvatar) {
                                  _selectedAvatar = pickedAvatar;
                                  _isAvatarChosen = true;
                                },
                              ),
                              if (!_isAvatarChosen)
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    "Veuillez choisir un avatar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                            ],
                            TextFormField(
                              decoration:
                                  InputDecoration(labelText: "Courriel :"),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.isEmail(
                                        supportTopLevelDomain: true)) {
                                  return "Veuillez rentrer une adresse courielle valide";
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            if (!_isLogin) ...[
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: "Prenom :"),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Le Prenom ne peut pas être vide";
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredSurname = value!;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(labelText: "Nom :"),
                                autocorrect: false,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Le Nom ne peut pas être vide";
                                  }

                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredName = value!;
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isSmallScreen =
                                      constraints.maxWidth < 300;
                                  return Column(
                                    children: [
                                      if (isSmallScreen)
                                        Column(
                                          children: [
                                            buildAgeField(),
                                            const SizedBox(height: 12),
                                            buildHeightField(),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: buildAgeField()),
                                            const SizedBox(width: 24),
                                            Expanded(child: buildHeightField()),
                                          ],
                                        ),
                                    ],
                                  );
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isSmallScreen =
                                      constraints.maxWidth < 300;
                                  return Column(
                                    children: [
                                      if (isSmallScreen)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildSexeField(),
                                            const SizedBox(height: 12),
                                            buildWeightField(),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: buildSexeField()),
                                            const SizedBox(width: 24),
                                            Expanded(child: buildWeightField()),
                                          ],
                                        ),
                                    ],
                                  );
                                },
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isSmallScreen =
                                      constraints.maxWidth < 300;
                                  return Column(
                                    children: [
                                      if (isSmallScreen)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            buildObjectiveField(),
                                            const SizedBox(height: 12),
                                            buildCaloriesField(),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: buildObjectiveField()),
                                            const SizedBox(width: 24),
                                            Expanded(
                                                child: buildCaloriesField()),
                                          ],
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: "Mot de Passe"),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return "Le mot de passe doit contenir au minimum 6 caractères";
                                }

                                return null;
                              },
                              onChanged: (value) {
                                _verifyPassword = value;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Confirmation Mot de Passe"),
                                obscureText: true,
                                validator: (value) {
                                  if (value != _verifyPassword) {
                                    return "Les mots de passe doivent être identique";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                              ),
                            const SizedBox(
                              height: 12,
                            ),
                            ElevatedButton(
                              onPressed: _submit,
                              child: Text(_isLogin ? "Connexion" : "Créer"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _form.currentState?.reset();
                                  _isAvatarChosen = true;
                                });
                              },
                              child: Text(_isLogin
                                  ? "Créer un compte"
                                  : "J'ai déjà un compte"),
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
