import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/type_utils.dart';
import '../providers/dream_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DreamProvider>(
      builder: (context, dreamProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.analyticsTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.psychology),
                onPressed: () => _runAdvancedAnalyses(dreamProvider),
                tooltip: 'Analyses avancées',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => dreamProvider.refresh(),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // TODO: Implémenter le partage
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Partage en cours de développement'),
                      backgroundColor: AppConstants.warningColor,
                    ),
                  );
                },
              ),
            ],
          ),
          body: dreamProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : dreamProvider.dreams.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 64,
                            color: AppConstants.textSecondaryColor,
                          ),
                          const SizedBox(height: AppConstants.paddingLarge),
                          Text(
                            'Aucune donnée à analyser',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeXLarge,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            'Ajoutez des rêves pour voir vos analyses',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeMedium,
                              color: AppConstants.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => dreamProvider.refresh(),
                      child: ListView(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        children: [
                          // Statistiques générales
                          _buildStatsSection(dreamProvider),
                          const SizedBox(height: AppConstants.paddingLarge),
                          
                          // Analyse des émotions
                          _buildEmotionsSection(dreamProvider),
                          const SizedBox(height: AppConstants.paddingLarge),
                          
                          // Analyse des thèmes
                          _buildThemesSection(dreamProvider),
                          const SizedBox(height: AppConstants.paddingLarge),
                          
                          // Rêves lucides
                          _buildLucidDreamsSection(dreamProvider),
                          const SizedBox(height: AppConstants.paddingLarge),
                          
                          // Évolution temporelle
                          _buildTimelineSection(dreamProvider),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildStatsSection(DreamProvider dreamProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppConstants.primaryColor),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  'Statistiques Générales',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Rêves',
                    dreamProvider.totalDreams.toString(),
                    Icons.nightlight_round,
                    AppConstants.dreamPurple,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Rêves Lucides',
                    dreamProvider.lucidDreams.toString(),
                    Icons.psychology,
                    AppConstants.dreamBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Série Actuelle',
                    dreamProvider.currentStreak.toString(),
                    Icons.local_fire_department,
                    AppConstants.dreamPink,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Points XP',
                    dreamProvider.experiencePoints.toString(),
                    Icons.stars,
                    AppConstants.dreamYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeXXLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionsSection(DreamProvider dreamProvider) {
    final emotions = <String, int>{};
    for (final dream in dreamProvider.dreams) {
      if (dream.aiAnalysis != null) {
        // Gérer les nouvelles données d'émotions structurées
        if (dream.aiAnalysis!['primary_emotions'] != null) {
          try {
            final primaryEmotionsData = dream.aiAnalysis!['primary_emotions'];
            if (primaryEmotionsData is List) {
              final primaryEmotions = TypeUtils.safeMapListFromDynamic(primaryEmotionsData);
              for (final emotionData in primaryEmotions) {
                final emotion = TypeUtils.safeStringFromDynamic(emotionData['emotion']);
                if (emotion.isNotEmpty) {
                  emotions[emotion] = (emotions[emotion] ?? 0) + 1;
                }
              }
            } else if (primaryEmotionsData is Map) {
              // Si c'est un Map, essayer d'extraire l'émotion
              print('⚠️ [ANALYTICS] primary_emotions est un Map au lieu d\'une List: $primaryEmotionsData');
              final emotion = TypeUtils.safeStringFromDynamic(primaryEmotionsData['emotion']);
              if (emotion.isNotEmpty) {
                emotions[emotion] = (emotions[emotion] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('❌ [ANALYTICS] Erreur lors du traitement des émotions primaires: $e');
          }
        }
        // Gérer les anciennes données d'émotions simples
        else if (dream.aiAnalysis!['emotions'] != null) {
          try {
            final dreamEmotions = TypeUtils.safeStringListFromDynamic(dream.aiAnalysis!['emotions']);
            for (final emotion in dreamEmotions) {
              if (emotion.isNotEmpty) {
                emotions[emotion] = (emotions[emotion] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('❌ [ANALYTICS] Erreur lors du traitement des émotions simples: $e');
          }
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mood, color: AppConstants.dreamPink),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  'Émotions Dominantes',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (emotions.isEmpty)
              const Text(
                'Aucune analyse d\'émotions disponible',
                style: TextStyle(color: AppConstants.textSecondaryColor),
              )
            else
              Column(
                children: _buildEmotionBars(emotions),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemesSection(DreamProvider dreamProvider) {
    final themes = <String, int>{};
    for (final dream in dreamProvider.dreams) {
      if (dream.aiAnalysis != null) {
        // Gérer les nouvelles données de thèmes structurées
        if (dream.aiAnalysis!['new_themes'] != null) {
          try {
            final newThemesData = dream.aiAnalysis!['new_themes'];
            if (newThemesData is List) {
              final newThemes = TypeUtils.safeStringListFromDynamic(newThemesData);
              for (final theme in newThemes) {
                if (theme.isNotEmpty) {
                  themes[theme] = (themes[theme] ?? 0) + 1;
                }
              }
            } else if (newThemesData is String) {
              // Si c'est une string, l'ajouter directement
              print('⚠️ [ANALYTICS] new_themes est une String au lieu d\'une List: $newThemesData');
              if (newThemesData.isNotEmpty) {
                themes[newThemesData] = (themes[newThemesData] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('❌ [ANALYTICS] Erreur lors du traitement des nouveaux thèmes: $e');
          }
        }
        // Gérer les thèmes récurrents
        if (dream.aiAnalysis!['recurring_themes'] != null) {
          try {
            final recurringThemesData = dream.aiAnalysis!['recurring_themes'];
            if (recurringThemesData is List) {
              final recurringThemes = TypeUtils.safeMapListFromDynamic(recurringThemesData);
              for (final themeData in recurringThemes) {
                final theme = TypeUtils.safeStringFromDynamic(themeData['theme']);
                if (theme.isNotEmpty) {
                  themes[theme] = (themes[theme] ?? 0) + 1;
                }
              }
            } else if (recurringThemesData is Map) {
              // Si c'est un Map, essayer d'extraire les thèmes
              print('⚠️ [ANALYTICS] recurring_themes est un Map au lieu d\'une List: $recurringThemesData');
              final theme = TypeUtils.safeStringFromDynamic(recurringThemesData['theme']);
              if (theme.isNotEmpty) {
                themes[theme] = (themes[theme] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('❌ [ANALYTICS] Erreur lors du traitement des thèmes récurrents: $e');
          }
        }
        // Gérer les anciennes données de thèmes simples
        else if (dream.aiAnalysis!['themes'] != null) {
          try {
            final dreamThemes = TypeUtils.safeStringListFromDynamic(dream.aiAnalysis!['themes']);
            for (final theme in dreamThemes) {
              if (theme.isNotEmpty) {
                themes[theme] = (themes[theme] ?? 0) + 1;
              }
            }
          } catch (e) {
            print('❌ [ANALYTICS] Erreur lors du traitement des thèmes simples: $e');
          }
        }
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: AppConstants.dreamIndigo),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  'Thèmes Récurrents',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (themes.isEmpty)
              const Text(
                'Aucune analyse de thèmes disponible',
                style: TextStyle(color: AppConstants.textSecondaryColor),
              )
            else
              Wrap(
                spacing: AppConstants.paddingSmall,
                runSpacing: AppConstants.paddingSmall,
                children: _buildThemeChips(themes),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLucidDreamsSection(DreamProvider dreamProvider) {
    final lucidDreams = dreamProvider.dreams.where((dream) => dream.isLucid).toList();
    final lucidityLevels = lucidDreams
        .where((dream) => dream.lucidityLevel != null)
        .map((dream) => dream.lucidityLevel!)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.psychology, color: AppConstants.dreamBlue),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  'Rêves Lucides',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (lucidDreams.isEmpty)
              const Text(
                'Aucun rêve lucide enregistré',
                style: TextStyle(color: AppConstants.textSecondaryColor),
              )
            else ...[
              Text('Nombre total: ${lucidDreams.length}'),
              const SizedBox(height: AppConstants.paddingSmall),
              if (lucidityLevels.isNotEmpty) ...[
                Text('Niveau moyen: ${(lucidityLevels.reduce((a, b) => a + b) / lucidityLevels.length).toStringAsFixed(1)}%'),
                const SizedBox(height: AppConstants.paddingSmall),
                Text('Niveau maximum: ${lucidityLevels.reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}%'),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection(DreamProvider dreamProvider) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    final lastMonth = now.subtract(const Duration(days: 30));
    
    final dreamsThisWeek = dreamProvider.dreams
        .where((dream) => dream.createdAt.isAfter(lastWeek))
        .length;
    final dreamsThisMonth = dreamProvider.dreams
        .where((dream) => dream.createdAt.isAfter(lastMonth))
        .length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: AppConstants.dreamYellow),
                const SizedBox(width: AppConstants.paddingMedium),
                Text(
                  'Évolution Temporelle',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Cette Semaine',
                    dreamsThisWeek.toString(),
                    Icons.calendar_view_week,
                    AppConstants.dreamYellow,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Ce Mois',
                    dreamsThisMonth.toString(),
                    Icons.calendar_month,
                    AppConstants.dreamYellow,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmotionBars(Map<String, int> emotions) {
    final sortedEntries = emotions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.take(5).map((entry) {
      final maxValue = emotions.values.reduce((a, b) => a > b ? a : b);
      return Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
        child: Row(
          children: [
            Expanded(
              child: Text(entry.key),
            ),
            Container(
              width: 100,
              height: 8,
              decoration: BoxDecoration(
                color: AppConstants.dreamPink.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: entry.value / maxValue,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.dreamPink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
            Text('${entry.value}'),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildThemeChips(Map<String, int> themes) {
    final sortedEntries = themes.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.take(8).map((entry) {
      return Chip(
        label: Text('${entry.key} (${entry.value})'),
        backgroundColor: AppConstants.dreamIndigo.withOpacity(0.1),
        labelStyle: TextStyle(color: AppConstants.dreamIndigo),
      );
    }).toList();
  }
  
  // Lancer les analyses avancées
  void _runAdvancedAnalyses(DreamProvider dreamProvider) async {
    if (dreamProvider.dreams.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Au moins 3 rêves sont nécessaires pour les analyses avancées'),
          backgroundColor: AppConstants.warningColor,
        ),
      );
      return;
    }
    
    try {
      await dreamProvider.runAdvancedAnalyses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyses avancées terminées !'),
          backgroundColor: AppConstants.successColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors des analyses: $e'),
          backgroundColor: AppConstants.errorColor,
        ),
      );
    }
  }
}
