import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Model User - Représentation JSON de l'API
/// C'est la structure exacte retournée par l'API AZEOO
@JsonSerializable()
class UserModel {
  final int id;
  
  @JsonKey(name: 'first_name')
  final String firstName;
  
  @JsonKey(name: 'last_name')
  final String lastName;
  
  final String? email;
  
  @JsonKey(name: 'city')
  final CityModel? cityModel;
  
  @JsonKey(name: 'country_code')
  final String? countryCode;
  
  final List<PictureModel> picture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.cityModel,
    this.countryCode,
    required this.picture,
  });

  /// Conversion JSON → UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Conversion UserModel → JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Conversion UserModel → User (Entity)
  /// C'est ici qu'on transforme les données API en objet métier propre
  User toEntity() {
    // Récupère l'image "large" de l'avatar
    final largeImage = picture.firstWhere(
      (p) => p.label == 'large',
      orElse: () => picture.first, // Fallback sur la première image
    );

    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: largeImage.url,
      email: email,
      city: cityModel?.value,
      country: countryCode,
    );
  }
}

/// Model pour la ville
@JsonSerializable()
class CityModel {
  final String value;
  final String permission;

  CityModel({
    required this.value,
    required this.permission,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

/// Model pour les images de profil
@JsonSerializable()
class PictureModel {
  final String url;
  final String label; // "thumbnail", "small", "large"

  PictureModel({
    required this.url,
    required this.label,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) => _$PictureModelFromJson(json);
  Map<String, dynamic> toJson() => _$PictureModelToJson(this);
}