Test Technique AZEOO – SDK User Profile

Développement d’un SDK Flutter permettant d’afficher un profil utilisateur, puis intégration dans une application React Native.

-- Table des matières

Présentation

Architecture

Technologies utilisées

Structure du projet

Installation

Fonctionnalités

Choix techniques

Points forts

Limitations

Captures d’écran

Auteur

-- Présentation

Ce test technique avait pour objectif de créer un SDK Flutter affichant les informations d’un utilisateur, et de l’intégrer ensuite dans une application React Native composée de deux onglets.

Résultats principaux :

SDK Flutter fonctionnel, modulable et organisé

Architecture inspirée de la Clean Architecture

State management avec Riverpod

Mise en cache des données (Hive)

Intégration API avec gestion des erreurs

App React Native simple et claire :

Onglet 1 → saisie de l’ID utilisateur

Onglet 2 → affichage du profil correspondant

-- Architecture

L’organisation du code suit une logique clairement séparée entre la logique métier, la gestion des données et l’affichage.

Structure du SDK Flutter
lib/
├── src/
│   ├── core/            # Config, constantes et outils
│   ├── domain/          # Logique métier (entities, usecases)
│   ├── data/            # Modèles, repositories, datasources
│   └── presentation/    # UI + state management
│
└── user_profile_sdk.dart

Cycle de récupération des données
UI
→ Provider Riverpod
→ UseCase
→ Repository (interface)
→ Repository (implémentation)
→ API / Cache
→ Retour modèle → UI

-- Technologies utilisées
Flutter

Riverpod (state)

Dio (HTTP)

Hive (cache)

get_it (injection)

json_serializable

cached_network_image

React Native

React Navigation (tabs)

Context API (partage état)

TypeScript

Expo

📁 Structure du projet global
test-technique/
├── user_profile_sdk/
├── test_flutter_app/
├── AzeoApp/           # App React Native
└── README.md

💻 Installation
1. Pré-requis

Flutter 3.38+

Node.js 18+

Android Studio ou émulateur

VS Code recommandé

2. Installer le SDK Flutter
cd user_profile_sdk
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

3. Installer l'application React Native
cd ../AzeoApp
npm install

4. Lancer les applications
Flutter
cd test_flutter_app
flutter run

React Native
npm run android

✨ Fonctionnalités
SDK Flutter

Affichage des informations utilisateur :
avatar, prénom, nom, email, ville, pays, ID.

Gestion du chargement / erreurs

Refresh des données

Cache automatique (5 minutes)

Stratégie cache-first

Intégration React Native

Onglet de saisie de l’ID utilisateur

Réutilisation instantanée de l’ID dans l’onglet profil

Appels API

Gestion des états

Design inspiré d’Azeoo

- Choix techniques
Pourquoi Riverpod ?

State management clair

Bonne scalabilité

Facile à tester

Rebuilds contrôlés

Pourquoi Clean Architecture ?

Facilite la réutilisation du code

Permet de tester chaque couche séparément

Rend le SDK plus évolutif

Pourquoi Dio ?

Intercepteurs

Retry + timeout

Gestion avancée des erreurs

Pourquoi Hive ?

Très rapide

Simple à intégrer

Parfait pour mettre en cache des petites données

- Points forts

Architecture propre et lisible

Dépendances injectées proprement

Repository pattern respecté

Cache rapide et efficace

UI claire et cohérente

Code facilement maintenable

App React Native bien structurée


-- Captures d’écran

Dossier : screenshots/


- Auteur

Hanene Triaa
Étudiante en Master 2 – Epitech
hanene.triaa@epitech.eu

-- Remerciements

Merci à l’équipe AZEOO pour ce test technique très formateur.
Cela m’a permis de :

structurer un SDK de A à Z

améliorer mon architecture Flutter

découvrir l’intégration Flutter ↔ React Native

travailler sur un design cohérent
