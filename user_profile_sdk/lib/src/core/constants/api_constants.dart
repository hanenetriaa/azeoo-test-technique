/// Constantes pour l'API AZEOO
class ApiConstants {
  // Base URL de l'API
  static const String baseUrl = 'https://api.azeoo.dev/v1';
  
  // Endpoints
  static const String usersMe = '/users/me';
  
  // Headers
  static const String authToken = 'Bearer api_474758da8532e795f63bc4e5e6beca7298379993f65bb861f2e8e13c352cc4dcebcc3b10961a5c369edb05fbc0b0053cf63df1c53d9ddd7e4e5d680beb514d20';
  static const String acceptLanguage = 'fr-FR';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
}