# Mom Preduct

Application Flutter de simulation de prédictions sportives.

## Important

Les données et prédictions de cette version sont des démonstrations. Le RNG est pseudo-aléatoire et ne permet pas de connaître ou garantir le résultat réel d'un jeu virtuel.

## Installation

1. Installer Flutter et le SDK Android.
2. À la racine du projet :
   flutter pub get
3. Vérifier :
   flutter doctor
4. Compiler :
   flutter build apk --release

APK attendu :
build/app/outputs/flutter-apk/app-release.apk

## Contenu

- English League 2 (données de démonstration)
- Coupe d’Afrique (données de démonstration)
- Sélection domicile/extérieur
- Saisie des cotes
- Simulation RNG + probabilités dérivées des cotes
- Historique SQLite
- Mode clair/sombre selon le système

Gemini/Claude et les données live ne sont pas inclus dans cette version locale. Ils nécessitent des API et, pour les clés secrètes, un backend sécurisé.
