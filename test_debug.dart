import 'package:dream_diary/core/services/ai_service.dart';
import 'package:dream_diary/shared/models/dream.dart';

void main() async {
  print('🚀 [DEBUG] Début du test de débogage de l\'analyse IA');
  print('=' * 60);
  
  final aiService = AIService();
  
  // Créer un rêve de test
  final testDream = Dream(
    id: 'debug_test_dream',
    title: 'Rêve de Test Debug',
    content: '''
    Je volais dans un ciel bleu infini avec des ailes dorées étincelantes. 
    Le vent me portait doucement vers des montagnes lointaines couvertes de neige. 
    En dessous de moi, je voyais des forêts verdoyantes et des lacs cristallins. 
    Je me sentais libre et en paix, comme si j'étais enfin chez moi.
    ''',
    createdAt: DateTime.now(),
    tags: [],
  );
  
  print('📝 [DEBUG] Rêve de test créé:');
  print('   - ID: ${testDream.id}');
  print('   - Titre: ${testDream.title}');
  print('   - Contenu: ${testDream.content}');
  print('   - Tags initiaux: ${testDream.tags}');
  print('');
  
  try {
    print('🔧 [DEBUG] Tentative d\'initialisation du service IA...');
    await aiService.initialize();
    print('✅ [DEBUG] Service IA initialisé avec succès');
    
    print('\n🔍 [DEBUG] Test d\'amélioration du rêve avec l\'IA...');
    final enhancedDream = await aiService.enhanceDream(testDream);
    
    print('\n✅ [DEBUG] Rêve amélioré avec succès !');
    print('📊 [DEBUG] Résultats:');
    print('   - Titre: ${enhancedDream.title}');
    print('   - Résumé: ${enhancedDream.summary}');
    print('   - Tags: ${enhancedDream.tags}');
    print('   - Analyse IA disponible: ${enhancedDream.aiAnalysis != null}');
    
    if (enhancedDream.aiAnalysis != null) {
      final analysis = enhancedDream.aiAnalysis!;
      print('\n🔍 [DEBUG] Détails de l\'analyse IA:');
      print('   - Parsé avec succès: ${analysis['parsed_successfully']}');
      print('   - Timestamp: ${analysis['parsing_timestamp']}');
      print('   - Émotions: ${analysis['emotions']}');
      print('   - Thèmes: ${analysis['themes']}');
      print('   - Symboles: ${analysis['symbols']}');
      print('   - Interprétation: ${analysis['interpretation']}');
      print('   - Type de rêve: ${analysis['dream_type']}');
      print('   - Signification psychologique: ${analysis['psychological_meaning']}');
      print('   - Archétypes: ${analysis['archetypes']}');
      print('   - Analyse des couleurs: ${analysis['color_analysis']}');
      print('   - Recommandations: ${analysis['recommendations']}');
      
      if (analysis['error'] != null) {
        print('   - Erreur: ${analysis['error']}');
      }
    }
    
  } catch (e) {
    print('❌ [DEBUG] Erreur: $e');
    
    if (e.toString().contains('apiKeyMissing') || 
        e.toString().contains('NotInitializedError')) {
      print('ℹ️ [DEBUG] Pas de clé API configurée - Test du parsing JSON uniquement');
      
      // Tester le parsing JSON avec des données simulées
      print('\n🔧 [DEBUG] Test du parsing JSON avec données simulées...');
      
      const mockResponse = '''
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
      
      final parsedResult = aiService.parseAnalysisResponse(mockResponse);
      print('✅ [DEBUG] Parsing JSON réussi !');
      print('📊 [DEBUG] Résultat du parsing:');
      print('   - Parsé avec succès: ${parsedResult['parsed_successfully']}');
      print('   - Émotions: ${parsedResult['emotions']}');
      print('   - Thèmes: ${parsedResult['themes']}');
      print('   - Symboles: ${parsedResult['symbols']}');
      print('   - Interprétation: ${parsedResult['interpretation']}');
      print('   - Type de rêve: ${parsedResult['dream_type']}');
    }
  }
  
  print('\n🎉 [DEBUG] Test de débogage terminé');
  print('=' * 60);
}
