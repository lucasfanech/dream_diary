import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  String _getMotivationalMessage() {
    final messages = [
      'Prêt à explorer vos rêves ?',
      'Vos rêves vous attendent !',
      'Chaque rêve est une histoire unique',
      'Découvrez les mystères de votre inconscient',
      'Vos rêves sont votre trésor intérieur',
    ];
    
    final random = DateTime.now().millisecond % messages.length;
    return messages[random];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.dreamPurple.withOpacity(0.1),
            AppConstants.dreamBlue.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: AppConstants.dreamPurple.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.dreamPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppConstants.dreamPurple,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getGreeting(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppConstants.dreamPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getMotivationalMessage(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: AppConstants.dreamBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.tips_and_updates,
                  size: 16,
                  color: AppConstants.dreamBlue,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Conseil du jour : Notez vos rêves dès le réveil pour une meilleure mémorisation',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.dreamBlue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
