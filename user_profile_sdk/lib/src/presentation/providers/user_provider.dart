import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/service_locator.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/repositories/user_repository.dart';

/// Provider pour récupérer le profil utilisateur
/// FutureProvider.family permet de passer un paramètre (userId)
/// autoDispose libère automatiquement les ressources quand plus utilisé
final userProfileProvider = FutureProvider.family<User, int>((ref, userId) async {
  // Récupère le use case depuis get_it
  final getUserProfile = getIt<GetUserProfile>();
  
  // Exécute le use case
  return await getUserProfile(userId);
});

/// Provider pour le refresh
/// Permet de forcer le rafraîchissement du profil
final refreshUserProvider = FutureProvider.family<User, int>((ref, userId) async {
  final repository = getIt<UserRepository>();
  return await repository.refreshUserProfile(userId);
});