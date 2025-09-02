import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/config_service.dart';

class ConfigStatusWidget extends StatelessWidget {
  const ConfigStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  ConfigService.isApiKeyConfigured 
                      ? Icons.check_circle 
                      : Icons.warning,
                  color: ConfigService.isApiKeyConfigured 
                      ? AppConstants.successColor 
                      : AppConstants.warningColor,
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Text(
                    'Configuration IA',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              ConfigService.isApiKeyConfigured
                  ? 'Clé API Gemini configurée'
                  : 'Clé API Gemini manquante',
              style: TextStyle(
                color: ConfigService.isApiKeyConfigured
                    ? AppConstants.successColor
                    : AppConstants.warningColor,
                fontSize: AppConstants.fontSizeSmall,
              ),
            ),
            if (!ConfigService.isApiKeyConfigured) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                'Pour activer les fonctionnalités IA, configurez votre clé API dans le fichier .env',
                style: TextStyle(
                  color: AppConstants.textSecondaryColor,
                  fontSize: AppConstants.fontSizeSmall,
                ),
              ),
              const SizedBox(height: AppConstants.paddingSmall),
              ElevatedButton.icon(
                onPressed: () => _showConfigDialog(context),
                icon: const Icon(Icons.settings),
                label: const Text('Instructions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showConfigDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuration de l\'IA'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pour activer les fonctionnalités IA :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppConstants.paddingMedium),
              Text('1. Obtenez une clé API Gemini sur Google AI Studio'),
              Text('2. Ouvrez le fichier .env à la racine du projet'),
              Text('3. Remplacez YOUR_GEMINI_API_KEY par votre clé'),
              Text('4. Redémarrez l\'application'),
              SizedBox(height: AppConstants.paddingMedium),
              Text(
                'Note: Le fichier .env est ignoré par Git pour la sécurité.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
