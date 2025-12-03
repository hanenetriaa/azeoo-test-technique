import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_datasource.dart';
import '../datasources/user_remote_datasource.dart';

/// Implémentation du UserRepository
/// C'est ici qu'on orchestre le cache et l'API
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> getUserProfile(int userId) async {
    try {
      // STRATÉGIE CACHE-FIRST
      // 1. On vérifie d'abord le cache
      final cachedUser = await localDataSource.getCachedUser(userId);
      
      if (cachedUser != null) {
        // Cache trouvé ! On retourne immédiatement
        print('✅ User $userId chargé depuis le cache');
        return cachedUser.toEntity();
      }

      // 2. Pas de cache, on appelle l'API
      print('🌐 User $userId chargé depuis l\'API');
      final userModel = await remoteDataSource.getUserProfile(userId);

      // 3. On sauvegarde en cache pour la prochaine fois
      await localDataSource.cacheUser(userId, userModel);

      // 4. On retourne l'entity
      return userModel.toEntity();
    } catch (e) {
      // Si l'API échoue, on tente quand même le cache (même expiré)
      print('❌ Erreur: $e');
      final cachedUser = await localDataSource.getCachedUser(userId);
      if (cachedUser != null) {
        print('⚠️  Utilisation du cache expiré (mode dégradé)');
        return cachedUser.toEntity();
      }
      
      // Aucune donnée disponible
      rethrow;
    }
  }

  @override
  Future<User> refreshUserProfile(int userId) async {
    // Force le refresh depuis l'API (ignore le cache)
    print('🔄 Rafraîchissement forcé du user $userId');
    
    final userModel = await remoteDataSource.getUserProfile(userId);
    await localDataSource.cacheUser(userId, userModel);
    
    return userModel.toEntity();
  }
}