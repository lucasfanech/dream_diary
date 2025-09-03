import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/tag_service.dart';
import '../../../core/services/emotion_analysis_service.dart';
import '../../../shared/models/dream.dart';
import '../../../shared/models/user.dart';

class DreamProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  final AIService _aiService = AIService();
  final TagService _tagService = TagService();
  final EmotionAnalysisService _emotionService = EmotionAnalysisService();
  
  List<Dream> _dreams = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  // Analyses avancées
  Map<String, dynamic>? _emotionalEvolution;
  Map<String, dynamic>? _recurringThemes;
  Map<String, dynamic>? _lucidityPatterns;
  Map<String, dynamic>? _tagPatterns;

  // Getters
  List<Dream> get dreams => _dreams;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Getters pour les analyses avancées
  Map<String, dynamic>? get emotionalEvolution => _emotionalEvolution;
  Map<String, dynamic>? get recurringThemes => _recurringThemes;
  Map<String, dynamic>? get lucidityPatterns => _lucidityPatterns;
  Map<String, dynamic>? get tagPatterns => _tagPatterns;

  // Statistiques
  int get totalDreams => _dreams.length;
  int get lucidDreams => _dreams.where((dream) => dream.isLucid).length;
  int get currentStreak => _currentUser?.currentStreak ?? 0;
  int get experiencePoints => _currentUser?.experiencePoints ?? 0;

  // Initialisation
  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _aiService.initialize();
      await _tagService.initialize();
      await _emotionService.initialize();
      await _loadDreams();
      await _loadCurrentUser();
      _clearError();
    } catch (e) {
      _setError('Erreur lors de l\'initialisation: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Chargement des rêves
  Future<void> _loadDreams() async {
    try {
      _dreams = await _storageService.getAllDreams();
      _dreams.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors du chargement des rêves: $e');
    }
  }

  // Chargement de l'utilisateur
  Future<void> _loadCurrentUser() async {
    try {
      _currentUser = await _storageService.getCurrentUser();
      if (_currentUser == null) {
        // Créer un utilisateur par défaut
        _currentUser = User(
          id: 'default_user',
          name: 'Utilisateur',
          createdAt: DateTime.now(),
          lastActive: DateTime.now(),
        );
        await _storageService.saveUser(_currentUser!);
      }
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors du chargement de l\'utilisateur: $e');
    }
  }

  // Sauvegarde d'un rêve
  Future<bool> saveDream(Dream dream) async {
    _setLoading(true);
    try {
      // Améliorer le rêve avec l'IA si possible
      Dream enhancedDream = dream;
      try {
        enhancedDream = await _aiService.enhanceDream(dream, previousDreams: _dreams);
      } catch (e) {
        // Si l'IA échoue, on sauvegarde quand même le rêve
        print('Erreur IA (non bloquante): $e');
      }
      
      await _storageService.saveDream(enhancedDream);
      await _loadDreams();
      
      // Mettre à jour les statistiques utilisateur
      if (_currentUser != null) {
        if (enhancedDream.isLucid) {
          _currentUser!.addLucidDream();
        } else {
          _currentUser!.addDream();
        }
        _currentUser!.addExperience(10); // 10 points par rêve
        await _storageService.saveUser(_currentUser!);
      }
      
      _clearError();
      return true;
    } catch (e) {
      _setError('Erreur lors de la sauvegarde: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Suppression d'un rêve
  Future<bool> deleteDream(String dreamId) async {
    _setLoading(true);
    try {
      await _storageService.deleteDream(dreamId);
      await _loadDreams();
      _clearError();
      return true;
    } catch (e) {
      _setError('Erreur lors de la suppression: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Recherche de rêves
  Future<List<Dream>> searchDreams(String query) async {
    try {
      return await _storageService.searchDreams(query);
    } catch (e) {
      _setError('Erreur lors de la recherche: $e');
      return [];
    }
  }

  // Rêves récents (5 derniers)
  List<Dream> get recentDreams => _dreams.take(5).toList();

  // Rêves par date
  Future<List<Dream>> getDreamsByDate(DateTime date) async {
    try {
      return await _storageService.getDreamsByDate(date);
    } catch (e) {
      _setError('Erreur lors du chargement des rêves par date: $e');
      return [];
    }
  }

  // Mise à jour de l'utilisateur
  Future<void> updateUser(User user) async {
    try {
      await _storageService.saveUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      _setError('Erreur lors de la mise à jour de l\'utilisateur: $e');
    }
  }

  // Actualisation des données
  Future<void> refresh() async {
    await initialize();
  }
  
  // Améliorer un rêve existant avec l'IA
  Future<Dream> enhanceDreamWithAI(Dream dream) async {
    _setLoading(true);
    try {
      final enhancedDream = await _aiService.enhanceDream(dream, previousDreams: _dreams);
      await _storageService.saveDream(enhancedDream);
      await _loadDreams();
      _clearError();
      return enhancedDream;
    } catch (e) {
      _setError('Erreur lors de l\'amélioration IA: $e');
      return dream;
    } finally {
      _setLoading(false);
    }
  }
  
  // Analyser l'évolution émotionnelle
  Future<void> analyzeEmotionalEvolution() async {
    if (_dreams.length < 3) return;
    
    try {
      _emotionalEvolution = await _emotionService.analyzeEmotionalEvolution(_dreams);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'analyse émotionnelle: $e');
    }
  }
  
  // Détecter les thèmes récurrents
  Future<void> detectRecurringThemes() async {
    if (_dreams.length < 3) return;
    
    try {
      _recurringThemes = await _emotionService.detectRecurringThemes(_dreams);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la détection des thèmes: $e');
    }
  }
  
  // Analyser les patterns de lucidité
  Future<void> analyzeLucidityPatterns() async {
    final lucidDreams = _dreams.where((dream) => dream.isLucid).toList();
    if (lucidDreams.length < 2) return;
    
    try {
      _lucidityPatterns = await _emotionService.analyzeLucidityPatterns(lucidDreams);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'analyse de lucidité: $e');
    }
  }
  
  // Analyser les patterns de tags
  Future<void> analyzeTagPatterns() async {
    if (_dreams.length < 3) return;
    
    try {
      _tagPatterns = await _tagService.analyzeTagPatterns(_dreams);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'analyse des tags: $e');
    }
  }
  
  // Catégoriser un rêve
  Future<Map<String, dynamic>> categorizeDream(Dream dream) async {
    try {
      return await _tagService.categorizeDream(dream.content);
    } catch (e) {
      print('Erreur lors de la catégorisation: $e');
      return {};
    }
  }
  
  // Générer des tags intelligents
  Future<List<Map<String, dynamic>>> generateIntelligentTags(Dream dream) async {
    try {
      return await _tagService.generateIntelligentTags(dream.content);
    } catch (e) {
      print('Erreur lors de la génération de tags: $e');
      return [];
    }
  }
  
  // Suggérer des tags manquants
  Future<List<String>> suggestMissingTags(Dream dream) async {
    try {
      return await _tagService.suggestMissingTags(dream);
    } catch (e) {
      print('Erreur lors de la suggestion de tags: $e');
      return [];
    }
  }
  
  // Exécuter toutes les analyses avancées
  Future<void> runAdvancedAnalyses() async {
    if (_dreams.length < 3) return;
    
    _setLoading(true);
    try {
      await Future.wait([
        analyzeEmotionalEvolution(),
        detectRecurringThemes(),
        analyzeLucidityPatterns(),
        analyzeTagPatterns(),
      ]);
      _clearError();
    } catch (e) {
      _setError('Erreur lors des analyses avancées: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Gestion des états
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }


}
