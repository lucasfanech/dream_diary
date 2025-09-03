import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  group('JSON Parsing Tests', () {
    test('should parse simple JSON response', () {
      const jsonString = '''
      {
        "emotions": ["joie", "liberté"],
        "themes": ["vol", "évasion"],
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ''';
      
      final result = jsonDecode(jsonString);
      print('✅ [JSON_TEST] Parsing réussi: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotions'], isA<List>());
      expect(result['themes'], isA<List>());
      expect(result['symbols'], isA<List>());
      expect(result['interpretation'], isA<String>());
      expect(result['dream_type'], isA<String>());
    });
    
    test('should parse complex JSON response', () {
      const jsonString = '''
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
      
      final result = jsonDecode(jsonString);
      print('✅ [JSON_TEST] Parsing complexe réussi: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotions'], isA<List>());
      expect(result['themes'], isA<List>());
      expect(result['symbols'], isA<List>());
      expect(result['psychological_meaning'], isA<String>());
      expect(result['archetypes'], isA<List>());
      expect(result['recommendations'], isA<List>());
    });
    
    test('should handle JSON with backticks', () {
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
      
      // Simuler l'extraction du JSON
      String cleanResponse = responseWithBackticks;
      if (cleanResponse.contains('```json')) {
        cleanResponse = cleanResponse.split('```json')[1].split('```')[0];
      }
      
      print('🧹 [JSON_TEST] JSON extrait: $cleanResponse');
      
      final result = jsonDecode(cleanResponse);
      print('✅ [JSON_TEST] Parsing avec backticks réussi: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotions'], isA<List>());
      expect(result['themes'], isA<List>());
    });
    
    test('should handle malformed JSON gracefully', () {
      const malformedJson = '''
      {
        "emotions": ["joie", "liberté",
        "themes": ["vol", "évasion"],
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ''';
      
      try {
        final result = jsonDecode(malformedJson);
        fail('Should throw exception for malformed JSON');
      } catch (e) {
        print('✅ [JSON_TEST] Erreur JSON malformé gérée correctement: $e');
        expect(e, isA<FormatException>());
      }
    });
    
    test('should handle empty JSON', () {
      const emptyJson = '{}';
      
      final result = jsonDecode(emptyJson);
      print('✅ [JSON_TEST] JSON vide parsé: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result.isEmpty, isTrue);
    });
    
    test('should handle null values in JSON', () {
      const jsonWithNulls = '''
      {
        "emotions": ["joie", "liberté"],
        "themes": null,
        "symbols": ["ailes", "ciel"],
        "interpretation": "Ce rêve représente un désir de liberté",
        "dream_type": "normal"
      }
      ''';
      
      final result = jsonDecode(jsonWithNulls);
      print('✅ [JSON_TEST] JSON avec nulls parsé: $result');
      
      expect(result, isA<Map<String, dynamic>>());
      expect(result['emotions'], isA<List>());
      expect(result['themes'], isNull);
      expect(result['symbols'], isA<List>());
    });
  });
}
