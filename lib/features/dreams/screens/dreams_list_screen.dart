import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class DreamsListScreen extends StatefulWidget {
  const DreamsListScreen({super.key});

  @override
  State<DreamsListScreen> createState() => _DreamsListScreenState();
}

class _DreamsListScreenState extends State<DreamsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.dreamsTab),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implémenter les filtres
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            SizedBox(height: AppConstants.paddingLarge),
            Text(
              'Liste des rêves',
              style: TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
            SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Vos rêves apparaîtront ici',
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
          ],
        ),
      ),
    );
  }
}
