import 'package:flutter_test/flutter_test.dart';
import 'package:dream_diary/core/services/ai_service.dart';
import 'package:dream_diary/core/services/tag_service.dart';
import 'package:dream_diary/core/services/emotion_analysis_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() {
  group('Dream Analysis Integration Tests', () {
    late AIService aiService;
    late TagService tagService;
    late EmotionAnalysisService emotionService;
    
    setUp(() {
      aiService = AIService();
      tagService = TagService();
      emotionService = EmotionAnalysisService();
    });
    
    test('should perform complete dream analysis workflow', () async {
      print('🚀 [INTEGRATION_TEST] Début du test d\'intégration complet');
      
      // Créer un rêve de test
      final testDream = Dream(
        id: 'integration_test_dream',
        title: 'Rêve de Test',
        content: '''
        Je volais dans un ciel bleu infini avec des ailes dorées étincelantes. 
        Le vent me portait doucement vers des montagnes lointaines couvertes de neige. 
        En dessous de moi, je voyais des forêts verdoyantes et des lacs cristallins. 
        Je me sentais libre et en paix, comme si j'étais enfin chez moi.
        ''',
        createdAt: DateTime.now(),
        tags: [],
      );
      
      print('📝 [INTEGRATION_TEST] Rêve de test créé: ${testDream.title}');
      print('📄 [INTEGRATION_TEST] Contenu: ${testDream.content}');
      
      // Test 1: Amélioration du rêve avec l'IA
      print('\n🔍 [INTEGRATION_TEST] Test 1: Amélioration du rêve avec l\'IA');
      try {
        final enhancedDream = await aiService.enhanceDream(testDream);
        print('✅ [INTEGRATION_TEST] Rêve amélioré avec succès');
        print('   - Titre: ${enhancedDream.title}');
        print('   - Résumé: ${enhancedDream.summary}');
        print('   - Tags: ${enhancedDream.tags}');
        print('   - Analyse IA: ${enhancedDream.aiAnalysis?.keys}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur amélioration IA: $e');
      }
      
      // Test 2: Catégorisation du rêve
      print('\n🏷️ [INTEGRATION_TEST] Test 2: Catégorisation du rêve');
      try {
        final categorization = await tagService.categorizeDream(testDream.content);
        print('✅ [INTEGRATION_TEST] Catégorisation réussie');
        print('   - Catégorie principale: ${categorization['primary_category']}');
        print('   - Sous-catégories: ${categorization['subcategories']}');
        print('   - Catégorie émotionnelle: ${categorization['emotional_category']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur catégorisation: $e');
      }
      
      // Test 3: Tags intelligents
      print('\n🧠 [INTEGRATION_TEST] Test 3: Génération de tags intelligents');
      try {
        final intelligentTags = await tagService.generateIntelligentTags(testDream.content);
        print('✅ [INTEGRATION_TEST] Tags intelligents générés');
        print('   - Nombre de catégories: ${intelligentTags.length}');
        for (final tagCategory in intelligentTags) {
          print('   - ${tagCategory['type']}: ${tagCategory['tags']}');
        }
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur tags intelligents: $e');
      }
      
      // Test 4: Analyse émotionnelle
      print('\n🎭 [INTEGRATION_TEST] Test 4: Analyse émotionnelle');
      try {
        final emotionAnalysis = await aiService.analyzeEmotions(testDream.content);
        print('✅ [INTEGRATION_TEST] Analyse émotionnelle réussie');
        print('   - Émotions primaires: ${emotionAnalysis['primary_emotions']}');
        print('   - Parcours émotionnel: ${emotionAnalysis['emotional_journey']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur analyse émotionnelle: $e');
      }
      
      // Test 5: Analyse symbolique
      print('\n🔮 [INTEGRATION_TEST] Test 5: Analyse symbolique');
      try {
        final symbolAnalysis = await aiService.analyzeSymbols(testDream.content);
        print('✅ [INTEGRATION_TEST] Analyse symbolique réussie');
        print('   - Symboles primaires: ${symbolAnalysis['primary_symbols']}');
        print('   - Analyse des couleurs: ${symbolAnalysis['color_symbols']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur analyse symbolique: $e');
      }
      
      print('\n🎉 [INTEGRATION_TEST] Test d\'intégration terminé');
    });
    
    test('should analyze multiple dreams for patterns', () async {
      print('🔄 [INTEGRATION_TEST] Test d\'analyse de patterns sur plusieurs rêves');
      
      final dreams = [
        Dream(
          id: 'dream_1',
          title: 'Rêve de vol',
          content: 'Je volais dans le ciel bleu avec des ailes dorées',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          emotion: 'joie',
          tags: ['vol', 'ciel', 'liberté'],
        ),
        Dream(
          id: 'dream_2',
          title: 'Rêve de montagne',
          content: 'Je grimpais une montagne enneigée vers le sommet',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          emotion: 'détermination',
          tags: ['montagne', 'escalade', 'défi'],
        ),
        Dream(
          id: 'dream_3',
          title: 'Rêve de vol 2',
          content: 'Je volais encore dans le ciel, mais cette fois avec des ailes argentées',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          emotion: 'sérénité',
          tags: ['vol', 'ciel', 'argent'],
        ),
      ];
      
      // Test d'évolution émotionnelle
      print('\n📈 [INTEGRATION_TEST] Test d\'évolution émotionnelle');
      try {
        final evolution = await emotionService.analyzeEmotionalEvolution(dreams);
        print('✅ [INTEGRATION_TEST] Évolution émotionnelle analysée');
        print('   - Timeline: ${evolution['emotional_timeline']}');
        print('   - Tendances: ${evolution['emotional_trends']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur évolution émotionnelle: $e');
      }
      
      // Test de thèmes récurrents
      print('\n🔄 [INTEGRATION_TEST] Test de thèmes récurrents');
      try {
        final themes = await emotionService.detectRecurringThemes(dreams);
        print('✅ [INTEGRATION_TEST] Thèmes récurrents détectés');
        print('   - Thèmes récurrents: ${themes['recurring_themes']}');
        print('   - Connexions: ${themes['theme_connections']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur thèmes récurrents: $e');
      }
      
      // Test de patterns de tags
      print('\n🏷️ [INTEGRATION_TEST] Test de patterns de tags');
      try {
        final patterns = await tagService.analyzeTagPatterns(dreams);
        print('✅ [INTEGRATION_TEST] Patterns de tags analysés');
        print('   - Tags les plus communs: ${patterns['most_common_tags']}');
        print('   - Combinaisons: ${patterns['tag_combinations']}');
      } catch (e) {
        print('❌ [INTEGRATION_TEST] Erreur patterns de tags: $e');
      }
      
      print('\n🎉 [INTEGRATION_TEST] Test de patterns terminé');
    });
  });
}
