import 'package:equatable/equatable.dart';

/// Entity User - Objet métier pur
/// C'est la représentation "propre" d'un utilisateur dans notre app
/// Pas de dépendance à l'API ou au cache
class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String? email;
  final String? city;
  final String? country;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    this.email,
    this.city,
    this.country,
  });

  /// Nom complet
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        avatarUrl,
        email,
        city,
        country,
      ];
}