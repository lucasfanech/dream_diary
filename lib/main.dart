import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/config_service.dart';
import 'features/dreams/screens/main_screen.dart';
import 'features/dreams/providers/dream_provider.dart';
import 'features/dreams/providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Charger la configuration
  try {
    await ConfigService.initialize();
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation de la configuration: $e');
  }
  
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DreamProvider()..initialize()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: MaterialApp(
        title: 'Dream Diary',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
