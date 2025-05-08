import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:macro_meter/widgets/account/show_alert_dialog.dart';
import 'package:macro_meter/widgets/account/password_alert_dialog.dart';
import 'package:macro_meter/widgets/user_avatar.dart';
import 'package:macro_meter/widgets/form_fields.dart';

class Account extends StatefulWidget {
  const Account({super.key, required this.user});

  final dynamic user;

  @override
  State<StatefulWidget> createState() => _AccountState();
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

  dynamic _password;

  File? _selectedAvatar;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// Retourne les données de l'utilisateur connecté
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

  /// Modifie les informations de l'utilisateur connecté
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
        "age": int.parse(_updatedAge!),
        "weight": int.parse(_updatedWeight!),
        "height": int.parse(_updatedHeight!),
        "objective": _updatedObjective ?? userData["objective"],
        "sexe": _updatedSexe ?? userData["sexe"],
        "calories": int.parse(_updatedCalories!)
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child("user_images")
          .child("${widget.user!.uid}.jpg");

      if (_selectedAvatar != null) await storageRef.putFile(_selectedAvatar!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Compte modifié"),
        ),
      );
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.code),
        ),
      );
    }
  }

  /// Supprime l'utilisateur connecté
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

        if (!mounted) return;
        Navigator.of(context).pop();
        FirebaseAuth.instance.signOut();
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
        centerTitle: true,
        title: const Text(
          "Compte",
          style: TextStyle(fontSize: 36),
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 56),
            child: const Text(
              "Compte",
              style: TextStyle(fontSize: 36),
            ),
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
                                                    userData["age"].toString(),
                                                    (value) {
                                                  _updatedAge = value!;
                                                }),
                                                const SizedBox(height: 12),
                                                buildHeightField(
                                                    _updatedHeight,
                                                    userData["height"]
                                                        .toString(), (value) {
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
                                                      userData["age"]
                                                          .toString(), (value) {
                                                    _updatedAge = value!;
                                                  }),
                                                ),
                                                const SizedBox(width: 24),
                                                Expanded(
                                                  child: buildHeightField(
                                                      _updatedHeight,
                                                      userData["height"]
                                                          .toString(), (value) {
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
                                                buildWeightField(
                                                    _updatedWeight,
                                                    userData["weight"]
                                                        .toString(), (value) {
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
                                                      userData["weight"]
                                                          .toString(), (value) {
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
                                                    userData["calories"]
                                                        .toString(), (value) {
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
                                                      userData["calories"]
                                                          .toString(), (value) {
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
