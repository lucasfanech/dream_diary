import 'package:hive_flutter/hive_flutter.dart';
import '../../shared/models/dream.dart';
import '../../shared/models/user.dart';
import '../utils/type_utils.dart';

class StorageService {
  static const String _dreamsBoxName = 'dreams';
  static const String _userBoxName = 'user';
  static const String _settingsBoxName = 'settings';
  
  late Box<Dream> _dreamsBox;
  late Box<User> _userBox;
  late Box _settingsBox;
  
  bool _isInitialized = false;
  
  // Singleton pattern
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialiser Hive
      await Hive.initFlutter();
      
      // Enregistrer les adaptateurs
      Hive.registerAdapter(DreamAdapter());
      Hive.registerAdapter(UserAdapter());
      
      // Ouvrir les boxes
      _dreamsBox = await Hive.openBox<Dream>(_dreamsBoxName);
      _userBox = await Hive.openBox<User>(_userBoxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation du stockage: $e');
    }
  }
  
  // Gestion des rêves
  Future<void> saveDream(Dream dream) async {
    await _ensureInitialized();
    await _dreamsBox.put(dream.id, dream);
  }
  
  Future<Dream?> getDream(String id) async {
    await _ensureInitialized();
    return _dreamsBox.get(id);
  }
  
  Future<List<Dream>> getAllDreams() async {
    await _ensureInitialized();
    return _dreamsBox.values.toList();
  }
  
  Future<List<Dream>> getDreamsByDate(DateTime date) async {
    await _ensureInitialized();
    return _dreamsBox.values
        .where((dream) => dream.dreamDate?.year == date.year &&
                         dream.dreamDate?.month == date.month &&
                         dream.dreamDate?.day == date.day)
        .toList();
  }
  
  Future<List<Dream>> searchDreams(String query) async {
    await _ensureInitialized();
    query = query.toLowerCase();
    return _dreamsBox.values
        .where((dream) => 
            dream.title.toLowerCase().contains(query) ||
            dream.content.toLowerCase().contains(query) ||
            dream.tags.any((tag) => tag.toLowerCase().contains(query)))
        .toList();
  }
  
  Future<void> deleteDream(String id) async {
    await _ensureInitialized();
    await _dreamsBox.delete(id);
  }
  
  Future<void> deleteAllDreams() async {
    await _ensureInitialized();
    await _dreamsBox.clear();
  }
  
  // Gestion de l'utilisateur
  Future<void> saveUser(User user) async {
    await _ensureInitialized();
    await _userBox.put(user.id, user);
  }
  
  Future<User?> getUser(String id) async {
    await _ensureInitialized();
    return _userBox.get(id);
  }
  
  Future<User?> getCurrentUser() async {
    await _ensureInitialized();
    if (_userBox.isEmpty) return null;
    return _userBox.values.first;
  }
  
  Future<void> deleteUser(String id) async {
    await _ensureInitialized();
    await _userBox.delete(id);
  }
  
  // Gestion des paramètres
  Future<void> saveSetting(String key, dynamic value) async {
    await _ensureInitialized();
    await _settingsBox.put(key, value);
  }
  
  T? getSetting<T>(String key, {T? defaultValue}) {
    if (!_isInitialized) return defaultValue;
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }
  
  Future<void> deleteSetting(String key) async {
    await _ensureInitialized();
    await _settingsBox.delete(key);
  }
  
  Future<void> clearSettings() async {
    await _ensureInitialized();
    await _settingsBox.clear();
  }
  
  // Statistiques
  Future<int> getTotalDreamsCount() async {
    await _ensureInitialized();
    return _dreamsBox.length;
  }
  
  Future<int> getDreamsCountForDate(DateTime date) async {
    await _ensureInitialized();
    return getDreamsByDate(date).then((dreams) => dreams.length);
  }
  
  Future<List<String>> getAllTags() async {
    await _ensureInitialized();
    final allTags = <String>{};
    for (final dream in _dreamsBox.values) {
      allTags.addAll(dream.tags);
    }
    return allTags.toList()..sort();
  }
  
  Future<List<String>> getMostUsedTags({int limit = 10}) async {
    await _ensureInitialized();
    final tagCounts = <String, int>{};
    
    for (final dream in _dreamsBox.values) {
      for (final tag in dream.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedTags.take(limit).map((e) => e.key).toList();
  }
  
  // Sauvegarde et restauration
  Future<Map<String, dynamic>> exportData() async {
    await _ensureInitialized();
    
    final dreams = getAllDreams();
    final user = getCurrentUser();
    final settings = _settingsBox.toMap();
    
    return {
      'dreams': await dreams,
      'user': await user,
      'settings': settings,
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0.0',
    };
  }
  
  Future<void> importData(Map<String, dynamic> data) async {
    await _ensureInitialized();
    
    try {
      // Importer les rêves
      if (data['dreams'] != null) {
        final dreams = data['dreams'] as List;
        for (final dreamData in dreams) {
          if (dreamData is Map<String, dynamic>) {
            final dream = Dream.fromJson(dreamData);
            await saveDream(dream);
          }
        }
      }
      
      // Importer l'utilisateur
      if (data['user'] != null) {
        final userData = TypeUtils.safeMapFromDynamic(data['user']);
        final user = User.fromJson(userData);
        await saveUser(user);
      }
      
      // Importer les paramètres
      if (data['settings'] != null) {
        final settings = data['settings'] as Map;
        for (final entry in settings.entries) {
          await saveSetting(entry.key.toString(), entry.value);
        }
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'import des données: $e');
    }
  }
  
  // Nettoyage
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _dreamsBox.clear();
    await _userBox.clear();
    await _settingsBox.clear();
  }
  
  Future<void> close() async {
    if (_isInitialized) {
      await _dreamsBox.close();
      await _userBox.close();
      await _settingsBox.close();
      _isInitialized = false;
    }
  }
  
  // Vérification d'initialisation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  // Getters pour vérifier l'état
  bool get isInitialized => _isInitialized;
  Box<Dream> get dreamsBox => _dreamsBox;
  Box<User> get userBox => _userBox;
  Box get settingsBox => _settingsBox;
}
