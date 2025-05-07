# Installation de Flutter et Android Studio



# README

## Nature et objectif du projet

Macro-Meter est une application mobile développée avec Flutter. Elle permet aux utilisateurs de suivre et de gérer leur consommation de macronutriments (protéines, glucides, lipides) au quotidien. L'application est destinée a une large audience, telles que les sportifs, les personnes suivant un régime spécifique ou toute personne souhaitant surveiller son apport nutritionnel

## Technologies utilisées

- *Langages* : Dart
- *Framework* : Flutter
- *Base de données* : Firebase
- *Outils* : Android Studio, Git

## Fonctionnalités servies par le projet

Création et gestion de profils utilisateurs
Création de plans alimentaires personnalisés
Enregistrement des repas et des aliments consommés
Calcul automatique des macronutriments ingérés
Visualisation des statistiques quotidiennes et hebdomadaires


## Degré de complétion

Le projet est complété à environ *[xx]%* selon les objectifs fixés.

## Si incomplet, aspects restants à compléter

Par rapport au document de planification initial, il reste à compléter :

[Ex. Intégration de l'authentification]
[Ex. Connexion au serveur de production]
[Ex. Finalisation du responsive design]


## Bogues persistants

[Ex. Bug d'affichage sur mobile]
[Ex. Crash lors de la suppression d'un élément]
[Ex. Problèmes de synchronisation de données]


## Possibles améliorations

[Ex. Ajout d’un mode sombre]
[Ex. Optimisation du temps de chargement]
[Ex. Mise en place de tests unitaires]


## Procédure d'installation client

  Visitez [Méthode d'installation](https://github.com/AnthonyPageau/Macro-Meter/releases/tag/Release).
  Télécharger le fichier macro_meter.exe
  Excécuter le fichier téléchargé


## Procédure d'installation pour les développeurs

### 1. Installer Git
  [Git](https://gitforwindows.org/)

### 2. Flutter sur le site officiel
  Installer le fichier compresser de [FLutter](https://docs.flutter.dev/get-started/install/windows/mobile)

### 3. Extraire le fichier Zip
  Extraire le fichier zip et placer le dossier dans un chemin exemple: C:\src\flutter

### 4. Modfier PATH
  Ajouter aux variables d'utilisateur dans Path le chemin bin de flutter exemple: C:\src\flutter\bin 

### 5. Testter Flutter
  Ouvrir la command line et entrer flutter doctor

### 6. Installer Android Studio
  [Android Studio](https://developer.android.com/studio?gad_source=1&gclid=CjwKCAiAiOa9BhBqEiwABCdG81YEH2M0RaX77oQU2IVSGThOubhfEkn_6Q3HDqlTyT_Tj775iCpc8xoCCNAQAvD_BwE&gclsrc=aw.ds&hl=fr) Suivre les étapes d'installations avec la options par défaut
  Choisir Type d'insallation Custom
  S'assurer que Android SDK soit sélectionner
  S'assurer qu'une plateform SDK soit sélectionner
  S'assurer que Performance soit sélectionner
  S'assurer que Android Virtual Device soit sélectionner
  S'assurer que le chemin de SDK n'est pas de caractères spéciaux et ni d'espaces

### 7. Configuer Android Studio
  Dans More actions, sélectioner SDK Manager
  Dans Languages and Frameworks, dans l'onglet Android SDK, s'assurer que la dernière version stable soit sélectionné
  Dans le même onglet, aller dans SDK Tools, s'assurer que Build-Tools Command-line Tools et Platform-Tools soient sélectionnés
  Retourner dans More Actions, sélectionner Virtual Device Manager vous pouvez créer un émulateur du téléphone de votre choix

## Installation du projet

### 1. Cloner le projet

  Cloner le repository sur votre machine en utilisant Git :

  git clone https://github.com/AnthonyPageau/Macro-Meter.git

  cd macro-meter

### 2. Installer les packages manquant:
  Dans la command line du dossier du projet:
    1.flutter packages get
    
    2.flutter packages upgrade