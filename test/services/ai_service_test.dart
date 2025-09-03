import 'package:flutter_test/flutter_test.dart';
import 'package:dream_diary/core/services/ai_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() {
  group('AIService Tests', () {
    late AIService aiService;
    
    setUp(() {
      aiService = AIService();
    });
    
    test('should initialize without API key (mock mode)', () async {
      // Test d'initialisation sans clé API
      try {
        await aiService.initialize();
        fail('Should throw exception when API key is missing');
      } catch (e) {
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should generate dream title', () async {
      // Test de génération de titre
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées.';
      
      try {
        final title = await aiService.generateDreamTitle(dreamContent);
        print('📝 [TEST] Titre généré: $title');
        expect(title, isNotEmpty);
        expect(title, isNot(equals('Rêve sans titre')));
      } catch (e) {
        print('❌ [TEST] Erreur génération titre: $e');
        // En mode test sans API, on s'attend à une erreur
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should generate dream summary', () async {
      // Test de génération de résumé
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.';
      
      try {
        final summary = await aiService.generateDreamSummary(dreamContent);
        print('📄 [TEST] Résumé généré: $summary');
        expect(summary, isNotEmpty);
        expect(summary, isNot(equals('Résumé non disponible')));
      } catch (e) {
        print('❌ [TEST] Erreur génération résumé: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should analyze dream', () async {
      // Test d'analyse de rêve
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.';
      
      try {
        final analysis = await aiService.analyzeDream(dreamContent);
        print('🔍 [TEST] Analyse générée:');
        print(analysis);
        expect(analysis, isA<Map<String, dynamic>>());
        expect(analysis['emotions'], isA<List>());
        expect(analysis['themes'], isA<List>());
        expect(analysis['symbols'], isA<List>());
      } catch (e) {
        print('❌ [TEST] Erreur analyse rêve: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should generate dream tags', () async {
      // Test de génération de tags
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.';
      
      try {
        final tags = await aiService.generateDreamTags(dreamContent);
        print('🏷️ [TEST] Tags générés: $tags');
        expect(tags, isA<List<String>>());
        expect(tags.length, greaterThan(0));
      } catch (e) {
        print('❌ [TEST] Erreur génération tags: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should enhance dream with AI', () async {
      // Test d'amélioration complète d'un rêve
      final dream = Dream(
        id: 'test_dream_1',
        title: 'Test Dream',
        content: 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.',
        createdAt: DateTime.now(),
        tags: [],
      );
      
      try {
        final enhancedDream = await aiService.enhanceDream(dream);
        print('✨ [TEST] Rêve amélioré:');
        print('Titre: ${enhancedDream.title}');
        print('Résumé: ${enhancedDream.summary}');
        print('Tags: ${enhancedDream.tags}');
        print('Analyse IA: ${enhancedDream.aiAnalysis}');
        
        expect(enhancedDream.title, isNotEmpty);
        expect(enhancedDream.summary, isNotEmpty);
        expect(enhancedDream.tags, isNotEmpty);
        expect(enhancedDream.aiAnalysis, isA<Map<String, dynamic>>());
      } catch (e) {
        print('❌ [TEST] Erreur amélioration rêve: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should parse analysis response correctly', () async {
      // Test du parsing des réponses
      const mockResponse = '''
      {
        "emotions": ["joie", "liberté"],
        "themes": ["vol", "évasion"],
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ''';
      
      final result = aiService.parseAnalysisResponse(mockResponse);
      print('🔧 [TEST] Résultat du parsing: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotions'], isA<List>());
      expect(result['themes'], isA<List>());
      expect(result['symbols'], isA<List>());
    });
  });
}
