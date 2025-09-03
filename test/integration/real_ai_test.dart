import 'package:flutter_test/flutter_test.dart';
import 'package:dream_diary/core/services/ai_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() {
  group('Real AI Integration Tests', () {
    late AIService aiService;
    
    setUp(() {
      aiService = AIService();
    });
    
    test('should work with real API key (if configured)', () async {
      print('🚀 [REAL_AI_TEST] Test avec vraie clé API (si configurée)');
      
      // Créer un rêve de test
      final testDream = Dream(
        id: 'real_test_dream',
        title: 'Test Dream',
        content: '''
        Je volais dans un ciel bleu infini avec des ailes dorées étincelantes. 
        Le vent me portait doucement vers des montagnes lointaines couvertes de neige. 
        En dessous de moi, je voyais des forêts verdoyantes et des lacs cristallins. 
        Je me sentais libre et en paix, comme si j'étais enfin chez moi.
        ''',
        createdAt: DateTime.now(),
        tags: [],
      );
      
      try {
        // Tenter d'initialiser le service
        await aiService.initialize();
        print('✅ [REAL_AI_TEST] Service initialisé avec succès');
        
        // Tester l'amélioration du rêve
        print('🔍 [REAL_AI_TEST] Test d\'amélioration du rêve...');
        final enhancedDream = await aiService.enhanceDream(testDream);
        
        print('✅ [REAL_AI_TEST] Rêve amélioré avec succès !');
        print('📝 [REAL_AI_TEST] Titre: ${enhancedDream.title}');
        print('📄 [REAL_AI_TEST] Résumé: ${enhancedDream.summary}');
        print('🏷️ [REAL_AI_TEST] Tags: ${enhancedDream.tags}');
        print('🔍 [REAL_AI_TEST] Analyse IA: ${enhancedDream.aiAnalysis}');
        
        // Vérifications
        expect(enhancedDream.title, isNotEmpty);
        expect(enhancedDream.summary, isNotEmpty);
        expect(enhancedDream.tags, isNotEmpty);
        expect(enhancedDream.aiAnalysis, isA<Map<String, dynamic>>());
        
        // Vérifier que l'analyse a été parsée avec succès
        if (enhancedDream.aiAnalysis != null) {
          final analysis = enhancedDream.aiAnalysis!;
          expect(analysis['parsed_successfully'], isTrue);
          expect(analysis['emotions'], isA<List>());
          expect(analysis['themes'], isA<List>());
          expect(analysis['symbols'], isA<List>());
          expect(analysis['interpretation'], isA<String>());
          
          print('🎉 [REAL_AI_TEST] Analyse IA complète et valide !');
        }
        
      } catch (e) {
        print('❌ [REAL_AI_TEST] Erreur (probablement pas de clé API): $e');
        
        // Si c'est une erreur de clé API manquante, c'est normal
        if (e.toString().contains('apiKeyMissing') || 
            e.toString().contains('NotInitializedError')) {
          print('ℹ️ [REAL_AI_TEST] Test ignoré - Pas de clé API configurée');
          return;
        }
        
        // Sinon, c'est une vraie erreur
        rethrow;
      }
    });
    
    test('should parse different types of AI responses', () async {
      print('🔧 [REAL_AI_TEST] Test de parsing de différents types de réponses');
      
      // Test 1: Réponse simple
      const simpleResponse = '''
      {
        "emotions": ["joie", "liberté"],
        "themes": ["vol", "évasion"],
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ''';
      
      final simpleResult = aiService.parseAnalysisResponse(simpleResponse);
      print('✅ [REAL_AI_TEST] Réponse simple parsée: ${simpleResult['parsed_successfully']}');
      expect(simpleResult['parsed_successfully'], isTrue);
      
      // Test 2: Réponse avec backticks
      const responseWithBackticks = '''
      Voici l'analyse de votre rêve:
      
      ```json
      {
        "emotions": ["joie", "liberté"],
        "themes": ["vol", "évasion"],
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ```
      
      Cette analyse vous aide à comprendre votre subconscient.
      ''';
      
      final backticksResult = aiService.parseAnalysisResponse(responseWithBackticks);
      print('✅ [REAL_AI_TEST] Réponse avec backticks parsée: ${backticksResult['parsed_successfully']}');
      expect(backticksResult['parsed_successfully'], isTrue);
      
      // Test 3: Réponse complexe
      const complexResponse = '''
      {
        "emotions": ["joie", "liberté", "émerveillement"],
        "themes": ["vol", "évasion", "nature"],
        "symbols": ["ailes", "ciel", "montagnes"],
        "interpretation": "Ce rêve représente un désir profond de liberté et d'évasion",
        "dream_type": "lucide",
        "psychological_meaning": "Expression de l'âme qui cherche à s'élever",
        "archetypes": ["héros", "sagesse"],
        "color_analysis": "Le bleu du ciel représente la sérénité et la spiritualité",
        "setting_analysis": "L'environnement aérien suggère une élévation spirituelle",
        "character_analysis": "Le rêveur est seul, suggérant une quête personnelle",
        "action_analysis": "Le vol représente la transcendance des limitations terrestres",
        "recurring_patterns": ["vol", "liberté"],
        "personal_growth": "Développement de la confiance en soi et de l'indépendance",
        "warnings": [],
        "recommendations": ["Pratiquer la méditation", "Explorer la créativité"]
      }
      ''';
      
      final complexResult = aiService.parseAnalysisResponse(complexResponse);
      print('✅ [REAL_AI_TEST] Réponse complexe parsée: ${complexResult['parsed_successfully']}');
      expect(complexResult['parsed_successfully'], isTrue);
      expect(complexResult['psychological_meaning'], isNotEmpty);
      expect(complexResult['archetypes'], isA<List>());
      expect(complexResult['recommendations'], isA<List>());
      
      print('🎉 [REAL_AI_TEST] Tous les tests de parsing réussis !');
    });
  });
}
