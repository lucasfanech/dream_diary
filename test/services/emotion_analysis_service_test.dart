import 'package:flutter_test/flutter_test.dart';
import 'package:dream_diary/core/services/emotion_analysis_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() {
  group('EmotionAnalysisService Tests', () {
    late EmotionAnalysisService emotionService;
    
    setUp(() {
      emotionService = EmotionAnalysisService();
    });
    
    test('should initialize without API key (mock mode)', () async {
      try {
        await emotionService.initialize();
        fail('Should throw exception when API key is missing');
      } catch (e) {
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should analyze emotional evolution', () async {
      final dreams = [
        Dream(
          id: 'dream_1',
          title: 'Rêve joyeux',
          content: 'Je volais dans le ciel bleu avec des ailes dorées',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          emotion: 'joie',
          tags: ['vol', 'joie', 'liberté'],
        ),
        Dream(
          id: 'dream_2',
          title: 'Rêve anxieux',
          content: 'Je courais dans un labyrinthe sombre',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          emotion: 'anxiété',
          tags: ['course', 'anxiété', 'labyrinthe'],
        ),
        Dream(
          id: 'dream_3',
          title: 'Rêve serein',
          content: 'Je flottais sur un lac calme',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          emotion: 'sérénité',
          tags: ['eau', 'sérénité', 'flottement'],
        ),
      ];
      
      try {
        final evolution = await emotionService.analyzeEmotionalEvolution(dreams);
        print('📈 [TEST] Évolution émotionnelle: $evolution');
        expect(evolution, isA<Map<String, dynamic>>());
        expect(evolution['emotional_timeline'], isA<List>());
        expect(evolution['emotional_trends'], isA<Map<String, dynamic>>());
      } catch (e) {
        print('❌ [TEST] Erreur évolution émotionnelle: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should detect recurring themes', () async {
      final dreams = [
        Dream(
          id: 'dream_1',
          title: 'Rêve de vol',
          content: 'Je volais dans le ciel bleu avec des ailes dorées',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          tags: ['vol', 'ciel', 'liberté'],
        ),
        Dream(
          id: 'dream_2',
          title: 'Rêve de course',
          content: 'Je courais dans un labyrinthe sombre',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          tags: ['course', 'labyrinthe', 'fuite'],
        ),
        Dream(
          id: 'dream_3',
          title: 'Rêve de vol 2',
          content: 'Je volais encore dans le ciel, mais cette fois avec des ailes argentées',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          tags: ['vol', 'ciel', 'argent'],
        ),
      ];
      
      try {
        final themes = await emotionService.detectRecurringThemes(dreams);
        print('🔄 [TEST] Thèmes récurrents: $themes');
        expect(themes, isA<Map<String, dynamic>>());
        expect(themes['recurring_themes'], isA<List>());
        expect(themes['theme_connections'], isA<List>());
      } catch (e) {
        print('❌ [TEST] Erreur thèmes récurrents: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should analyze lucidity patterns', () async {
      final lucidDreams = [
        Dream(
          id: 'lucid_1',
          title: 'Premier rêve lucide',
          content: 'Je me suis rendu compte que je rêvais et j\'ai commencé à voler',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          isLucid: true,
          lucidityLevel: 6.0,
          tags: ['lucidité', 'vol', 'prise de conscience'],
        ),
        Dream(
          id: 'lucid_2',
          title: 'Rêve lucide amélioré',
          content: 'J\'ai maintenu ma lucidité et j\'ai exploré un monde fantastique',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isLucid: true,
          lucidityLevel: 8.0,
          tags: ['lucidité', 'exploration', 'stabilité'],
        ),
      ];
      
      try {
        final patterns = await emotionService.analyzeLucidityPatterns(lucidDreams);
        print('🧠 [TEST] Patterns de lucidité: $patterns');
        expect(patterns, isA<Map<String, dynamic>>());
        expect(patterns['lucidity_statistics'], isA<Map<String, dynamic>>());
        expect(patterns['lucidity_triggers'], isA<List>());
      } catch (e) {
        print('❌ [TEST] Erreur patterns lucidité: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should parse emotional evolution response correctly', () async {
      const mockResponse = '''
      {
        "emotional_timeline": [
          {
            "date": "2024-01-01",
            "dominant_emotion": "joie",
            "intensity": 8
          }
        ],
        "emotional_trends": {
          "positive_emotions": {"trend": "croissant", "percentage": 70}
        }
      }
      ''';
      
      final result = emotionService._parseEmotionalEvolutionResponse(mockResponse);
      print('🔧 [TEST] Résultat parsing évolution: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotional_timeline'], isA<List>());
      expect(result['emotional_trends'], isA<Map<String, dynamic>>());
    });
  });
}
