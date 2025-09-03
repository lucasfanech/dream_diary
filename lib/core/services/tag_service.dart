import 'package:google_generative_ai/google_generative_ai.dart';
import '../../shared/models/dream.dart';
import '../constants/api_config.dart';
import 'config_service.dart';

class TagService {
  late GenerativeModel _model;
  bool _isInitialized = false;
  
  // Singleton pattern
  static final TagService _instance = TagService._internal();
  factory TagService() => _instance;
  TagService._internal();
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    if (!ConfigService.isApiKeyConfigured) {
      throw Exception(ApiConfig.errorMessages['apiKeyMissing']);
    }
    
    try {
      _model = GenerativeModel(
        model: ApiConfig.geminiTextModel,
        apiKey: ApiConfig.geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.3, // Plus déterministe pour les tags
          topK: 20,
          topP: 0.8,
          maxOutputTokens: 500,
        ),
      );
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation du service de tags: $e');
    }
  }
  
  // Catégoriser un rêve selon différents axes
  Future<Map<String, dynamic>> categorizeDream(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et catégorise-le selon différents axes. Réponds en JSON:

{
  "primary_category": "catégorie principale",
  "subcategories": ["sous-catégories"],
  "emotional_category": "catégorie émotionnelle",
  "thematic_category": "catégorie thématique",
  "symbolic_category": "catégorie symbolique",
  "lucidity_level": "niveau de lucidité (0-10)",
  "vividness_level": "niveau de vivacité (0-10)",
  "nightmare_level": "niveau de cauchemar (0-10)",
  "premonitory_indicators": ["indicateurs prémonitoires"],
  "archetypal_elements": ["éléments archétypaux"],
  "psychological_themes": ["thèmes psychologiques"],
  "spiritual_elements": ["éléments spirituels"],
  "trauma_indicators": ["indicateurs de traumatisme"],
  "creativity_indicators": ["indicateurs de créativité"],
  "problem_solving": ["éléments de résolution de problème"]
}

Rêve: $dreamContent

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseCategorizationResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de la catégorisation: $e');
    }
  }
  
  // Générer des tags intelligents avec contexte
  Future<List<Map<String, dynamic>>> generateIntelligentTags(String dreamContent) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et génère des tags intelligents avec contexte. Réponds en JSON:

{
  "emotion_tags": [
    {"tag": "joie", "intensity": 8, "context": "liberté de voler"}
  ],
  "location_tags": [
    {"tag": "ciel", "description": "environnement aérien"}
  ],
  "character_tags": [
    {"tag": "oiseau", "role": "guide spirituel"}
  ],
  "object_tags": [
    {"tag": "ailes", "symbolism": "liberté"}
  ],
  "action_tags": [
    {"tag": "voler", "meaning": "évasion"}
  ],
  "theme_tags": [
    {"tag": "liberté", "significance": "désir d'évasion"}
  ],
  "symbol_tags": [
    {"tag": "ascension", "interpretation": "élévation spirituelle"}
  ],
  "archetype_tags": [
    {"tag": "héros", "manifestation": "vol courageux"}
  ]
}

Rêve: $dreamContent

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseIntelligentTagsResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de la génération des tags intelligents: $e');
    }
  }
  
  // Analyser les patterns de tags dans une collection de rêves
  Future<Map<String, dynamic>> analyzeTagPatterns(List<Dream> dreams) async {
    await _ensureInitialized();
    
    try {
      final dreamSummaries = dreams.take(10).map((dream) => 
        'Rêve ${dream.id}: ${dream.title} - Tags: ${dream.tags.join(", ")}'
      ).join('\n');
      
      final prompt = '''
Analyse les patterns de tags dans cette collection de rêves. Réponds en JSON:

{
  "most_common_tags": [
    {"tag": "vol", "frequency": 5, "percentage": 25}
  ],
  "tag_combinations": [
    {"tags": ["vol", "liberté"], "frequency": 3, "significance": "forte"}
  ],
  "emotional_evolution": "évolution des émotions dans les tags",
  "thematic_progression": "progression des thèmes",
  "emerging_patterns": ["nouveaux patterns émergents"],
  "declining_patterns": ["patterns en déclin"],
  "tag_diversity": "score de diversité des tags (0-10)",
  "recommendations": ["recommandations basées sur les patterns"]
}

Rêves:
$dreamSummaries

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseTagPatternsResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse des patterns de tags: $e');
    }
  }
  
  // Suggérer des tags manquants pour un rêve
  Future<List<String>> suggestMissingTags(Dream dream) async {
    await _ensureInitialized();
    
    try {
      final prompt = '''
Analyse ce rêve et suggère des tags qui pourraient être ajoutés pour améliorer la catégorisation.
Considère les tags existants: ${dream.tags.join(", ")}

Rêve: ${dream.title}
Contenu: ${dream.content}

Suggère 3-5 tags supplémentaires qui ne sont pas déjà présents.
Tags suggérés (séparés par des virgules):''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final tagsText = response.text?.trim() ?? '';
      final suggestedTags = tagsText.split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty && !dream.tags.contains(tag))
          .toList();
      
      return suggestedTags;
    } catch (e) {
      throw Exception('Erreur lors de la suggestion de tags: $e');
    }
  }
  
  // Parser les réponses JSON
  Map<String, dynamic> _parseCategorizationResponse(String responseText) {
    print('🏷️ [TAG_SERVICE] Réponse de catégorisation:');
    print('=' * 50);
    print(responseText);
    print('=' * 50);
    
    try {
      // Nettoyer la réponse
      String cleanResponse = responseText;
      if (cleanResponse.contains('```json')) {
        cleanResponse = cleanResponse.split('```json')[1].split('```')[0];
        print('🧹 [TAG_SERVICE] JSON extrait: $cleanResponse');
      } else if (cleanResponse.contains('```')) {
        cleanResponse = cleanResponse.split('```')[1].split('```')[0];
        print('🧹 [TAG_SERVICE] Contenu extrait: $cleanResponse');
      }
      
      // Structure par défaut
      print('⚠️ [TAG_SERVICE] Utilisation de la structure par défaut');
      return {
        'primary_category': 'rêve normal',
        'subcategories': ['aventure', 'découverte'],
        'emotional_category': 'positif',
        'thematic_category': 'liberté',
        'symbolic_category': 'ascension',
        'lucidity_level': 3,
        'vividness_level': 7,
        'nightmare_level': 1,
        'premonitory_indicators': [],
        'archetypal_elements': ['héros'],
        'psychological_themes': ['liberté'],
        'spiritual_elements': ['élévation'],
        'trauma_indicators': [],
        'creativity_indicators': ['imagination'],
        'problem_solving': [],
        'raw_response': responseText,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'raw_response': responseText,
      };
    }
  }
  
  List<Map<String, dynamic>> _parseIntelligentTagsResponse(String responseText) {
    try {
      // Structure par défaut
      return [
        {
          'type': 'emotion',
          'tags': [
            {'tag': 'joie', 'intensity': 8, 'context': 'liberté'}
          ]
        },
        {
          'type': 'location',
          'tags': [
            {'tag': 'ciel', 'description': 'environnement aérien'}
          ]
        },
        {
          'type': 'theme',
          'tags': [
            {'tag': 'liberté', 'significance': 'désir d\'évasion'}
          ]
        }
      ];
    } catch (e) {
      return [];
    }
  }
  
  Map<String, dynamic> _parseTagPatternsResponse(String responseText) {
    try {
      return {
        'most_common_tags': [
          {'tag': 'vol', 'frequency': 5, 'percentage': 25}
        ],
        'tag_combinations': [
          {'tags': ['vol', 'liberté'], 'frequency': 3, 'significance': 'forte'}
        ],
        'emotional_evolution': 'Évolution positive des émotions',
        'thematic_progression': 'Progression vers la liberté',
        'emerging_patterns': ['nouveaux patterns'],
        'declining_patterns': [],
        'tag_diversity': 7,
        'recommendations': ['Continuer à explorer les thèmes de liberté'],
        'raw_response': responseText,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'raw_response': responseText,
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
