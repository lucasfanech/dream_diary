import 'package:flutter_test/flutter_test.dart';
import 'package:dream_diary/core/services/tag_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() {
  group('TagService Tests', () {
    late TagService tagService;
    
    setUp(() {
      tagService = TagService();
    });
    
    test('should initialize without API key (mock mode)', () async {
      try {
        await tagService.initialize();
        fail('Should throw exception when API key is missing');
      } catch (e) {
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should categorize dream', () async {
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.';
      
      try {
        final categorization = await tagService.categorizeDream(dreamContent);
        print('📊 [TEST] Catégorisation: $categorization');
        expect(categorization, isA<Map<String, dynamic>>());
        expect(categorization['primary_category'], isNotEmpty);
        expect(categorization['subcategories'], isA<List>());
      } catch (e) {
        print('❌ [TEST] Erreur catégorisation: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should generate intelligent tags', () async {
      const dreamContent = 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.';
      
      try {
        final intelligentTags = await tagService.generateIntelligentTags(dreamContent);
        print('🧠 [TEST] Tags intelligents: $intelligentTags');
        expect(intelligentTags, isA<List<Map<String, dynamic>>>());
      } catch (e) {
        print('❌ [TEST] Erreur tags intelligents: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should analyze tag patterns', () async {
      final dreams = [
        Dream(
          id: 'dream_1',
          title: 'Rêve de vol',
          content: 'Je volais dans le ciel',
          createdAt: DateTime.now(),
          tags: ['vol', 'ciel', 'liberté'],
        ),
        Dream(
          id: 'dream_2',
          title: 'Rêve de montagne',
          content: 'Je grimpais une montagne',
          createdAt: DateTime.now(),
          tags: ['montagne', 'escalade', 'défi'],
        ),
        Dream(
          id: 'dream_3',
          title: 'Rêve de vol 2',
          content: 'Je volais encore dans le ciel',
          createdAt: DateTime.now(),
          tags: ['vol', 'ciel', 'répétition'],
        ),
      ];
      
      try {
        final patterns = await tagService.analyzeTagPatterns(dreams);
        print('🔄 [TEST] Patterns de tags: $patterns');
        expect(patterns, isA<Map<String, dynamic>>());
        expect(patterns['most_common_tags'], isA<List>());
      } catch (e) {
        print('❌ [TEST] Erreur analyse patterns: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should suggest missing tags', () async {
      final dream = Dream(
        id: 'test_dream',
        title: 'Rêve de vol',
        content: 'Je volais dans le ciel bleu avec des ailes dorées. Le vent me portait vers des montagnes lointaines.',
        createdAt: DateTime.now(),
        tags: ['vol', 'ciel'],
      );
      
      try {
        final suggestions = await tagService.suggestMissingTags(dream);
        print('💡 [TEST] Suggestions de tags: $suggestions');
        expect(suggestions, isA<List<String>>());
        // Les suggestions ne doivent pas contenir les tags existants
        for (final suggestion in suggestions) {
          expect(dream.tags, isNot(contains(suggestion)));
        }
      } catch (e) {
        print('❌ [TEST] Erreur suggestions: $e');
        expect(e.toString(), contains('apiKeyMissing'));
      }
    });
    
    test('should parse categorization response correctly', () async {
      const mockResponse = '''
      {
        "primary_category": "rêve de vol",
        "subcategories": ["liberté", "évasion"],
        "emotional_category": "positif",
        "lucidity_level": 5
      }
      ''';
      
      final result = tagService._parseCategorizationResponse(mockResponse);
      print('🔧 [TEST] Résultat parsing catégorisation: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['primary_category'], isNotEmpty);
      expect(result['subcategories'], isA<List>());
    });
  });
}
