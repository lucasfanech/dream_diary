import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/stats_card.dart';
import '../../../shared/widgets/welcome_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // En-tête avec titre et actions
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppConstants.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  AppConstants.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: AppConstants.fontSizeXLarge,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryColor,
                        AppConstants.secondaryColor,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {
                    // TODO: Implémenter les notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Colors.white),
                  onPressed: () {
                    // TODO: Navigation vers les paramètres
                  },
                ),
              ],
            ),
            
            // Contenu principal
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête de bienvenue
                    const WelcomeHeader(),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // Statistiques rapides
                    Text(
                      'Vos statistiques',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    // Cartes de statistiques
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: 'Total Rêves',
                            value: '0',
                            icon: Icons.nightlight_round,
                            color: AppConstants.dreamPurple,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: StatsCard(
                            title: 'Rêves Lucides',
                            value: '0',
                            icon: Icons.psychology,
                            color: AppConstants.dreamBlue,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    Row(
                      children: [
                        Expanded(
                          child: StatsCard(
                            title: 'Série Actuelle',
                            value: '0',
                            icon: Icons.local_fire_department,
                            color: AppConstants.dreamPink,
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: StatsCard(
                            title: 'Points XP',
                            value: '0',
                            icon: Icons.stars,
                            color: AppConstants.dreamYellow,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // Rêves récents
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rêves récents',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigation vers la liste complète
                          },
                          child: const Text('Voir tout'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    // Liste des rêves récents (vide pour l'instant)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppConstants.surfaceColor,
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                        border: Border.all(
                          color: AppConstants.textSecondaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.nightlight_round,
                              size: 48,
                              color: AppConstants.textSecondaryColor,
                            ),
                            SizedBox(height: AppConstants.paddingMedium),
                            Text(
                              'Aucun rêve enregistré',
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: AppConstants.fontSizeMedium,
                              ),
                            ),
                            SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              'Commencez par ajouter votre premier rêve !',
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                                fontSize: AppConstants.fontSizeSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                    
                    // Actions rapides
                    Text(
                      'Actions rapides',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigation vers l'ajout de rêve
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Nouveau Rêve'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.paddingLarge,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Navigation vers les méditations
                            },
                            icon: const Icon(Icons.self_improvement),
                            label: const Text('Méditer'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.paddingLarge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
