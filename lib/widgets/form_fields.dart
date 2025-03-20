import 'package:flutter/material.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/plan.dart';

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
  return DropdownButtonFormField<String>(
    hint: Text("Sexe"),
    value: value,
    validator: (value) {
      if (value == null) {
        return "Vous devez choisir une option";
      }
    },
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
  return DropdownButtonFormField<String>(
    hint: Text("Objectif"),
    value: value,
    validator: (value) {
      if (value == null) {
        return "Vous devez choisir une option";
      }
    },
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

Widget buildMacroField(num? value, String? label, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "$label :"),
    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
    autocorrect: false,
    initialValue: value.toString(),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "$label ne peut pas être vide";
      }

      if (num.tryParse(value) == null) {
        return "$label doit être un nombre";
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildCategoryField(
    AlimentCategory? value, Function(AlimentCategory?) onChanged) {
  return DropdownButtonFormField<AlimentCategory>(
    hint: Text("Categorie"),
    value: value,
    validator: (value) {
      if (value == null) {
        return "Vous devez choisir une valeur";
      }
    },
    items: AlimentCategory.values.map((AlimentCategory type) {
      return DropdownMenuItem<AlimentCategory>(
        value: type,
        child: Text(_categoryToString(type)),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

String _categoryToString(AlimentCategory type) {
  switch (type) {
    case AlimentCategory.protein:
      return "Protéines";
    case AlimentCategory.fruitsAndVegetable:
      return "Fruits/légumes";
    case AlimentCategory.dairy:
      return "Produits laitier";
    case AlimentCategory.cereal:
      return "Céréales";
    case AlimentCategory.other:
      return "Autres";
  }
}

Widget buildUnitField(AlimentUnit? value, Function(AlimentUnit?) onChanged) {
  return DropdownButtonFormField<AlimentUnit>(
    hint: Text("Unité"),
    value: value,
    validator: (value) {
      if (value == null) {
        return "Vous devez choisir une option";
      }
    },
    items: AlimentUnit.values.map((AlimentUnit type) {
      return DropdownMenuItem<AlimentUnit>(
        value: type,
        child: Text(_unitToString(type)),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

String _unitToString(AlimentUnit type) {
  switch (type) {
    case AlimentUnit.grams:
      return "Gramme";
    case AlimentUnit.ml:
      return "mL";
    case AlimentUnit.cup:
      return "Tasse";
    case AlimentUnit.tbsp:
      return "Tbsp";
    case AlimentUnit.tsp:
      return "Tsp";
    case AlimentUnit.ounces:
      return "Once";
    case AlimentUnit.item:
      return "Portion";
  }
}

Widget buildAlimentNameField(String? value, String? initialValue,
    List<Aliment> aliments, String? alimentId, Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Nom :"),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Le Nom ne peut pas être vide";
      }
      if (alimentId == null) {
        if (aliments.any(
            (aliment) => aliment.name.toUpperCase() == value.toUpperCase())) {
          return "Cet aliment existe déjà";
        }
      } else {
        if (aliments.any((aliment) =>
            aliment.name.toUpperCase() == value.toUpperCase() &&
            aliment.id != alimentId)) {
          return "Cet aliment existe déjà";
        }
      }
      return null;
    },
    onSaved: onSaved,
  );
}

Widget buildPlanNameField(String? value, String? initialValue, List<Plan> plans,
    Function(String?) onSaved) {
  return TextFormField(
    decoration: InputDecoration(labelText: "Nom :"),
    autocorrect: false,
    initialValue: initialValue,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Le Nom ne peut pas être vide";
      }
      if (plans.any((plan) => plan.name.toUpperCase() == value.toUpperCase())) {
        return "Ce plan existe déjà";
      }
      return null;
    },
    onSaved: onSaved,
  );
}
