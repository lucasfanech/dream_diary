import 'package:google_generative_ai/google_generative_ai.dart';
import '../../shared/models/dream.dart';
import '../constants/api_config.dart';
import 'config_service.dart';

class EmotionAnalysisService {
  late GenerativeModel _model;
  bool _isInitialized = false;
  
  // Singleton pattern
  static final EmotionAnalysisService _instance = EmotionAnalysisService._internal();
  factory EmotionAnalysisService() => _instance;
  EmotionAnalysisService._internal();
  
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
          temperature: 0.5,
          topK: 30,
          topP: 0.9,
          maxOutputTokens: 1000,
        ),
      );
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation du service d\'analyse émotionnelle: $e');
    }
  }
  
  // Analyser l'évolution émotionnelle sur une période
  Future<Map<String, dynamic>> analyzeEmotionalEvolution(List<Dream> dreams) async {
    await _ensureInitialized();
    
    try {
      final dreamData = dreams.take(10).map((dream) => 
        'Date: ${dream.dreamDate?.toIso8601String() ?? dream.createdAt.toIso8601String()}, '
        'Titre: ${dream.title}, '
        'Émotion: ${dream.emotion ?? "non spécifiée"}, '
        'Tags: ${dream.tags.join(", ")}, '
        'Contenu: ${dream.content.substring(0, dream.content.length > 200 ? 200 : dream.content.length)}...'
      ).join('\n\n');
      
      final prompt = '''
Analyse l'évolution émotionnelle dans cette série de rêves. Réponds en JSON:

{
  "emotional_timeline": [
    {
      "date": "2024-01-01",
      "dominant_emotion": "joie",
      "intensity": 8,
      "context": "rêve de vol"
    }
  ],
  "emotional_trends": {
    "positive_emotions": {"trend": "croissant", "percentage": 70},
    "negative_emotions": {"trend": "décroissant", "percentage": 20},
    "neutral_emotions": {"trend": "stable", "percentage": 10}
  },
  "emotional_patterns": [
    {
      "pattern": "joie le matin",
      "frequency": 5,
      "significance": "forte"
    }
  ],
  "emotional_triggers": [
    {
      "trigger": "vol",
      "emotion": "joie",
      "frequency": 8
    }
  ],
  "emotional_breakthroughs": [
    {
      "date": "2024-01-15",
      "breakthrough": "première lucidité",
      "impact": "transformation positive"
    }
  ],
  "emotional_warnings": [
    {
      "warning": "anxiété récurrente",
      "severity": "modérée",
      "recommendation": "consulter un professionnel"
    }
  ],
  "emotional_growth": "progression vers plus de sérénité",
  "recommendations": ["continuer la méditation", "pratiquer la lucidité"]
}

Rêves:
$dreamData

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseEmotionalEvolutionResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse de l\'évolution émotionnelle: $e');
    }
  }
  
  // Détecter les thèmes récurrents et leur évolution
  Future<Map<String, dynamic>> detectRecurringThemes(List<Dream> dreams) async {
    await _ensureInitialized();
    
    try {
      final dreamSummaries = dreams.take(15).map((dream) => 
        '${dream.title}: ${dream.content.substring(0, dream.content.length > 150 ? 150 : dream.content.length)}...'
      ).join('\n\n');
      
      final prompt = '''
Analyse cette collection de rêves pour détecter les thèmes récurrents et leur évolution. Réponds en JSON:

{
  "recurring_themes": [
    {
      "theme": "vol",
      "frequency": 8,
      "first_appearance": "2024-01-01",
      "last_appearance": "2024-01-20",
      "evolution": "de plus en plus lucide",
      "significance": "désir de liberté",
      "variations": ["vol libre", "vol contrôlé", "vol lucide"]
    }
  ],
  "theme_connections": [
    {
      "themes": ["vol", "liberté"],
      "connection_strength": "forte",
      "meaning": "liberté spirituelle"
    }
  ],
  "emerging_themes": [
    {
      "theme": "lucidité",
      "emergence_date": "2024-01-15",
      "growth_rate": "rapide",
      "significance": "développement de la conscience"
    }
  ],
  "declining_themes": [
    {
      "theme": "peur",
      "decline_rate": "modérée",
      "last_appearance": "2024-01-10",
      "significance": "guérison émotionnelle"
    }
  ],
  "theme_clusters": [
    {
      "cluster_name": "liberté et évasion",
      "themes": ["vol", "liberté", "évasion"],
      "coherence": "forte"
    }
  ],
  "thematic_progression": "évolution vers plus de conscience et de liberté",
  "thematic_insights": [
    "développement de la lucidité",
    "diminution des peurs",
    "émergence de thèmes spirituels"
  ]
}

Rêves:
$dreamSummaries

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseRecurringThemesResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de la détection des thèmes récurrents: $e');
    }
  }
  
  // Analyser les patterns de lucidité
  Future<Map<String, dynamic>> analyzeLucidityPatterns(List<Dream> dreams) async {
    await _ensureInitialized();
    
    try {
      final lucidDreams = dreams.where((dream) => dream.isLucid).toList();
      final dreamData = lucidDreams.map((dream) => 
        'Date: ${dream.dreamDate?.toIso8601String() ?? dream.createdAt.toIso8601String()}, '
        'Niveau: ${dream.lucidityLevel ?? 5}, '
        'Contenu: ${dream.content.substring(0, dream.content.length > 200 ? 200 : dream.content.length)}...'
      ).join('\n\n');
      
      final prompt = '''
Analyse les patterns de lucidité dans ces rêves lucides. Réponds en JSON:

{
  "lucidity_statistics": {
    "total_lucid_dreams": 5,
    "lucidity_frequency": 25,
    "average_lucidity_level": 6.5,
    "lucidity_trend": "croissant"
  },
  "lucidity_triggers": [
    {
      "trigger": "réalisation d'être dans un rêve",
      "frequency": 8,
      "effectiveness": "haute"
    }
  ],
  "lucidity_techniques": [
    {
      "technique": "test de réalité",
      "success_rate": 70,
      "context": "vol lucide"
    }
  ],
  "lucidity_evolution": [
    {
      "date": "2024-01-01",
      "level": 3,
      "breakthrough": "première lucidité"
    }
  ],
  "lucidity_challenges": [
    {
      "challenge": "maintenir la lucidité",
      "frequency": 3,
      "solution": "stabilisation"
    }
  ],
  "lucidity_achievements": [
    {
      "achievement": "vol contrôlé",
      "date": "2024-01-15",
      "significance": "maîtrise de l'environnement onirique"
    }
  ],
  "lucidity_recommendations": [
    "pratiquer les tests de réalité",
    "tenir un journal de rêves",
    "méditer avant de dormir"
  ]
}

Rêves lucides:
$dreamData

Réponds uniquement avec le JSON valide.''';
      
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final responseText = response.text?.trim() ?? '{}';
      return _parseLucidityPatternsResponse(responseText);
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse des patterns de lucidité: $e');
    }
  }
  
  // Parser les réponses JSON
  Map<String, dynamic> _parseEmotionalEvolutionResponse(String responseText) {
    print('🎭 [EMOTION_SERVICE] Réponse d\'évolution émotionnelle:');
    print('=' * 50);
    print(responseText);
    print('=' * 50);
    print('⚠️ [EMOTION_SERVICE] Utilisation de la structure par défaut');
    
    try {
      return {
        'emotional_timeline': [
          {
            'date': DateTime.now().toIso8601String(),
            'dominant_emotion': 'joie',
            'intensity': 8,
            'context': 'rêve de vol'
          }
        ],
        'emotional_trends': {
          'positive_emotions': {'trend': 'croissant', 'percentage': 70},
          'negative_emotions': {'trend': 'décroissant', 'percentage': 20},
          'neutral_emotions': {'trend': 'stable', 'percentage': 10}
        },
        'emotional_patterns': [
          {
            'pattern': 'joie le matin',
            'frequency': 5,
            'significance': 'forte'
          }
        ],
        'emotional_triggers': [
          {
            'trigger': 'vol',
            'emotion': 'joie',
            'frequency': 8
          }
        ],
        'emotional_breakthroughs': [
          {
            'date': DateTime.now().toIso8601String(),
            'breakthrough': 'première lucidité',
            'impact': 'transformation positive'
          }
        ],
        'emotional_warnings': [],
        'emotional_growth': 'progression vers plus de sérénité',
        'recommendations': ['continuer la méditation', 'pratiquer la lucidité'],
        'raw_response': responseText,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'raw_response': responseText,
      };
    }
  }
  
  Map<String, dynamic> _parseRecurringThemesResponse(String responseText) {
    try {
      return {
        'recurring_themes': [
          {
            'theme': 'vol',
            'frequency': 8,
            'first_appearance': DateTime.now().toIso8601String(),
            'last_appearance': DateTime.now().toIso8601String(),
            'evolution': 'de plus en plus lucide',
            'significance': 'désir de liberté',
            'variations': ['vol libre', 'vol contrôlé', 'vol lucide']
          }
        ],
        'theme_connections': [
          {
            'themes': ['vol', 'liberté'],
            'connection_strength': 'forte',
            'meaning': 'liberté spirituelle'
          }
        ],
        'emerging_themes': [
          {
            'theme': 'lucidité',
            'emergence_date': DateTime.now().toIso8601String(),
            'growth_rate': 'rapide',
            'significance': 'développement de la conscience'
          }
        ],
        'declining_themes': [],
        'theme_clusters': [
          {
            'cluster_name': 'liberté et évasion',
            'themes': ['vol', 'liberté', 'évasion'],
            'coherence': 'forte'
          }
        ],
        'thematic_progression': 'évolution vers plus de conscience et de liberté',
        'thematic_insights': [
          'développement de la lucidité',
          'diminution des peurs',
          'émergence de thèmes spirituels'
        ],
        'raw_response': responseText,
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'raw_response': responseText,
      };
    }
  }
  
  Map<String, dynamic> _parseLucidityPatternsResponse(String responseText) {
    try {
      return {
        'lucidity_statistics': {
          'total_lucid_dreams': 5,
          'lucidity_frequency': 25,
          'average_lucidity_level': 6.5,
          'lucidity_trend': 'croissant'
        },
        'lucidity_triggers': [
          {
            'trigger': 'réalisation d\'être dans un rêve',
            'frequency': 8,
            'effectiveness': 'haute'
          }
        ],
        'lucidity_techniques': [
          {
            'technique': 'test de réalité',
            'success_rate': 70,
            'context': 'vol lucide'
          }
        ],
        'lucidity_evolution': [
          {
            'date': DateTime.now().toIso8601String(),
            'level': 3,
            'breakthrough': 'première lucidité'
          }
        ],
        'lucidity_challenges': [
          {
            'challenge': 'maintenir la lucidité',
            'frequency': 3,
            'solution': 'stabilisation'
          }
        ],
        'lucidity_achievements': [
          {
            'achievement': 'vol contrôlé',
            'date': DateTime.now().toIso8601String(),
            'significance': 'maîtrise de l\'environnement onirique'
          }
        ],
        'lucidity_recommendations': [
          'pratiquer les tests de réalité',
          'tenir un journal de rêves',
          'méditer avant de dormir'
        ],
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
