import 'package:flutter/material.dart';
import 'core/constants/app_theme.dart';
import 'core/services/storage_service.dart';
import 'features/dreams/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser le service de stockage
  try {
    await StorageService().initialize();
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation du stockage: $e');
  }
  
  runApp(const DreamDiaryApp());
}

class DreamDiaryApp extends StatelessWidget {
  const DreamDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dream Diary',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
