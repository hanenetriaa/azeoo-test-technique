import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/constants/api_constants.dart';

/// Interface du Remote DataSource
abstract class UserRemoteDataSource {
  Future<UserModel> getUserProfile(int userId);
}

/// Implémentation du Remote DataSource
/// C'est ici qu'on fait les vrais appels API
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> getUserProfile(int userId) async {
    try {
      // Appel API avec le header X-User-Id
      final response = await dio.get(
        ApiConstants.usersMe,
        options: Options(
          headers: {
            'X-User-Id': userId.toString(),
          },
        ),
      );

      // Conversion JSON → UserModel
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      // Gestion des erreurs Dio
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout: Vérifiez votre connexion internet');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout: Le serveur ne répond pas');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Non autorisé: Token invalide');
      } else {
        throw Exception('Erreur réseau: ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur inattendue: $e');
    }
  }
}