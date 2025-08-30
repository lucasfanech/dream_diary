import 'package:flutter/material.dart';

class AppConstants {
  // Couleurs de l'application
  static const Color primaryColor = Color(0xFF6B46C1);
  static const Color secondaryColor = Color(0xFF9F7AEA);
  static const Color accentColor = Color(0xFFF6AD55);
  static const Color backgroundColor = Color(0xFFF7FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF2D3748);
  static const Color textSecondaryColor = Color(0xFF718096);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFD69E2E);
  
  // Couleurs spécifiques aux rêves
  static const Color dreamPurple = Color(0xFF8B5CF6);
  static const Color dreamBlue = Color(0xFF3B82F6);
  static const Color dreamIndigo = Color(0xFF6366F1);
  static const Color dreamPink = Color(0xFFEC4899);
  static const Color dreamYellow = Color(0xFFF59E0B);
  
  // Dimensions
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Tailles de police
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeXXXLarge = 32.0;
  
  // Durées d'animation
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  
  // Limites de l'application
  static const int maxDreamsPerDay = 5;
  static const int maxTitleLength = 100;
  static const int maxContentLength = 2000;
  static const int maxTagsPerDream = 10;
  
  // Messages d'erreur
  static const String errorGeneric = "Une erreur s'est produite. Veuillez réessayer.";
  static const String errorNetwork = "Erreur de connexion. Vérifiez votre connexion internet.";
  static const String errorPermission = "Permission refusée. Veuillez autoriser l'accès.";
  static const String errorStorage = "Erreur de stockage. Vérifiez l'espace disponible.";
  
  // Messages de succès
  static const String successDreamSaved = "Rêve sauvegardé avec succès !";
  static const String successDreamDeleted = "Rêve supprimé avec succès !";
  static const String successSettingsSaved = "Paramètres sauvegardés !";
  
  // Textes de l'interface
  static const String appName = "Dream Diary";
  static const String appTagline = "Votre journal de rêves intelligent";
  static const String addDreamTitle = "Ajouter un rêve";
  static const String editDreamTitle = "Modifier le rêve";
  static const String viewDreamTitle = "Détails du rêve";
  static const String settingsTitle = "Paramètres";
  static const String profileTitle = "Profil";
  static const String analyticsTitle = "Analyses";
  
  // Placeholders
  static const String dreamTitlePlaceholder = "Titre de votre rêve...";
  static const String dreamContentPlaceholder = "Décrivez votre rêve ici...";
  static const String searchPlaceholder = "Rechercher dans vos rêves...";
  
  // Hints
  static const String dreamTitleHint = "Donnez un titre à votre rêve";
  static const String dreamContentHint = "Décrivez votre rêve en détail";
  static const String dreamDateHint = "Date du rêve (optionnel)";
  static const String dreamTagsHint = "Ajoutez des tags pour organiser";
  
  // Boutons
  static const String saveButton = "Sauvegarder";
  static const String cancelButton = "Annuler";
  static const String deleteButton = "Supprimer";
  static const String editButton = "Modifier";
  static const String shareButton = "Partager";
  static const String addButton = "Ajouter";
  static const String nextButton = "Suivant";
  static const String previousButton = "Précédent";
  
  // Navigation
  static const String homeTab = "Accueil";
  static const String dreamsTab = "Rêves";
  static const String addTab = "Ajouter";
  static const String analyticsTab = "Analyses";
  static const String profileTab = "Profil";
}
