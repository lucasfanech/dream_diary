# Architecture Phase 3 - Dream Diary

## Diagramme d'Architecture

```mermaid
graph TB
    subgraph "Interface Utilisateur"
        A[Écran d'Analyses] --> B[Écran d'Analyse Détaillée]
        C[Liste des Rêves] --> B
        B --> D[Onglet Vue d'ensemble]
        B --> E[Onglet Symboles]
        B --> F[Onglet Émotions]
        B --> G[Onglet Thèmes]
        B --> H[Onglet Lucidité]
    end
    
    subgraph "Widgets Réutilisables"
        I[AnalysisCard]
        J[EmotionIndicator]
        K[TagChip]
        L[ProgressChart]
        M[RecommendationCard]
    end
    
    subgraph "Services IA"
        N[AIService]
        O[TagService]
        P[EmotionAnalysisService]
    end
    
    subgraph "Analyses IA"
        Q[Analyse Symbolique]
        R[Détection Émotionnelle]
        S[Catégorisation Tags]
        T[Thèmes Récurrents]
        U[Patterns Lucidité]
    end
    
    subgraph "Données"
        V[Modèle Dream]
        W[Analyses IA]
        X[Statistiques]
    end
    
    A --> N
    B --> I
    B --> J
    B --> K
    B --> L
    B --> M
    
    N --> Q
    N --> R
    O --> S
    P --> T
    P --> U
    
    Q --> W
    R --> W
    S --> W
    T --> W
    U --> W
    
    V --> W
    W --> X
```

## Flux de Données

```mermaid
sequenceDiagram
    participant U as Utilisateur
    participant UI as Interface
    participant P as Provider
    participant AI as AIService
    participant T as TagService
    participant E as EmotionService
    participant S as Storage
    
    U->>UI: Sélectionne un rêve
    UI->>P: Demande analyse détaillée
    P->>AI: enhanceDream()
    AI->>AI: analyzeDream()
    AI->>AI: analyzeSymbols()
    AI->>AI: analyzeEmotions()
    AI->>T: categorizeDream()
    AI->>E: analyzeRecurringThemes()
    AI-->>P: Rêve enrichi
    P->>S: Sauvegarde
    P-->>UI: Données mises à jour
    UI-->>U: Affichage analyse détaillée
```

## Structure des Analyses

```mermaid
graph LR
    subgraph "Analyse de Base"
        A1[Émotions]
        A2[Thèmes]
        A3[Symboles]
        A4[Interprétation]
        A5[Type de Rêve]
    end
    
    subgraph "Analyse Symbolique"
        B1[Symboles Primaires]
        B2[Archétypes Jungiens]
        B3[Analyse Couleurs]
        B4[Symboles Universels]
        B5[Symboles Personnels]
    end
    
    subgraph "Analyse Émotionnelle"
        C1[Émotions Primaires]
        C2[Parcours Émotionnel]
        C3[Conflits Émotionnels]
        C4[Connexion Vie Éveillée]
        C5[Croissance Personnelle]
    end
    
    subgraph "Analyse Tags"
        D1[Catégorisation]
        D2[Tags Intelligents]
        D3[Patterns Tags]
        D4[Suggestions]
        D5[Évolution]
    end
    
    subgraph "Analyse Thèmes"
        E1[Thèmes Récurrents]
        E2[Évolution Temporelle]
        E3[Connexions Thématiques]
        E4[Clusters]
        E5[Progression]
    end
    
    A1 --> C1
    A2 --> E1
    A3 --> B1
    A4 --> C4
    A5 --> E5
```

## Services et Responsabilités

### AIService (Amélioré)
- **Analyse de base** : Émotions, thèmes, symboles
- **Analyse symbolique** : Jung, Freud, archétypes
- **Analyse émotionnelle** : Détection avancée
- **Thèmes récurrents** : Comparaison historique

### TagService (Nouveau)
- **Catégorisation** : Classification multi-axes
- **Tags intelligents** : Avec contexte
- **Patterns de tags** : Analyse des tendances
- **Suggestions** : Tags manquants

### EmotionAnalysisService (Nouveau)
- **Évolution émotionnelle** : Analyse temporelle
- **Thèmes récurrents** : Détection automatique
- **Patterns de lucidité** : Analyse spécialisée
- **Recommandations** : Conseils personnalisés

## Interface Utilisateur

### Écran d'Analyse Détaillée
- **5 onglets** : Vue d'ensemble, Symboles, Émotions, Thèmes, Lucidité
- **Navigation fluide** : TabController avec animations
- **Widgets réutilisables** : Composants modulaires
- **Actions** : Actualisation, partage, navigation

### Widgets Spécialisés
- **AnalysisCard** : Cartes d'analyse standardisées
- **EmotionIndicator** : Visualisation des émotions
- **TagChip** : Tags interactifs
- **ProgressChart** : Graphiques de progression
- **RecommendationCard** : Cartes de conseils

## Intégration avec Phase 2

### Données Existantes
- **Modèle Dream** : Champ `aiAnalysis` étendu
- **Provider** : Nouvelles méthodes d'analyse
- **Storage** : Compatible avec les données existantes
- **Navigation** : Intégration transparente

### Améliorations
- **Analyses plus riches** : Données structurées
- **Interface améliorée** : Navigation intuitive
- **Performance** : Optimisations IA
- **UX** : Feedback utilisateur

## Prochaines Étapes (Phase 4)

### Visualisations Avancées
- **Graphiques interactifs** : fl_chart
- **Dashboard** : Vue d'ensemble
- **Timeline** : Évolution temporelle
- **Métriques** : KPIs utilisateur

### Optimisations
- **Parsing JSON** : Implémentation réelle
- **Cache** : Optimisation des performances
- **Offline** : Mode déconnecté
- **Sync** : Synchronisation cloud
