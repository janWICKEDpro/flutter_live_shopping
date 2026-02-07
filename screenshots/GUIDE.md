# Guide pour Capturer les Screenshots

## Méthode 1 : Depuis l'Émulateur/Simulateur

### Android Studio
1. Lancez l'application sur l'émulateur Android
2. Cliquez sur l'icône de caméra dans la barre d'outils de l'émulateur
3. Les screenshots sont sauvegardés automatiquement

### iOS Simulator
1. Lancez l'application sur le simulateur iOS
2. Utilisez `Cmd + S` pour prendre un screenshot
3. Les images sont sauvegardées sur le bureau

## Méthode 2 : Depuis Flutter DevTools

```bash
# Lancer l'application
flutter run

# Dans une autre fenêtre de terminal
flutter screenshot
```

## Méthode 3 : Programmatique

Ajoutez ce code temporairement dans votre application :

```dart
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

Future<void> captureScreenshot(GlobalKey key, String filename) async {
  RenderRepaintBoundary boundary = 
      key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  
  final file = File('screenshots/$filename.png');
  await file.writeAsBytes(pngBytes);
}
```

## Screenshots Recommandés

Capturez les écrans suivants :

1. **home_screen.png** - Page d'accueil avec événements
2. **live_event.png** - Événement en direct avec chat
3. **product_details.png** - Page de détails produit
4. **cart.png** - Panier avec articles
5. **checkout.png** - Page de checkout
6. **search.png** - Recherche de produits
7. **mobile_responsive.png** - Vue mobile
8. **tablet_responsive.png** - Vue tablette

## Enregistrer une Vidéo de Démonstration

### Méthode 1 : Enregistrement d'Écran macOS
1. Appuyez sur `Cmd + Shift + 5`
2. Sélectionnez "Enregistrer la portion sélectionnée"
3. Sélectionnez la fenêtre de l'émulateur
4. Cliquez sur "Enregistrer"

### Méthode 2 : OBS Studio (Gratuit)
1. Téléchargez OBS Studio
2. Configurez une source de capture de fenêtre
3. Enregistrez votre démonstration

### Méthode 3 : QuickTime Player (macOS)
1. Ouvrez QuickTime Player
2. Fichier > Nouvel enregistrement d'écran
3. Sélectionnez la zone à enregistrer

## Conseils pour de Bons Screenshots

- Utilisez des données réalistes et variées
- Assurez-vous que l'interface est en bon état (pas d'erreurs)
- Capturez différentes résolutions (mobile, tablette, desktop)
- Utilisez un fond d'écran neutre
- Évitez les informations sensibles dans les screenshots

## Héberger la Vidéo

Options gratuites :
- YouTube (unlisted)
- Vimeo
- Google Drive (lien public)
- Loom (pour démos rapides)
