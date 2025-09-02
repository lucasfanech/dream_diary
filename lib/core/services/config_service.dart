import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class ConfigService {
  static bool _isInitialized = false;
  
  // Singleton pattern
  static final ConfigService _instance = ConfigService._internal();
  factory ConfigService() => _instance;
  ConfigService._internal();
  
  /// Initialise le service de configuration
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
      
      if (kDebugMode) {
        print('✅ Configuration chargée avec succès');
        print('🔑 Clé API configurée: ${_isApiKeyConfigured() ? "Oui" : "Non"}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Erreur lors du chargement de la configuration: $e');
        print('💡 Assurez-vous que le fichier .env existe et contient GEMINI_API_KEY');
      }
      rethrow;
    }
  }
  
  /// Vérifie si la clé API est configurée
  static bool _isApiKeyConfigured() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    return apiKey != null && apiKey.isNotEmpty && apiKey != 'YOUR_GEMINI_API_KEY';
  }
  
  /// Obtient une variable d'environnement
  static String getEnv(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }
  
  /// Obtient une variable d'environnement en tant qu'entier
  static int getEnvInt(String key, {int defaultValue = 0}) {
    final value = dotenv.env[key];
    return int.tryParse(value ?? '') ?? defaultValue;
  }
  
  /// Obtient une variable d'environnement en tant que booléen
  static bool getEnvBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key];
    return value?.toLowerCase() == 'true';
  }
  
  /// Vérifie si le service est initialisé
  static bool get isInitialized => _isInitialized;
  
  /// Vérifie si la clé API est configurée
  static bool get isApiKeyConfigured => _isApiKeyConfigured();
  
  /// Obtient toutes les variables d'environnement (pour debug)
  static Map<String, String> getAllEnvVars() {
    return Map.from(dotenv.env);
  }
}
