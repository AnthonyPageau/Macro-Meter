import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:macro_meter/widgets/user_avatar.dart';
import 'package:macro_meter/widgets/user_create.dart';

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
  var _enteredObjectif = "Maintient";

  File? _selected_Avatar;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid || !_isLogin && _selected_Avatar == null) {
      return;
    }

    _form.currentState!.save();

    try {
      if (_isLogin) {
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("${userCredentials.user!.uid}.jpg");

        await storageRef.putFile(_selected_Avatar!);
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
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "email-already-in-use") {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? "Authentification échoué"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
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
                          if (!_isLogin)
                            UserAvatar(
                              onPickAvatar: (pickedAvatar) {
                                _selected_Avatar = pickedAvatar;
                              },
                            ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "Courriel :"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.isEmail(supportTopLevelDomain: true)) {
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration:
                                        InputDecoration(labelText: "Âge :"),
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            signed: false, decimal: true),
                                    autocorrect: false,
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
                                      _enteredAge = value!;
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
                                      _enteredHeight = value!;
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: DropdownButton<String>(
                                    hint: Text("Objectif"),
                                    value: _enteredObjectif,
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
                                        _enteredObjectif = value!;
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
                                      _enteredWeight = value!;
                                    },
                                  ),
                                )
                              ],
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
    );
  }
}
