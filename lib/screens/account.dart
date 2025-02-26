import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:macro_meter/screens/authentication.dart';
import 'package:macro_meter/widgets/show_alert_dialog.dart';
import 'package:macro_meter/widgets/password_alert_dialog.dart';
import 'package:macro_meter/widgets/user_avatar.dart';
import 'package:macro_meter/widgets/form_fields.dart';

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
  String? _updatedObjective;
  String? _updatedSexe;
  String? _updatedCalories;

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
        .child("user_avatar")
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
        "objective": _updatedObjective ?? userData["objective"],
        "sexe": _updatedSexe ?? userData["sexe"],
        "calories": _updatedCalories
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${widget.user!.uid}.jpg");

      if (_selectedAvatar != null) await storageRef.putFile(_selectedAvatar!);

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
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: user.email!, password: _password);

        final firestoreRef =
            FirebaseFirestore.instance.collection("users").doc(widget.user.uid);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child("user_images")
            .child("user_avatar")
            .child("${user.uid}.jpg");

        await firestoreRef.delete();
        await storageRef.delete();
        await user.delete();

        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => AuthenticationScreen(),
          ),
        );
      }
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
                                  buildNameField(_updatedName, userData["name"],
                                      (value) {
                                    _updatedName = value!;
                                  }),
                                  buildSurnameField(
                                      _updatedSurname, userData["surname"],
                                      (value) {
                                    _updatedSurname = value!;
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
                                                buildAgeField(_updatedAge,
                                                    userData["age"], (value) {
                                                  _updatedAge = value!;
                                                }),
                                                const SizedBox(height: 12),
                                                buildHeightField(_updatedHeight,
                                                    userData["height"],
                                                    (value) {
                                                  _updatedHeight = value!;
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
                                                      _updatedAge,
                                                      userData["age"], (value) {
                                                    _updatedAge = value!;
                                                  }),
                                                ),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                  child: buildHeightField(
                                                      _updatedHeight,
                                                      userData["height"],
                                                      (value) {
                                                    _updatedHeight = value!;
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
                                                buildSexeField(
                                                    _updatedSexe ??
                                                        userData["sexe"],
                                                    (value) {
                                                  setState(() {
                                                    _updatedSexe = value!;
                                                  });
                                                }),
                                                const SizedBox(height: 12),
                                                buildWeightField(_updatedWeight,
                                                    userData["weight"],
                                                    (value) {
                                                  _updatedWeight = value!;
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
                                                      _updatedSexe ??
                                                          userData["sexe"],
                                                      (value) {
                                                    setState(() {
                                                      _updatedSexe = value!;
                                                    });
                                                  }),
                                                ),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                  child: buildWeightField(
                                                      _updatedWeight,
                                                      userData["weight"],
                                                      (value) {
                                                    _updatedWeight = value!;
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
                                                    _updatedObjective ??
                                                        userData["objective"],
                                                    (value) {
                                                  setState(() {
                                                    _updatedObjective = value!;
                                                  });
                                                }),
                                                const SizedBox(height: 12),
                                                buildCaloriesField(
                                                    _updatedCalories,
                                                    userData["calories"],
                                                    (value) {
                                                  _updatedCalories = value!;
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
                                                      _updatedObjective ??
                                                          userData["objective"],
                                                      (value) {
                                                    setState(() {
                                                      _updatedObjective =
                                                          value!;
                                                    });
                                                  }),
                                                ),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                  child: buildCaloriesField(
                                                      _updatedCalories,
                                                      userData["calories"],
                                                      (value) {
                                                    _updatedCalories = value!;
                                                  }),
                                                ),
                                              ],
                                            ),
                                        ],
                                      );
                                    },
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
                                    child: Text("Modifier informations"),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => PasswordAlertDialog(
                                            user: widget.user,
                                          ),
                                        );
                                      },
                                      child: Text("Modifier mot de passe")),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.red),
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
