import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';

Widget buildAgeField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Âge :"),
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "L'Âge ne peut pas être vide";
      }
      if (int.tryParse(value) == null) {
        return "L'Âge doit être un nombre entier";
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildHeightField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Taille (cm):"),
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "La Taille ne peut pas être vide";
      }
      if (int.tryParse(value) == null) {
        return "La Taille doit être un nombre entier";
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildSexeField(String? value, Function(String?) onChanged) {
  return DropdownButton<String>(
    hint: Text("Objectif"),
    value: value,
    items: <String>["Homme", "Femme", "Autres"].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget buildWeightField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Poids (lbs):"),
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Le Poids ne peut pas être vide";
      }

      if (int.tryParse(value) == null) {
        return "Le poids doit être un nombre entier";
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildObjectiveField(String? value, Function(String?) onChanged) {
  return DropdownButton<String>(
    hint: Text("Objectif"),
    value: value,
    items: <String>['Maintient', 'Perte de poids', 'Prise de poids']
        .map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

Widget buildCaloriesField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Objectif Calorique :"),
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "L'objectif ne peut pas être vide";
      }

      if (int.tryParse(value) == null) {
        return "L'objectif doit être un nombre entier";
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildEmailField(String? value, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Courriel :"),
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
    onSaved: onSaved,
  );
}

Widget buildNameField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Prenom :"),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Le Prenom ne peut pas être vide";
      }

      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildSurnameField(
    String? value, String? initialValue, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Nom :"),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Le Nom ne peut pas être vide";
      }

      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildPasswordField(
    String? value, Function(String?) onSaved, Function(String?) onChanged) {
  return TextFormField(
    decoration: const InputDecoration(labelText: "Mot de Passe"),
    obscureText: true,
    validator: (value) {
      if (value == null || value.trim().length < 6) {
        return "Le mot de passe doit contenir au minimum 6 caractères";
      }

      return null;
    },
    onChanged: onChanged,
    onSaved: onSaved,
  );
}

Widget buildVerifyPasswordField(
    String? value, String? verifyValue, Function(String?) onSaved) {
  return TextFormField(
      decoration: const InputDecoration(labelText: "Confirmation Mot de Passe"),
      obscureText: true,
      validator: (value) {
        if (value != verifyValue) {
          return "Les mots de passe doivent être identique";
        }
        return null;
      },
      onSaved: onSaved);
}
