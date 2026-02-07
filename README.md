# Flutter Live Shopping 🛍️

Une application de shopping en direct (live shopping) développée avec Flutter, permettant aux utilisateurs de regarder des événements en direct, découvrir des produits, et effectuer des achats en temps réel.

![Flutter](https://img.shields.io/badge/Flutter-3.10.8-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.8-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 📱 Fonctionnalités

- **Événements en Direct** : Visionnage de streams en direct avec compteur de spectateurs
- **Catalogue de Produits** : Navigation et recherche de produits
- **Panier d'Achat** : Gestion du panier avec badge de notification
- **Processus de Checkout** : Formulaire de livraison et sélection de paiement
- **Interface Responsive** : Design adaptatif pour mobile, tablette et web
- **Animations Fluides** : Hero animations et micro-interactions
- **Optimisations Performance** : Shimmer loading, RepaintBoundary, et caching d'images
- **Accessibilité** : Support des curseurs personnalisés et feedback visuel

##  Comment Lancer l'Application

### Prérequis

- Flutter SDK 3.10.8 ou supérieur
- Dart SDK 3.10.8 ou supérieur
- Un éditeur de code (VS Code, Android Studio, IntelliJ IDEA)
- Un émulateur ou appareil physique (iOS/Android) ou un navigateur web

### Installation

1. **Cloner le repository**
   ```bash
   git clone <repository-url>
   cd flutter_live_shopping
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Générer les fichiers de code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

### Lancement

#### Sur Mobile/Émulateur
```bash
flutter run
```

#### Sur Web
```bash
flutter run -d chrome
```

#### Build de Production
```bash
# Web
flutter build web --release
```

##  Structure du Projet

```
lib/
├── config/              # Configuration de l'application
│   ├── router.dart      # Configuration du routing (go_router)
│   └── theme_config.dart # Thème et couleurs
├── models/              # Modèles de données
│   ├── live_event.dart  # Modèle d'événement en direct
│   ├── product.dart     # Modèle de produit
│   ├── cart_item.dart   # Modèle d'article du panier
│   ├── order.dart       # Modèle de commande
│   └── seller.dart      # Modèle de vendeur
├── providers/           # State management (Provider)
│   ├── live_event_provider.dart
│   ├── cart_provider.dart
│   └── order_provider.dart
├── screens/             # Écrans de l'application
│   ├── home/           # Page d'accueil
│   ├── live/           # Page de visionnage en direct
│   ├── product/        # Page de détails produit
│   └── checkout/       # Pages de checkout
├── services/            # Services et API
│   ├── api_service.dart      # Service API mock
│   └── websocket_service.dart # Service WebSocket mock
├── widgets/             # Composants réutilisables
│   ├── common/         # Widgets communs
│   ├── live/           # Widgets spécifiques au live
│   ├── product/        # Widgets de produits
│   └── checkout/       # Widgets de checkout
└── main.dart           # Point d'entrée de l'application

assets/
├── mock-api-data.json  # Données mock pour l'API
└── images/             # Images et ressources
    └── live_logo.png   # Logo de l'application

test/
├── api_service_test.dart      # Tests du service API
├── websocket_service_test.dart # Tests du service WebSocket
└── widgets/                    # Tests de widgets
```

##  Choix Techniques

### State Management
- **Provider** : Choisi pour sa simplicité et son intégration native avec Flutter
- Gestion d'état centralisée pour les événements, le panier et les commandes
- ChangeNotifier pour la réactivité des données

### Routing
- **go_router** : Navigation déclarative avec support des deep links
- Routes typées et navigation programmatique
- Gestion des paramètres d'URL pour le web

### Packages Principaux

| Package | Version | Utilisation |
|---------|---------|-------------|
| `provider` | ^6.1.5 | State management |
| `go_router` | ^17.1.0 | Navigation et routing |
| `cached_network_image` | ^3.4.1 | Cache et optimisation d'images |
| `shimmer` | ^3.0.0 | Placeholders de chargement |
| `google_fonts` | ^8.0.1 | Typographie personnalisée |
| `font_awesome_flutter` | ^10.12.0 | Icônes |
| `intl` | ^0.20.2 | Formatage de dates et nombres |
| `toastification` | ^3.0.3 | Notifications toast |
| `dio` | ^5.9.1 | Client HTTP (préparé pour API réelle) |
| `json_annotation` | ^4.10.0 | Sérialisation JSON |

### Architecture

- **Pattern MVVM** : Séparation claire entre UI, logique métier et données
- **Services Mock** : Simulation d'API REST et WebSocket pour le développement
- **Composants Réutilisables** : Widgets modulaires et configurables
- **Responsive Design** : Adaptation automatique aux différentes tailles d'écran

### Optimisations Performance

1. **Images** :
   - `CachedNetworkImage` pour le cache automatique
   - `RepaintBoundary` pour isoler les repaints
   - Placeholders shimmer pour une meilleure UX

2. **Widgets** :
   - Utilisation de `const` constructors
   - Lazy loading des listes
   - Hero animations pour les transitions

3. **Web** :
   - Meta tags SEO optimisés
   - Preconnect aux domaines externes
   - Loading indicator personnalisé

##  Design et UX

- **Palette de Couleurs** : Orange (#FF6B35), Bleu (#004E89), Teal (#1A936F)
- **Typographie** : Google Fonts (Inter)
- **Animations** :
  - Hero animations pour la navigation produit
  - Hover effects sur les cartes produits
  - Transitions fluides entre les écrans
- **Feedback Visuel** :
  - Curseurs personnalisés (pointer sur éléments cliquables)
  - Ombres et élévations sur hover
  - Badges de notification en temps réel

##  Difficultés Rencontrées

### 1. Parsing des Données Mock
**Problème** : Erreur "type 'String' is not a subtype of type 'int'" lors du chargement initial.

**Solution** : Le panier dans `mock-api-data.json` était structuré comme un tableau d'objets utilisateur, mais le code tentait d'y accéder comme un objet direct. Correction de la logique de parsing dans `MockApiService`.

### 2. Gestion des États Asynchrones
**Problème** : Synchronisation entre les données du panier et l'affichage du badge.

**Solution** : Utilisation de `Consumer` widgets pour écouter les changements du `CartProvider` et mise à jour automatique de l'UI.

### 3. Hero Animations
**Problème** : Conflits de tags Hero entre les différentes instances de produits.

**Solution** : Utilisation de tags uniques basés sur l'ID du produit (`'product-${product.id}'`).

### 4. Responsive Design
**Problème** : Tailles de cartes incohérentes entre les sections (notamment "Past Streams").

**Solution** : Utilisation systématique de `AspectRatio` (16:9) pour garantir des dimensions uniformes.

### 5. Optimisation Web
**Problème** : Temps de chargement initial lent sur le web.

**Solution** : Ajout de preconnect links, optimisation des images, et implémentation d'un loading indicator personnalisé.

## 🚀 Améliorations Possibles

### Court Terme
1. **Authentification Réelle** : Intégration Firebase Auth ou OAuth
2. **API Backend** : Remplacement des services mock par une vraie API REST
3. **WebSocket Réel** : Connexion à un serveur WebSocket pour le chat en direct
4. **Paiement** : Intégration Stripe ou PayPal
5. **Notifications Push** : Firebase Cloud Messaging

### Moyen Terme
6. **Recherche Avancée** : Filtres multiples, tri, suggestions
7. **Favoris** : Sauvegarde de produits et événements
8. **Historique** : Consultation des commandes passées
9. **Profil Utilisateur** : Gestion des informations personnelles
10. **Mode Hors Ligne** : Cache local avec synchronisation

### Long Terme
11. **Streaming Vidéo Réel** : Intégration WebRTC ou service de streaming
12. **Chat en Direct** : Messages en temps réel avec modération
13. **Analytics** : Suivi du comportement utilisateur
14. **A/B Testing** : Optimisation de l'expérience utilisateur
15. **Internationalisation** : Support multilingue complet
16. **Accessibilité** : Screen reader, navigation clavier complète
17. **Tests E2E** : Tests d'intégration automatisés
18. **CI/CD** : Pipeline de déploiement automatisé

## 📊 Tests

### Lancer les Tests
```bash
# Tous les tests
flutter test

# Tests spécifiques
flutter test test/api_service_test.dart
flutter test test/widgets/widget_test.dart
```

### Analyse Statique
```bash
flutter analyze
```

### Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📸 Screenshots

> **Note** : Ajoutez vos captures d'écran dans un dossier `screenshots/` et référencez-les ici.

```markdown
### Page d'Accueil
![Home Screen](screenshots/home_screen.png)

### Événement en Direct
![Live Event](screenshots/live_event_screen.png)

### Détails Produit
![Product Details](screenshots/product_details_screen.png)

### Panier et Checkout
![Checkout](screenshots/checkout.png)
```

## 🎥 Vidéo de Démonstration

> **Note** : Enregistrez une vidéo de démonstration et ajoutez le lien ici.

[Voir la vidéo de démonstration](link-to-video)

## 📝 License

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👥 Contributeurs

- Votre Nom - Développeur Principal

## 🙏 Remerciements

- Flutter Team pour le framework
- Communauté Flutter pour les packages open-source
- Unsplash et Pravatar pour les images de démonstration

---

**Développé avec ❤️ et Flutter**
