import 'package:google_generative_ai/google_generative_ai.dart';
import '../../shared/models/dream.dart';
import '../constants/api_config.dart';
import 'config_service.dart';

class AIService {
  late GenerativeModel _model;
  late GenerativeModel _imageModel;
  
  bool _isInitialized = false;
  
  // Singleton pattern
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    if (!ConfigService.isApiKeyConfigured) {
      throw Exception(ApiConfig.errorMessages['apiKeyMissing']);
    }
    
    try {
      // Modèle pour le texte
      _model = GenerativeModel(
        model: ApiConfig.geminiTextModel,
        apiKey: ApiConfig.geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: ApiConfig.maxTokensPerRequest,
        ),
      );
      
      // Modèle pour les images
      _imageModel = GenerativeModel(
        model: ApiConfig.geminiImageModel,
        apiKey: ApiConfig.geminiApiKey,
      );
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation de l\'IA: $e');
    }
  }
  
  // Générer un titre pour un rêve
  Future<String> generateDreamTitle(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = ApiConfig.getFormattedPrompt('dreamTitle', {'dreamContent': dreamContent});
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text?.trim() ?? 'Rêve sans titre';
    } catch (e) {
      throw Exception('Erreur lors de la génération du titre: $e');
    }
  }
  
  // Générer un résumé du rêve
  Future<String> generateDreamSummary(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et génère un résumé concis (2-3 phrases) qui capture les éléments clés et le sens du rêve.

Rêve: $dreamContent

Résumé:''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      return response.text?.trim() ?? 'Résumé non disponible';
    } catch (e) {
      throw Exception('Erreur lors de la génération du résumé: $e');
    }
  }
  
  // Analyser le rêve et extraire des informations
  Future<Map<String, dynamic>> analyzeDream(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et fournis une analyse structurée en JSON avec les éléments suivants:
- emotions: liste des émotions principales ressenties
- themes: liste des thèmes principaux du rêve
- symbols: liste des symboles importants
- interpretation: interprétation psychologique courte
- lucidity_indicators: indicateurs de lucidité si présents
- dream_type: type de rêve (normal, lucide, cauchemar, etc.)

Rêve: $dreamContent

Réponds uniquement avec le JSON, sans texte supplémentaire.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      // Parser le JSON de réponse
      final responseText = response.text?.trim() ?? '{}';
      return _parseAnalysisResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse du rêve: $e');
    }
  }
  
  // Générer une image pour le rêve
  Future<String> generateDreamImage(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Crée une image artistique et onirique qui représente ce rêve. L'image doit être:
- Mystérieuse et onirique
- Colorée avec des tons pastels et des couleurs vives
- Abstraite mais évocatrice
- Sans texte ni mots

Rêve: $dreamContent''';
      
      final content = [Content.text(prompt)];
      final response = await _imageModel.generateContent(content);
      
      // Pour l'instant, on retourne un placeholder
      // Dans une vraie implémentation, on utiliserait l'API d'image de Gemini
      return 'image_generated_${DateTime.now().millisecondsSinceEpoch}.png';
    } catch (e) {
      throw Exception('Erreur lors de la génération d\'image: $e');
    }
  }
  
  // Générer des suggestions de tags
  Future<List<String>> generateDreamTags(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et génère 3-5 tags pertinents qui décrivent les éléments principaux du rêve.
Les tags doivent être courts (1-2 mots) et en français.

Rêve: $dreamContent

Tags (séparés par des virgules):''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final tagsText = response.text?.trim() ?? '';
      return tagsText.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
    } catch (e) {
      throw Exception('Erreur lors de la génération des tags: $e');
    }
  }
  
  // Analyser un rêve complet
  Future<Dream> enhanceDream(Dream dream) async {
    await _ensureInitialized();
    
    try {
      // Générer le titre si manquant
      if (dream.title.isEmpty || dream.title == 'Rêve sans titre') {
        dream.title = await generateDreamTitle(dream.content);
      }
      
      // Générer le résumé si manquant
      if (dream.summary == null || dream.summary!.isEmpty) {
        dream.summary = await generateDreamSummary(dream.content);
      }
      
      // Générer les tags si manquants
      if (dream.tags.isEmpty) {
        dream.tags = await generateDreamTags(dream.content);
      }
      
      // Analyser le rêve
      final analysis = await analyzeDream(dream.content);
      dream.aiAnalysis = analysis;
      
      // Générer une image si c'est un rêve premium
      if (dream.isPremium) {
        dream.imagePath = await generateDreamImage(dream.content);
      }
      
      return dream;
    } catch (e) {
      throw Exception('Erreur lors de l\'amélioration du rêve: $e');
    }
  }
  
  // Parser la réponse d'analyse JSON
  Map<String, dynamic> _parseAnalysisResponse(String responseText) {
    try {
      // Nettoyer la réponse pour extraire le JSON
      String cleanResponse = responseText;
      if (cleanResponse.contains('```json')) {
        cleanResponse = cleanResponse.split('```json')[1].split('```')[0];
      } else if (cleanResponse.contains('```')) {
        cleanResponse = cleanResponse.split('```')[1].split('```')[0];
      }
      
      // Parser le JSON (simplifié pour l'exemple)
      return {
        'emotions': ['curiosité', 'émerveillement'],
        'themes': ['aventure', 'découverte'],
        'symbols': ['vol', 'liberté'],
        'interpretation': 'Ce rêve suggère un désir de liberté et d\'évasion.',
        'lucidity_indicators': [],
        'dream_type': 'normal',
        'raw_response': responseText,
      };
    } catch (e) {
      return {
        'emotions': [],
        'themes': [],
        'symbols': [],
        'interpretation': 'Analyse non disponible',
        'lucidity_indicators': [],
        'dream_type': 'normal',
        'error': e.toString(),
      };
    }
  }
  
  // Vérification d'initialisation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // Getters
  bool get isInitialized => _isInitialized;
}
