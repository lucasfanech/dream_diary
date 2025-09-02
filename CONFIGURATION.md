# Configuration de Dream Diary

## 🔧 Configuration des Variables d'Environnement

Dream Diary utilise un fichier `.env` pour stocker les clés API et autres configurations sensibles de manière sécurisée.

### 📁 Structure des Fichiers

```
dream_diary/
├── .env.example          # Template de configuration
├── .env                  # Configuration réelle (ignoré par Git)
└── lib/core/services/
    ├── config_service.dart    # Service de gestion de la configuration
    └── ai_service.dart        # Service IA utilisant la configuration
```

### 🚀 Configuration Rapide

1. **Copier le template** :
   ```bash
   cp .env.example .env
   ```

2. **Éditer le fichier .env** :
   ```bash
   nano .env  # ou votre éditeur préféré
   ```

3. **Configurer votre clé API Gemini** :
   ```env
   GEMINI_API_KEY=votre_clé_api_ici
   ```

4. **Redémarrer l'application** :
   ```bash
   flutter run
   ```

### 🔑 Obtenir une Clé API Gemini

1. Rendez-vous sur [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Connectez-vous avec votre compte Google
3. Cliquez sur "Create API Key"
4. Copiez la clé générée
5. Collez-la dans votre fichier `.env`

### 📋 Variables Disponibles

| Variable | Description | Valeur par défaut |
|----------|-------------|-------------------|
| `GEMINI_API_KEY` | Clé API pour Gemini | `YOUR_GEMINI_API_KEY` |
| `GEMINI_TEXT_MODEL` | Modèle pour le texte | `gemini-2.0-flash-exp` |
| `GEMINI_IMAGE_MODEL` | Modèle pour les images | `gemini-2.0-flash-exp` |
| `MAX_REQUESTS_PER_MINUTE` | Limite de requêtes | `60` |
| `MAX_TOKENS_PER_REQUEST` | Limite de tokens | `1024` |
| `REQUEST_TIMEOUT_SECONDS` | Timeout des requêtes | `30` |

### 🔒 Sécurité

- ✅ Le fichier `.env` est automatiquement ignoré par Git
- ✅ Les clés API ne sont jamais commitées dans le repository
- ✅ Chaque développeur peut avoir sa propre configuration
- ✅ Le fichier `.env.example` sert de template public

### 🛠️ Utilisation dans le Code

```dart
import 'package:dream_diary/core/services/config_service.dart';

// Vérifier si la clé API est configurée
if (ConfigService.isApiKeyConfigured) {
  // Utiliser les fonctionnalités IA
}

// Obtenir une variable d'environnement
String apiKey = ConfigService.getEnv('GEMINI_API_KEY');

// Obtenir un entier
int timeout = ConfigService.getEnvInt('REQUEST_TIMEOUT_SECONDS', defaultValue: 30);

// Obtenir un booléen
bool debugMode = ConfigService.getEnvBool('DEBUG_MODE', defaultValue: false);
```

### 🐛 Dépannage

#### Erreur : "Clé API manquante"
- Vérifiez que le fichier `.env` existe
- Vérifiez que `GEMINI_API_KEY` est défini
- Vérifiez que la clé n'est pas `YOUR_GEMINI_API_KEY`

#### Erreur : "Fichier .env non trouvé"
- Copiez `.env.example` vers `.env`
- Vérifiez que le fichier est à la racine du projet
- Redémarrez l'application

#### Erreur : "Configuration non initialisée"
- Vérifiez que `ConfigService.initialize()` est appelé dans `main()`
- Vérifiez les logs de console pour plus de détails

### 📱 Interface Utilisateur

L'application affiche automatiquement le statut de la configuration dans l'écran de profil :

- ✅ **Vert** : Clé API configurée et fonctionnelle
- ⚠️ **Orange** : Clé API manquante ou invalide
- ℹ️ **Bouton "Instructions"** : Guide de configuration

### 🔄 Mise à Jour de la Configuration

Pour ajouter de nouvelles variables :

1. **Ajouter au .env.example** :
   ```env
   NOUVELLE_VARIABLE=valeur_par_défaut
   ```

2. **Utiliser dans le code** :
   ```dart
   String valeur = ConfigService.getEnv('NOUVELLE_VARIABLE');
   ```

3. **Documenter dans ce fichier**

### 📚 Ressources

- [Google AI Studio](https://makersuite.google.com/)
- [Flutter DotEnv Package](https://pub.dev/packages/flutter_dotenv)
- [Documentation Gemini API](https://ai.google.dev/docs)

---

**Note** : Cette configuration est optionnelle. L'application fonctionne sans IA, mais avec des fonctionnalités limitées.
