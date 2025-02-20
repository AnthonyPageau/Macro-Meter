import 'package:flutter/material.dart';

class UserCreate extends StatefulWidget {
  UserCreate(
      {required this.enteredName,
      required this.enteredAge,
      required this.enteredHeight,
      required this.enteredObjectif,
      required this.enteredWeight,
      required this.onPickSurname,
      super.key});

  String? enteredSurname;
  String? enteredName;
  String? enteredAge;
  String? enteredHeight;
  String? enteredObjectif;
  String? enteredWeight;
  final void Function(String enteredSurname) onPickSurname;

  @override
  State<StatefulWidget> createState() {
    return _UserCreateState();
  }
}

class _UserCreateState extends State<UserCreate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Prenom :"),
          autocorrect: false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Le Prenom ne peut pas être vide";
            }

            return null;
          },
          onSaved: (value) {
            widget.enteredSurname = value;
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
            widget.enteredName = value!;
          },
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Âge :"),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "L'Âge ne peut pas être vide";
                  }

                  return null;
                },
                onSaved: (value) {
                  widget.enteredAge = value!;
                },
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Taille (cm):"),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "La Taille ne peut pas être vide";
                  }

                  return null;
                },
                onSaved: (value) {
                  widget.enteredHeight = value!;
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
                value: widget.enteredObjectif,
                items: <String>['Maintient', 'Perte de poids', 'Prise de poids']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.enteredObjectif = value!;
                  });
                },
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(labelText: "Poids (lbs):"),
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Le Poids ne peut pas être vide";
                  }

                  return null;
                },
                onSaved: (value) {
                  widget.enteredWeight = value!;
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
