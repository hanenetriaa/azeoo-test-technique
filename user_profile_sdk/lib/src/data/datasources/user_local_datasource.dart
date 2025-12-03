import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

/// Interface du Local DataSource
abstract class UserLocalDataSource {
  Future<UserModel?> getCachedUser(int userId);
  Future<void> cacheUser(int userId, UserModel user);
  Future<void> clearCache();
}

/// Implémentation du Local DataSource
/// C'est ici qu'on gère le cache local avec Hive
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final HiveInterface hive;
  static const String boxName = 'users_cache';

  UserLocalDataSourceImpl(this.hive);

  /// Récupère un utilisateur du cache
  @override
  Future<UserModel?> getCachedUser(int userId) async {
    try {
      final box = await hive.openBox<Map>(boxName);
      final cachedData = box.get(userId);
      
      if (cachedData == null) return null;
      
      // Vérifie si le cache est encore valide (moins de 5 minutes)
      final timestamp = cachedData['timestamp'] as int?;
      if (timestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        final difference = now.difference(cacheTime);
        
        // Si le cache a plus de 5 minutes, on le considère comme expiré
        if (difference.inMinutes > 5) {
          await box.delete(userId);
          return null;
        }
      }
      
      // Récupère les données utilisateur
      final userData = cachedData['data'] as Map<String, dynamic>;
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    } catch (e) {
      // En cas d'erreur, on retourne null (pas de cache)
      return null;
    }
  }

  /// Sauvegarde un utilisateur en cache
  @override
  Future<void> cacheUser(int userId, UserModel user) async {
    try {
      final box = await hive.openBox<Map>(boxName);
      
      // Sauvegarde avec un timestamp
      await box.put(userId, {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': user.toJson(),
      });
    } catch (e) {
      // En cas d'erreur, on ne fait rien (le cache n'est pas critique)
      print('Erreur lors de la sauvegarde en cache: $e');
    }
  }

  /// Efface tout le cache
  @override
  Future<void> clearCache() async {
    try {
      final box = await hive.openBox<Map>(boxName);
      await box.clear();
    } catch (e) {
      print('Erreur lors du nettoyage du cache: $e');
    }
  }
}