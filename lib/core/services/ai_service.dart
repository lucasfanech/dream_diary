import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';
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
Analyse ce rêve de manière approfondie et fournis une analyse structurée en JSON avec les éléments suivants:

{
  "emotions": ["liste des émotions principales avec intensité (0-10)"],
  "themes": ["thèmes principaux du rêve"],
  "symbols": ["symboles importants avec signification"],
  "interpretation": "interprétation psychologique détaillée basée sur Jung et Freud",
  "lucidity_indicators": ["indicateurs de lucidité si présents"],
  "dream_type": "type de rêve (normal, lucide, cauchemar, récurrent, prémonitoire)",
  "psychological_meaning": "signification psychologique profonde",
  "archetypes": ["archétypes jungiens présents"],
  "color_analysis": "analyse des couleurs mentionnées",
  "setting_analysis": "analyse du lieu et de l'environnement",
  "character_analysis": "analyse des personnages présents",
  "action_analysis": "analyse des actions et événements",
  "recurring_patterns": ["patterns récurrents identifiés"],
  "personal_growth": "aspects de développement personnel",
  "warnings": ["avertissements ou signaux d'alerte"],
  "recommendations": ["recommandations pour l'éveil"]
}

Rêve: $dreamContent

Réponds uniquement avec le JSON valide, sans texte supplémentaire.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      // Parser le JSON de réponse
      final responseText = response.text?.trim() ?? '{}';
      return parseAnalysisResponse(responseText);
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
      await _imageModel.generateContent(content);
      
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
Analyse ce rêve et génère 5-8 tags pertinents qui décrivent les éléments principaux du rêve.
Les tags doivent être courts (1-2 mots) et en français.
Inclus des tags pour: émotions, lieux, personnages, objets, actions, thèmes.

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

  // Analyser les symboles de manière approfondie
  Future<Map<String, dynamic>> analyzeSymbols(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse les symboles présents dans ce rêve selon les théories de Jung et Freud.
Fournis une analyse détaillée en JSON:

{
  "primary_symbols": [
    {
      "symbol": "nom du symbole",
      "meaning": "signification symbolique",
      "jungian_interpretation": "interprétation jungienne",
      "freudian_interpretation": "interprétation freudienne",
      "personal_relevance": "pertinence personnelle",
      "archetype": "archétype associé"
    }
  ],
  "color_symbols": "analyse des couleurs et leur symbolisme",
  "animal_symbols": "analyse des animaux présents",
  "object_symbols": "analyse des objets significatifs",
  "place_symbols": "analyse des lieux et environnements",
  "universal_symbols": ["symboles universels identifiés"],
  "personal_symbols": ["symboles personnels spécifiques"]
}

Rêve: $dreamContent

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return parseAnalysisResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse des symboles: $e');
    }
  }

  // Analyser les émotions de manière détaillée
  Future<Map<String, dynamic>> analyzeEmotions(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse les émotions présentes dans ce rêve de manière détaillée.
Fournis une analyse structurée en JSON:

{
  "primary_emotions": [
    {
      "emotion": "nom de l'émotion",
      "intensity": 8,
      "context": "contexte dans le rêve",
      "triggers": ["éléments déclencheurs"],
      "meaning": "signification de cette émotion"
    }
  ],
  "emotional_journey": "parcours émotionnel dans le rêve",
  "conflicting_emotions": ["émotions contradictoires"],
  "repressed_emotions": ["émotions refoulées détectées"],
  "emotional_patterns": ["patterns émotionnels récurrents"],
  "wake_life_connection": "connexion avec la vie éveillée",
  "emotional_growth": "aspects de croissance émotionnelle"
}

Rêve: $dreamContent

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return parseAnalysisResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse des émotions: $e');
    }
  }

  // Analyser les thèmes récurrents
  Future<Map<String, dynamic>> analyzeRecurringThemes(String dreamContent, List<Map<String, dynamic>> previousDreams) async {
    await _ensureInitialized();
    
    try {
      final previousContent = previousDreams.take(5).map((dream) => dream['content'] ?? '').join('\n---\n');
      
      final prompt = '''
Analyse ce nouveau rêve en le comparant avec les rêves précédents pour identifier les thèmes récurrents.
Fournis une analyse en JSON:

{
  "new_themes": ["nouveaux thèmes dans ce rêve"],
  "recurring_themes": [
    {
      "theme": "nom du thème",
      "frequency": 3,
      "evolution": "évolution du thème",
      "significance": "signification de la récurrence"
    }
  ],
  "theme_connections": "connexions entre les thèmes",
  "progression": "progression thématique observée",
  "breakthrough_themes": ["thèmes de percée ou de changement"],
  "stagnant_themes": ["thèmes stagnants ou bloqués"]
}

Nouveau rêve: $dreamContent

Rêves précédents:
$previousContent

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return parseAnalysisResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse des thèmes récurrents: $e');
    }
  }
  
  // Analyser un rêve complet avec analyses avancées
  Future<Dream> enhanceDream(Dream dream, {List<Dream>? previousDreams}) async {
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
      
      // Analyser le rêve de base
      final basicAnalysis = await analyzeDream(dream.content);
      
      // Analyses avancées
      final symbolAnalysis = await analyzeSymbols(dream.content);
      final emotionAnalysis = await analyzeEmotions(dream.content);
      
      // Analyse des thèmes récurrents si des rêves précédents sont fournis
      Map<String, dynamic>? recurringThemesAnalysis;
      if (previousDreams != null && previousDreams.isNotEmpty) {
        final previousDreamsData = previousDreams.map((d) => d.toJson()).toList();
        recurringThemesAnalysis = await analyzeRecurringThemes(dream.content, previousDreamsData);
      }
      
      // Combiner toutes les analyses
      dream.aiAnalysis = {
        ...basicAnalysis,
        'symbol_analysis': symbolAnalysis,
        'emotion_analysis': emotionAnalysis,
        if (recurringThemesAnalysis != null) 'recurring_themes': recurringThemesAnalysis,
        'analysis_timestamp': DateTime.now().toIso8601String(),
        'analysis_version': '3.0',
      };
      
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
  Map<String, dynamic> parseAnalysisResponse(String responseText) {
    print('🔍 [AI_SERVICE] Réponse brute de l\'IA:');
    print('=' * 50);
    print(responseText);
    print('=' * 50);
    
    try {
      // Nettoyer la réponse pour extraire le JSON
      String cleanResponse = responseText;
      if (cleanResponse.contains('```json')) {
        cleanResponse = cleanResponse.split('```json')[1].split('```')[0];
        print('🧹 [AI_SERVICE] JSON extrait des backticks:');
        print(cleanResponse);
      } else if (cleanResponse.contains('```')) {
        cleanResponse = cleanResponse.split('```')[1].split('```')[0];
        print('🧹 [AI_SERVICE] Contenu extrait des backticks:');
        print(cleanResponse);
      }
      
      // Essayer de parser le JSON réel
      try {
        print('🔧 [AI_SERVICE] Tentative de parsing JSON réel...');
        final parsedJson = jsonDecode(cleanResponse);
        print('✅ [AI_SERVICE] Parsing JSON réussi !');
        print('📊 [AI_SERVICE] Données parsées: $parsedJson');
        
        // Valider et enrichir la structure
        return _validateAndEnrichAnalysis(parsedJson, responseText);
      } catch (jsonError) {
        print('❌ [AI_SERVICE] Erreur de parsing JSON: $jsonError');
        print('⚠️ [AI_SERVICE] Utilisation de la structure par défaut');
        return _createDefaultAnalysis(responseText, error: jsonError.toString());
      }
    } catch (e) {
      print('❌ [AI_SERVICE] Erreur générale: $e');
      return _createDefaultAnalysis(responseText, error: e.toString());
    }
  }
  
  // Valider et enrichir l'analyse parsée
  Map<String, dynamic> _validateAndEnrichAnalysis(Map<String, dynamic> parsedJson, String rawResponse) {
    print('🔍 [AI_SERVICE] Validation et enrichissement de l\'analyse...');
    
    // Créer une structure complète avec des valeurs par défaut
    final enrichedAnalysis = {
      'emotions': _ensureList(parsedJson['emotions'], ['curiosité', 'émerveillement']),
      'themes': _ensureList(parsedJson['themes'], ['aventure', 'découverte']),
      'symbols': _ensureList(parsedJson['symbols'], ['vol', 'liberté']),
      'interpretation': parsedJson['interpretation'] ?? 'Ce rêve suggère un désir de liberté et d\'évasion.',
      'lucidity_indicators': _ensureList(parsedJson['lucidity_indicators'], []),
      'dream_type': parsedJson['dream_type'] ?? 'normal',
      'psychological_meaning': parsedJson['psychological_meaning'] ?? 'Signification psychologique à analyser',
      'archetypes': _ensureList(parsedJson['archetypes'], ['héros', 'sagesse']),
      'color_analysis': parsedJson['color_analysis'] ?? 'Analyse des couleurs en cours',
      'setting_analysis': parsedJson['setting_analysis'] ?? 'Analyse du lieu en cours',
      'character_analysis': parsedJson['character_analysis'] ?? 'Analyse des personnages en cours',
      'action_analysis': parsedJson['action_analysis'] ?? 'Analyse des actions en cours',
      'recurring_patterns': _ensureList(parsedJson['recurring_patterns'], []),
      'personal_growth': parsedJson['personal_growth'] ?? 'Aspects de croissance personnelle identifiés',
      'warnings': _ensureList(parsedJson['warnings'], []),
      'recommendations': _ensureList(parsedJson['recommendations'], ['Continuer à tenir un journal de rêves']),
      'raw_response': rawResponse,
      'parsed_successfully': true,
      'parsing_timestamp': DateTime.now().toIso8601String(),
    };
    
    print('✅ [AI_SERVICE] Analyse enrichie créée avec succès');
    print('📊 [AI_SERVICE] Champs enrichis: ${enrichedAnalysis.keys}');
    
    return enrichedAnalysis;
  }
  
  // S'assurer qu'une valeur est une liste
  List _ensureList(dynamic value, List defaultValue) {
    if (value is List) {
      return value;
    } else if (value is String) {
      return [value];
    } else {
      return defaultValue;
    }
  }
  
  // Créer une analyse par défaut
  Map<String, dynamic> _createDefaultAnalysis(String rawResponse, {String? error}) {
    print('⚠️ [AI_SERVICE] Création d\'une analyse par défaut');
    return {
      'emotions': ['curiosité', 'émerveillement'],
      'themes': ['aventure', 'découverte'],
      'symbols': ['vol', 'liberté'],
      'interpretation': 'Ce rêve suggère un désir de liberté et d\'évasion.',
      'lucidity_indicators': [],
      'dream_type': 'normal',
      'psychological_meaning': 'Signification psychologique à analyser',
      'archetypes': ['héros', 'sagesse'],
      'color_analysis': 'Analyse des couleurs en cours',
      'setting_analysis': 'Analyse du lieu en cours',
      'character_analysis': 'Analyse des personnages en cours',
      'action_analysis': 'Analyse des actions en cours',
      'recurring_patterns': [],
      'personal_growth': 'Aspects de croissance personnelle identifiés',
      'warnings': [],
      'recommendations': ['Continuer à tenir un journal de rêves'],
      'raw_response': rawResponse,
      'parsed_successfully': false,
      'parsing_timestamp': DateTime.now().toIso8601String(),
      if (error != null) 'error': error,
    };
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
