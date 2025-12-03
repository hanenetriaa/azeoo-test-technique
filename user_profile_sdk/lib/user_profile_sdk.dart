library user_profile_sdk;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/core/config/service_locator.dart';
import 'src/presentation/screens/profile_screen.dart';

/// SDK User Profile
/// C'est le point d'entrée PUBLIC du SDK
/// Les apps externes n'ont accès qu'à cette classe
class UserProfileSDK {
  static bool _isInitialized = false;

  /// Initialise le SDK
  /// Doit être appelé UNE SEULE FOIS au démarrage de l'app
  static Future<void> initialize() async {
    if (_isInitialized) {
      print('⚠️  SDK déjà initialisé');
      return;
    }

    print('🚀 Initialisation du User Profile SDK...');
    
    // Setup des dépendances (Dio, Hive, repositories, etc.)
    await setupDependencies();
    
    _isInitialized = true;
    print('✅ SDK initialisé avec succès');
  }

  /// Affiche le profil d'un utilisateur
  /// 
  /// [context] : Le BuildContext de l'app appelante
  /// [userId] : L'ID de l'utilisateur à afficher
  /// 
  /// Exemple d'utilisation :
  /// ```dart
  /// UserProfileSDK.showUserProfile(context, userId: 1);
  /// ```
  static void showUserProfile(BuildContext context, {required int userId}) {
    if (!_isInitialized) {
      throw Exception(
        '❌ SDK non initialisé ! Appelez UserProfileSDK.initialize() d\'abord.',
      );
    }

    // Navigation vers l'écran de profil
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProviderScope(
          child: ProfileScreen(userId: userId),
        ),
      ),
    );
  }

  /// Affiche le profil en tant que widget standalone
  /// Utile pour l'intégrer dans une page existante
  static Widget buildProfileWidget({required int userId}) {
    if (!_isInitialized) {
      throw Exception(
        '❌ SDK non initialisé ! Appelez UserProfileSDK.initialize() d\'abord.',
      );
    }

    return ProviderScope(
      child: ProfileScreen(userId: userId),
    );
  }
}