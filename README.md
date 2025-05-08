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
Visualisation des statistiques des macronutriments ingérés


## Degré de complétion

Le projet est complété à 100%

## Bogues persistants
  - Vidéo explicative ne fonctionne pas avec l'exécutable


## Possibles améliorations

  - Ajouter plus de statistiques
  - Proposer des plans préconçus en fonction des objectifs
  - Agrandir la banque d'aliments de base


## Procédure d'installation client

  - Visitez [Méthode d'installation](https://github.com/AnthonyPageau/Macro-Meter/releases).
  - Télécharger le fichier macro_meter.exe
  - Excécuter le fichier téléchargé


## Procédure d'installation pour les développeurs

## 🛠️ Prérequis

### 1. Installer Git
Télécharger et installer [Git](https://gitforwindows.org/).

### 2. Télécharger Flutter
Télécharger l'archive depuis le site officiel :  
[Flutter - Installation Windows](https://docs.flutter.dev/get-started/install/windows/mobile)

### 3. Extraire Flutter
Extraire le fichier `.zip` et placer le dossier dans un chemin **sans espaces ni caractères spéciaux**, par exemple :  
`C:\src\flutter`

### 4. Ajouter Flutter au PATH
Ajouter le chemin suivant aux **variables d'environnement utilisateur** :  
`C:\src\flutter\bin`

### 5. Tester Flutter
Ouvrir une ligne de commande et exécuter : 
flutter doctor

## 💻 Installer Android Studio

### 6. Installation
Télécharger et installer [Android Studio](https://developer.android.com/studio?hl=fr).  
Pendant l'installation :
- Choisir **Custom Installation**
- Vérifier que les options suivantes sont cochées :
  - Android SDK
  - Une version de plateforme SDK
  - Performance (Intel HAXM ou autre)
  - Android Virtual Device (AVD)
- ⚠️ Assurez-vous que le **chemin d'installation du SDK ne contient ni espaces ni caractères spéciaux**

### 7. Configuration d’Android Studio
1. Aller dans **More Actions > SDK Manager**  
   - Onglet **SDK Platforms** : vérifier que la dernière version stable est sélectionnée  
   - Onglet **SDK Tools** : cocher :
     - Android SDK Build-Tools  
     - Command-line Tools  
     - Platform-Tools  
2. Aller dans **More Actions > Virtual Device Manager**  
   - Créez un nouvel émulateur Android de votre choix

## Installation du projet

### 1. Cloner le projet

  - Cloner le repository sur votre machine en utilisant Git :

  - git clone https://github.com/AnthonyPageau/Macro-Meter.git

  - cd macro-meter

### 2. Installer les packages manquant:
  - Dans la command line du dossier du projet:
    - flutter packages get
    - flutter packages upgrade
   
### 3. Connextion à Macro-Meter
  - Vous pouvez utilisé ce compte ou bien vous en créer un directement:
    - Courriel: admin@admin.com
    - Mot de passe: 123456
