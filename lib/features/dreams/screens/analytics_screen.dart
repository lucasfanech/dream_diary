import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.analyticsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implémenter le partage
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Analyses et Statistiques',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Vos analyses apparaîtront ici',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondaryColor,
              ),
            ),
            SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Fonctionnalité en cours de développement',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Phase 2 : Intégration IA et génération d\'images',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
