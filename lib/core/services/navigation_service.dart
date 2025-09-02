import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  
  // Singleton pattern
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();
  
  // Naviguer vers un écran spécifique
  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }
  
  // Revenir en arrière
  static void goBack() {
    navigatorKey.currentState?.pop();
  }
  
  // Naviguer et remplacer l'écran actuel
  static void navigateAndReplace(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
  
  // Naviguer et supprimer tous les écrans précédents
  static void navigateAndClear(String routeName) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }
}
