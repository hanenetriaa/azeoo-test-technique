import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/datasources/user_local_datasource.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../constants/api_constants.dart';

/// Service Locator global
/// C'est comme un annuaire : on enregistre tous nos services ici
final getIt = GetIt.instance;

/// Initialise toutes les dépendances
Future<void> setupDependencies() async {
  // ==================== CORE ====================
  
  // Dio (Client HTTP)
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectTimeout,
    receiveTimeout: ApiConstants.receiveTimeout,
    headers: {
      'Authorization': ApiConstants.authToken,
      'Accept-Language': ApiConstants.acceptLanguage,
    },
  ));
  
  // Logger pour voir les requêtes dans la console (utile pour debug)
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: false,
    responseBody: true,
    error: true,
  ));
  
  getIt.registerSingleton<Dio>(dio);
  
  // Hive (Cache local)
  await Hive.initFlutter();
  getIt.registerSingleton<HiveInterface>(Hive);
  
  // ==================== DATA SOURCES ====================
  
  // Remote (API)
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(getIt<Dio>()),
  );
  
  // Local (Cache)
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(getIt<HiveInterface>()),
  );
  
  // ==================== REPOSITORIES ====================
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: getIt<UserRemoteDataSource>(),
      localDataSource: getIt<UserLocalDataSource>(),
    ),
  );
  
  // ==================== USE CASES ====================
  
  getIt.registerLazySingleton<GetUserProfile>(
    () => GetUserProfile(getIt<UserRepository>()),
  );
}