import 'package:flutter/material.dart';
import 'app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.surfaceColor,
        foregroundColor: AppConstants.textPrimaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: AppConstants.fontSizeXXXLarge,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: AppConstants.fontSizeXXLarge,
          fontWeight: FontWeight.bold,
          color: AppConstants.textPrimaryColor,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineLarge: TextStyle(
          fontSize: AppConstants.fontSizeXLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: AppConstants.fontSizeLarge,
          fontWeight: FontWeight.w600,
          color: AppConstants.textPrimaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.fontSizeLarge,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.fontSizeLarge,
          fontWeight: FontWeight.normal,
          color: AppConstants.textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.normal,
          color: AppConstants.textPrimaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.normal,
          color: AppConstants.textSecondaryColor,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
          color: AppConstants.textPrimaryColor,
        ),
        labelMedium: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w500,
          color: AppConstants.textSecondaryColor,
        ),
        labelSmall: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.w500,
          color: AppConstants.textSecondaryColor,
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
            vertical: AppConstants.paddingSmall,
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.textSecondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.textSecondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          borderSide: const BorderSide(color: AppConstants.errorColor),
        ),
        contentPadding: const EdgeInsets.all(AppConstants.paddingMedium),
        hintStyle: const TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: AppConstants.fontSizeMedium,
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: AppConstants.surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
        margin: const EdgeInsets.all(AppConstants.paddingSmall),
      ),
      
      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.surfaceColor,
        selectedItemColor: AppConstants.primaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Tab Bar
      tabBarTheme: const TabBarThemeData(
        labelColor: AppConstants.primaryColor,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        indicatorColor: AppConstants.primaryColor,
        labelStyle: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: AppConstants.textSecondaryColor,
        thickness: 1,
        space: AppConstants.paddingMedium,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppConstants.textPrimaryColor,
        size: 24,
      ),
      
      // Primary Icon Theme
      primaryIconTheme: const IconThemeData(
        color: AppConstants.primaryColor,
        size: 24,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.dark,
      ),
      
      // Pour l'instant, on utilise le thème clair
      // Le thème sombre sera implémenté plus tard
      scaffoldBackgroundColor: const Color(0xFF1A202C),
      textTheme: lightTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
