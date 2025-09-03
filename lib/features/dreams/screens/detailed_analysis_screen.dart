import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/dream.dart';
import '../providers/dream_provider.dart';
import '../widgets/analysis_widgets.dart';

class DetailedAnalysisScreen extends StatefulWidget {
  final Dream dream;
  
  const DetailedAnalysisScreen({
    super.key,
    required this.dream,
  });

  @override
  State<DetailedAnalysisScreen> createState() => _DetailedAnalysisScreenState();
}

class _DetailedAnalysisScreenState extends State<DetailedAnalysisScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyse: ${widget.dream.title}'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Vue d\'ensemble', icon: Icon(Icons.dashboard)),
            Tab(text: 'Symboles', icon: Icon(Icons.psychology)),
            Tab(text: 'Émotions', icon: Icon(Icons.favorite)),
            Tab(text: 'Thèmes', icon: Icon(Icons.category)),
            Tab(text: 'Lucidité', icon: Icon(Icons.visibility)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAnalysis,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareAnalysis,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildSymbolsTab(),
                _buildEmotionsTab(),
                _buildThemesTab(),
                _buildLucidityTab(),
              ],
            ),
    );
  }
  
  Widget _buildOverviewTab() {
    final analysis = widget.dream.aiAnalysis;
    if (analysis == null) {
      return _buildNoAnalysisWidget();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Résumé de l'analyse
          AnalysisCard(
            title: 'Résumé de l\'Analyse',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (analysis['interpretation'] != null)
                  _buildAnalysisSection(
                    'Interprétation',
                    analysis['interpretation'],
                    Icons.psychology,
                    AppConstants.primaryColor,
                  ),
                if (analysis['psychological_meaning'] != null)
                  _buildAnalysisSection(
                    'Signification Psychologique',
                    analysis['psychological_meaning'],
                    Icons.insights,
                    AppConstants.secondaryColor,
                  ),
                if (analysis['personal_growth'] != null)
                  _buildAnalysisSection(
                    'Croissance Personnelle',
                    analysis['personal_growth'],
                    Icons.trending_up,
                    AppConstants.successColor,
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Type de rêve et indicateurs
          AnalysisCard(
            title: 'Classification du Rêve',
            child: Column(
              children: [
                _buildDreamTypeChip(analysis['dream_type'] ?? 'normal'),
                const SizedBox(height: AppConstants.paddingSmall),
                if (analysis['lucidity_indicators'] != null && 
                    (analysis['lucidity_indicators'] as List).isNotEmpty)
                  _buildLucidityIndicators(analysis['lucidity_indicators']),
              ],
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Recommandations
          if (analysis['recommendations'] != null)
            AnalysisCard(
              title: 'Recommandations',
              child: _buildRecommendationsList(analysis['recommendations']),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSymbolsTab() {
    final analysis = widget.dream.aiAnalysis;
    if (analysis == null || analysis['symbol_analysis'] == null) {
      return _buildNoAnalysisWidget();
    }
    
    final symbolAnalysis = analysis['symbol_analysis'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Symboles principaux
          if (symbolAnalysis['primary_symbols'] != null)
            AnalysisCard(
              title: 'Symboles Principaux',
              child: _buildPrimarySymbols(symbolAnalysis['primary_symbols']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Analyse des couleurs
          if (symbolAnalysis['color_symbols'] != null)
            AnalysisCard(
              title: 'Analyse des Couleurs',
              child: _buildColorAnalysis(symbolAnalysis['color_symbols']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Symboles universels vs personnels
          Row(
            children: [
              Expanded(
                child: AnalysisCard(
                  title: 'Symboles Universels',
                  child: _buildSymbolList(symbolAnalysis['universal_symbols'] ?? []),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: AnalysisCard(
                  title: 'Symboles Personnels',
                  child: _buildSymbolList(symbolAnalysis['personal_symbols'] ?? []),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmotionsTab() {
    final analysis = widget.dream.aiAnalysis;
    if (analysis == null || analysis['emotion_analysis'] == null) {
      return _buildNoAnalysisWidget();
    }
    
    final emotionAnalysis = analysis['emotion_analysis'] as Map<String, dynamic>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Émotions principales
          if (emotionAnalysis['primary_emotions'] != null)
            AnalysisCard(
              title: 'Émotions Principales',
              child: _buildPrimaryEmotions(emotionAnalysis['primary_emotions']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Parcours émotionnel
          if (emotionAnalysis['emotional_journey'] != null)
            AnalysisCard(
              title: 'Parcours Émotionnel',
              child: _buildEmotionalJourney(emotionAnalysis['emotional_journey']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Connexion avec la vie éveillée
          if (emotionAnalysis['wake_life_connection'] != null)
            AnalysisCard(
              title: 'Connexion avec la Vie Éveillée',
              child: _buildWakeLifeConnection(emotionAnalysis['wake_life_connection']),
            ),
        ],
      ),
    );
  }
  
  Widget _buildThemesTab() {
    final analysis = widget.dream.aiAnalysis;
    if (analysis == null) {
      return _buildNoAnalysisWidget();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thèmes principaux
          if (analysis['themes'] != null)
            AnalysisCard(
              title: 'Thèmes Principaux',
              child: _buildThemesList(analysis['themes']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Patterns récurrents
          if (analysis['recurring_patterns'] != null)
            AnalysisCard(
              title: 'Patterns Récurrents',
              child: _buildRecurringPatterns(analysis['recurring_patterns']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Analyse des lieux et personnages
          Row(
            children: [
              Expanded(
                child: AnalysisCard(
                  title: 'Analyse des Lieux',
                  child: _buildSettingAnalysis(analysis['setting_analysis']),
                ),
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Expanded(
                child: AnalysisCard(
                  title: 'Analyse des Personnages',
                  child: _buildCharacterAnalysis(analysis['character_analysis']),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildLucidityTab() {
    final analysis = widget.dream.aiAnalysis;
    if (analysis == null) {
      return _buildNoAnalysisWidget();
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Niveau de lucidité
          AnalysisCard(
            title: 'Niveau de Lucidité',
            child: _buildLucidityLevel(widget.dream.lucidityLevel ?? 0),
          ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Indicateurs de lucidité
          if (analysis['lucidity_indicators'] != null)
            AnalysisCard(
              title: 'Indicateurs de Lucidité',
              child: _buildLucidityIndicators(analysis['lucidity_indicators']),
            ),
          
          const SizedBox(height: AppConstants.paddingMedium),
          
          // Techniques de lucidité
          AnalysisCard(
            title: 'Techniques Recommandées',
            child: _buildLucidityTechniques(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNoAnalysisWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 64,
            color: AppConstants.textSecondaryColor,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            'Aucune analyse disponible',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            'L\'analyse IA sera disponible après la sauvegarde du rêve',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.paddingLarge),
          ElevatedButton.icon(
            onPressed: _refreshAnalysis,
            icon: const Icon(Icons.refresh),
            label: const Text('Analyser maintenant'),
          ),
        ],
      ),
    );
  }
  
  // Méthodes de construction des widgets d'analyse
  Widget _buildAnalysisSection(String title, String content, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDreamTypeChip(String dreamType) {
    Color color;
    IconData icon;
    
    switch (dreamType.toLowerCase()) {
      case 'lucide':
        color = AppConstants.primaryColor;
        icon = Icons.visibility;
        break;
      case 'cauchemar':
        color = AppConstants.errorColor;
        icon = Icons.warning;
        break;
      case 'récurent':
        color = AppConstants.warningColor;
        icon = Icons.repeat;
        break;
      case 'prémonitoire':
        color = AppConstants.secondaryColor;
        icon = Icons.psychology;
        break;
      default:
        color = AppConstants.textSecondaryColor;
        icon = Icons.nights_stay;
    }
    
    return Chip(
      avatar: Icon(icon, color: Colors.white, size: 16),
      label: Text(
        dreamType.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
    );
  }
  
  Widget _buildLucidityIndicators(List indicators) {
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall,
      children: indicators.map<Widget>((indicator) {
        return Chip(
          label: Text(indicator.toString()),
          backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: AppConstants.primaryColor),
        );
      }).toList(),
    );
  }
  
  Widget _buildRecommendationsList(List recommendations) {
    return Column(
      children: recommendations.map<Widget>((recommendation) {
        return ListTile(
          leading: Icon(
            Icons.lightbulb_outline,
            color: AppConstants.warningColor,
          ),
          title: Text(recommendation.toString()),
          dense: true,
        );
      }).toList(),
    );
  }
  
  Widget _buildPrimarySymbols(List symbols) {
    return Column(
      children: symbols.map<Widget>((symbol) {
        if (symbol is Map<String, dynamic>) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symbol['symbol'] ?? 'Symbole',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  if (symbol['meaning'] != null)
                    Text('Signification: ${symbol['meaning']}'),
                  if (symbol['jungian_interpretation'] != null)
                    Text('Jung: ${symbol['jungian_interpretation']}'),
                  if (symbol['freudian_interpretation'] != null)
                    Text('Freud: ${symbol['freudian_interpretation']}'),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
  
  Widget _buildColorAnalysis(String colorAnalysis) {
    return Text(
      colorAnalysis,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildSymbolList(List symbols) {
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall,
      children: symbols.map<Widget>((symbol) {
        return Chip(
          label: Text(symbol.toString()),
          backgroundColor: AppConstants.secondaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: AppConstants.secondaryColor),
        );
      }).toList(),
    );
  }
  
  Widget _buildPrimaryEmotions(List emotions) {
    return Column(
      children: emotions.map<Widget>((emotion) {
        if (emotion is Map<String, dynamic>) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        emotion['emotion'] ?? 'Émotion',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (emotion['intensity'] != null)
                        _buildIntensityIndicator(emotion['intensity']),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  if (emotion['context'] != null)
                    Text('Contexte: ${emotion['context']}'),
                  if (emotion['meaning'] != null)
                    Text('Signification: ${emotion['meaning']}'),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }
  
  Widget _buildIntensityIndicator(int intensity) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(10, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: index < intensity 
                ? AppConstants.primaryColor 
                : AppConstants.textSecondaryColor.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
  
  Widget _buildEmotionalJourney(String journey) {
    return Text(
      journey,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildWakeLifeConnection(String connection) {
    return Text(
      connection,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildThemesList(List themes) {
    return Wrap(
      spacing: AppConstants.paddingSmall,
      runSpacing: AppConstants.paddingSmall,
      children: themes.map<Widget>((theme) {
        return Chip(
          label: Text(theme.toString()),
          backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
          labelStyle: TextStyle(color: AppConstants.primaryColor),
        );
      }).toList(),
    );
  }
  
  Widget _buildRecurringPatterns(List patterns) {
    return Column(
      children: patterns.map<Widget>((pattern) {
        return ListTile(
          leading: Icon(
            Icons.repeat,
            color: AppConstants.warningColor,
          ),
          title: Text(pattern.toString()),
          dense: true,
        );
      }).toList(),
    );
  }
  
  Widget _buildSettingAnalysis(String? settingAnalysis) {
    return Text(
      settingAnalysis ?? 'Analyse non disponible',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildCharacterAnalysis(String? characterAnalysis) {
    return Text(
      characterAnalysis ?? 'Analyse non disponible',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
  
  Widget _buildLucidityLevel(double level) {
    return Column(
      children: [
        Text(
          'Niveau ${level.toInt()}/10',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.paddingMedium),
        LinearProgressIndicator(
          value: level / 10,
          backgroundColor: AppConstants.textSecondaryColor.withOpacity(0.3),
          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          _getLucidityDescription(level),
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  String _getLucidityDescription(double level) {
    if (level >= 8) return 'Lucidité très élevée - Contrôle total';
    if (level >= 6) return 'Lucidité élevée - Bon contrôle';
    if (level >= 4) return 'Lucidité modérée - Quelque contrôle';
    if (level >= 2) return 'Lucidité faible - Conscience limitée';
    return 'Pas de lucidité - Rêve normal';
  }
  
  Widget _buildLucidityTechniques() {
    return Column(
      children: [
        _buildTechniqueCard(
          'Test de Réalité',
          'Regarder ses mains et compter les doigts',
          Icons.handshake,
        ),
        _buildTechniqueCard(
          'Stabilisation',
          'Frotter les mains ensemble dans le rêve',
          Icons.touch_app,
        ),
        _buildTechniqueCard(
          'Méditation',
          'Pratiquer la méditation avant de dormir',
          Icons.self_improvement,
        ),
      ],
    );
  }
  
  Widget _buildTechniqueCard(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryColor),
        title: Text(title),
        subtitle: Text(description),
        dense: true,
      ),
    );
  }
  
  // Actions
  void _refreshAnalysis() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final dreamProvider = Provider.of<DreamProvider>(context, listen: false);
      await dreamProvider.enhanceDreamWithAI(widget.dream);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'analyse: $e'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _shareAnalysis() {
    // TODO: Implémenter le partage d'analyse
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Partage d\'analyse en cours de développement'),
        backgroundColor: AppConstants.warningColor,
      ),
    );
  }
}
