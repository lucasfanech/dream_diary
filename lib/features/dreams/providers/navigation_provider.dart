import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  
  // Getters
  int get currentIndex => _currentIndex;
  
  // Changer l'onglet actuel
  void changeTab(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
  
  // Naviguer vers l'écran d'accueil
  void goToHome() {
    changeTab(0);
  }
  
  // Naviguer vers la liste des rêves
  void goToDreamsList() {
    changeTab(1);
  }
  
  // Naviguer vers l'ajout de rêve
  void goToAddDream() {
    changeTab(2);
  }
  
  // Naviguer vers les analyses
  void goToAnalytics() {
    changeTab(3);
  }
  
  // Naviguer vers le profil
  void goToProfile() {
    changeTab(4);
  }
}
