/// Utilitaires pour la conversion de types sécurisée
class TypeUtils {
  /// Convertit un Map<dynamic, dynamic> en Map<String, dynamic> de manière sécurisée
  static Map<String, dynamic> safeMapFromDynamic(Map? map) {
    if (map == null) return {};
    
    try {
      return Map<String, dynamic>.from(map);
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de Map: $e');
      return {};
    }
  }
  
  /// Convertit une liste dynamique en liste de strings de manière sécurisée
  static List<String> safeStringListFromDynamic(List? list) {
    if (list == null) return [];
    
    try {
      return list.map((item) => item.toString()).toList();
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de liste: $e');
      return [];
    }
  }
  
  /// Convertit une liste dynamique en liste de maps de manière sécurisée
  static List<Map<String, dynamic>> safeMapListFromDynamic(List? list) {
    if (list == null) return [];
    
    try {
      return list
          .where((item) => item is Map)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de liste de maps: $e');
      return [];
    }
  }
  
  /// Obtient une valeur string de manière sécurisée
  static String safeStringFromDynamic(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    
    try {
      return value.toString();
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de string: $e');
      return defaultValue;
    }
  }
  
  /// Obtient une valeur int de manière sécurisée
  static int safeIntFromDynamic(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    
    try {
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.parse(value);
      return defaultValue;
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de int: $e');
      return defaultValue;
    }
  }
  
  /// Obtient une valeur double de manière sécurisée
  static double safeDoubleFromDynamic(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    
    try {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.parse(value);
      return defaultValue;
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de double: $e');
      return defaultValue;
    }
  }
  
  /// Obtient une valeur bool de manière sécurisée
  static bool safeBoolFromDynamic(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    
    try {
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) return value != 0;
      return defaultValue;
    } catch (e) {
      print('⚠️ [TYPE_UTILS] Erreur de conversion de bool: $e');
      return defaultValue;
    }
  }
}
