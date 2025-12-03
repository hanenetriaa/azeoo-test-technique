import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use Case : Récupérer le profil utilisateur
/// C'est une ACTION métier
/// Pourquoi un use case ? Pour isoler la logique métier et la rendre testable
class GetUserProfile {
  final UserRepository repository;

  GetUserProfile(this.repository);

  /// Exécute le use case
  /// On utilise call() pour pouvoir faire : useCase(userId) au lieu de useCase.execute(userId)
  Future<User> call(int userId) {
    return repository.getUserProfile(userId);
  }
}