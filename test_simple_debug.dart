import 'dart:convert';

void main() async {
  print('🚀 [DEBUG] Test simple de débogage du parsing JSON');
  print('=' * 60);
  
  // Test du parsing JSON avec des données simulées
  print('🔧 [DEBUG] Test du parsing JSON avec données simulées...');
  
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
  
  try {
    print('📝 [DEBUG] Réponse simulée:');
    print(mockResponse);
    print('');
    
    // Test du parsing JSON
    print('🔧 [DEBUG] Tentative de parsing JSON...');
    final parsedJson = jsonDecode(mockResponse);
    print('✅ [DEBUG] Parsing JSON réussi !');
    print('📊 [DEBUG] Données parsées:');
    print('   - Émotions: ${parsedJson['emotions']}');
    print('   - Thèmes: ${parsedJson['themes']}');
    print('   - Symboles: ${parsedJson['symbols']}');
    print('   - Interprétation: ${parsedJson['interpretation']}');
    print('   - Type de rêve: ${parsedJson['dream_type']}');
    print('   - Signification psychologique: ${parsedJson['psychological_meaning']}');
    print('   - Archétypes: ${parsedJson['archetypes']}');
    print('   - Recommandations: ${parsedJson['recommendations']}');
    
    // Test de l'extraction avec backticks
    print('\n🔧 [DEBUG] Test d\'extraction avec backticks...');
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
    
    String cleanResponse = responseWithBackticks;
    if (cleanResponse.contains('```json')) {
      cleanResponse = cleanResponse.split('```json')[1].split('```')[0];
    }
    
    print('🧹 [DEBUG] JSON extrait des backticks:');
    print(cleanResponse);
    
    final parsedWithBackticks = jsonDecode(cleanResponse);
    print('✅ [DEBUG] Parsing avec backticks réussi !');
    print('📊 [DEBUG] Données parsées:');
    print('   - Émotions: ${parsedWithBackticks['emotions']}');
    print('   - Thèmes: ${parsedWithBackticks['themes']}');
    print('   - Symboles: ${parsedWithBackticks['symbols']}');
    
    // Test de validation et enrichissement
    print('\n🔍 [DEBUG] Test de validation et enrichissement...');
    final enrichedAnalysis = _validateAndEnrichAnalysis(parsedJson, mockResponse);
    print('✅ [DEBUG] Analyse enrichie créée avec succès !');
    print('📊 [DEBUG] Champs enrichis: ${enrichedAnalysis.keys}');
    print('   - Parsé avec succès: ${enrichedAnalysis['parsed_successfully']}');
    print('   - Timestamp: ${enrichedAnalysis['parsing_timestamp']}');
    
  } catch (e) {
    print('❌ [DEBUG] Erreur: $e');
  }
  
  print('\n🎉 [DEBUG] Test de débogage terminé');
  print('=' * 60);
}

// Fonction de validation et enrichissement (copiée du service)
Map<String, dynamic> _validateAndEnrichAnalysis(Map<String, dynamic> parsedJson, String rawResponse) {
  print('🔍 [DEBUG] Validation et enrichissement de l\'analyse...');
  
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
  
  print('✅ [DEBUG] Analyse enrichie créée avec succès');
  print('📊 [DEBUG] Champs enrichis: ${enrichedAnalysis.keys}');
  
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
