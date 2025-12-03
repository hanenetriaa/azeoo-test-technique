import '../entities/user.dart';

/// Interface du Repository User
/// C'est un CONTRAT : on définit ce que doit faire le repository
/// mais pas COMMENT il le fait (ça, c'est dans l'implémentation)
abstract class UserRepository {
  /// Récupère le profil d'un utilisateur par son ID
  /// Retourne un Future<User> car c'est asynchrone
  Future<User> getUserProfile(int userId);

  /// Rafraîchit le profil (force l'appel API)
  Future<User> refreshUserProfile(int userId);
}