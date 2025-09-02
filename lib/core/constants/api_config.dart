import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Configuration des API
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  // URLs des services
  static const String geminiBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  
  // Configuration des modèles
  static String get geminiTextModel => dotenv.env['GEMINI_TEXT_MODEL'] ?? 'gemini-2.0-flash-exp';
  static String get geminiImageModel => dotenv.env['GEMINI_IMAGE_MODEL'] ?? 'gemini-2.0-flash-exp';
  
  // Limites et quotas
  static int get maxRequestsPerMinute => int.tryParse(dotenv.env['MAX_REQUESTS_PER_MINUTE'] ?? '60') ?? 60;
  static int get maxTokensPerRequest => int.tryParse(dotenv.env['MAX_TOKENS_PER_REQUEST'] ?? '1024') ?? 1024;
  static Duration get requestTimeout => Duration(seconds: int.tryParse(dotenv.env['REQUEST_TIMEOUT_SECONDS'] ?? '30') ?? 30);
  
  // Configuration des prompts
  static const Map<String, String> prompts = {
    'dreamTitle': '''
Analyse ce rêve et génère un titre court et évocateur (maximum 5 mots) qui capture l'essence du rêve.

Rêve: {dreamContent}

Titre:''',
    
    'dreamSummary': '''
Analyse ce rêve et génère un résumé concis (2-3 phrases) qui capture les éléments clés et le sens du rêve.

Rêve: {dreamContent}

Résumé:''',
    
    'dreamAnalysis': '''
Analyse ce rêve et fournis une analyse structurée en JSON avec les éléments suivants:
- emotions: liste des émotions principales ressenties
- themes: liste des thèmes principaux du rêve
- symbols: liste des symboles importants
- interpretation: interprétation psychologique courte
- lucidity_indicators: indicateurs de lucidité si présents
- dream_type: type de rêve (normal, lucide, cauchemar, etc.)

Rêve: {dreamContent}

Réponds uniquement avec le JSON, sans texte supplémentaire.''',
    
    'dreamTags': '''
Analyse ce rêve et génère 3-5 tags pertinents qui décrivent les éléments principaux du rêve.
Les tags doivent être courts (1-2 mots) et en français.

Rêve: {dreamContent}

Tags (séparés par des virgules):''',
    
    'dreamImage': '''
Crée une image artistique et onirique qui représente ce rêve. L'image doit être:
- Mystérieuse et onirique
- Colorée avec des tons pastels et des couleurs vives
- Abstraite mais évocatrice
- Sans texte ni mots

Rêve: {dreamContent}''',
  };
  
  // Messages d'erreur
  static const Map<String, String> errorMessages = {
    'apiKeyMissing': 'Clé API manquante. Veuillez configurer votre clé Gemini.',
    'apiKeyInvalid': 'Clé API invalide. Vérifiez votre configuration.',
    'rateLimitExceeded': 'Limite de requêtes dépassée. Veuillez patienter.',
    'networkError': 'Erreur de réseau. Vérifiez votre connexion internet.',
    'timeoutError': 'Délai d\'attente dépassé. Veuillez réessayer.',
    'unknownError': 'Erreur inconnue. Veuillez réessayer plus tard.',
  };
  
  // Vérification de la configuration
  static bool get isConfigured => geminiApiKey.isNotEmpty && geminiApiKey != 'YOUR_GEMINI_API_KEY';
  
  // Obtenir un prompt formaté
  static String getFormattedPrompt(String promptKey, Map<String, String> variables) {
    String prompt = prompts[promptKey] ?? '';
    variables.forEach((key, value) {
      prompt = prompt.replaceAll('{$key}', value);
    });
    return prompt;
  }
}
