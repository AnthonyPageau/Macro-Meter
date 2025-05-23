import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/widgets/user_avatar.dart';
import 'package:macro_meter/widgets/form_fields.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AuthenticationScreenState();
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
  String? _enteredObjectif;
  String? _enteredSexe;

  File? _selectedAvatar;
  bool _isAvatarChosen = true;

  /// Permet d'ajouter les aliments à l'utilisateur à partir du fichiser JSON
  Future<void> loadJsonData(dynamic userCredentials) async {
    String jsonString = await rootBundle.loadString('assets/aliments.json');

    List<dynamic> jsonData = jsonDecode(jsonString);

    for (var item in jsonData) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredentials.user!.uid)
          .collection("aliments")
          .add({
        "name": item["aliment"],
        "calories": item["calories"],
        "proteines": item["proteines"],
        "fat": item["fat"],
        "carbs": item["carbs"],
        "category": item["categorie"],
        "unit": item["unit"],
        "quantity": item["quantity"],
        "isChecked": false
      });
    }
  }

  /// Permet de créer ou connecter l'utilisateur
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
            .child("user_avatar")
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
          "age": int.parse(_enteredAge),
          "weight": int.parse(_enteredWeight),
          "height": int.parse(_enteredHeight),
          "objective": _enteredObjectif,
          "sexe": _enteredSexe,
          "calories": int.parse(_enteredCalories)
        });
        await loadJsonData(userCredentials);
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      if (error.code == "email-already-in-use") {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Le courriel est déjà utilisé"),
          ),
        );
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
                            buildEmailField(_enteredEmail, (value) {
                              _enteredEmail = value!;
                            }),
                            if (!_isLogin) ...[
                              buildNameField(_enteredName, null, (value) {
                                _enteredName = value!;
                              }),
                              buildSurnameField(_enteredSurname, null, (value) {
                                _enteredSurname = value!;
                              }),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  bool isSmallScreen =
                                      constraints.maxWidth < 300;
                                  return Column(
                                    children: [
                                      if (isSmallScreen)
                                        Column(
                                          children: [
                                            buildAgeField(_enteredAge, null,
                                                (value) {
                                              _enteredAge = value!;
                                            }),
                                            const SizedBox(height: 12),
                                            buildHeightField(
                                                _enteredHeight, null, (value) {
                                              _enteredHeight = value!;
                                            }),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: buildAgeField(
                                                  _enteredAge, null, (value) {
                                                _enteredAge = value!;
                                              }),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: buildHeightField(
                                                  _enteredHeight, null,
                                                  (value) {
                                                _enteredHeight = value!;
                                              }),
                                            ),
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
                                            buildSexeField(_enteredSexe,
                                                (value) {
                                              setState(() {
                                                _enteredSexe = value!;
                                              });
                                            }),
                                            const SizedBox(height: 12),
                                            buildWeightField(
                                                _enteredWeight, null, (value) {
                                              _enteredWeight = value!;
                                            }),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: buildSexeField(
                                                  _enteredSexe, (value) {
                                                setState(() {
                                                  if (value != null) {
                                                    _enteredSexe = value;
                                                  }
                                                });
                                              }),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: buildWeightField(
                                                  _enteredWeight, null,
                                                  (value) {
                                                _enteredWeight = value!;
                                              }),
                                            ),
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
                                            buildObjectiveField(
                                                _enteredObjectif, (value) {
                                              setState(() {
                                                _enteredObjectif = value!;
                                              });
                                            }),
                                            const SizedBox(height: 12),
                                            buildCaloriesField(
                                                _enteredCalories, null,
                                                (value) {
                                              _enteredCalories = value!;
                                            }),
                                          ],
                                        )
                                      else
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: buildObjectiveField(
                                                  _enteredObjectif, (value) {
                                                setState(() {
                                                  if (value != null) {
                                                    _enteredObjectif = value;
                                                  }
                                                });
                                              }),
                                            ),
                                            const SizedBox(width: 24),
                                            Expanded(
                                              child: buildCaloriesField(
                                                  _enteredCalories, null,
                                                  (value) {
                                                _enteredCalories = value!;
                                              }),
                                            ),
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
