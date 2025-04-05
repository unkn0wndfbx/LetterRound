# 📱 Letter Round

**Letter Round** est une application mobile Flutter conçue pour cocher et évaluer les films que l'on a vu.

## ✨ Fonctionnalités principales

- 👋 **Écran d’introduction interactif** avec animations et transitions fluides (`introduction_screen`)
- 🌐 **Support multilingue** (FR & EN) avec détection automatique de la langue du téléphone et possibilité de la changer dans les paramètres
- 🧭 **Navigation intuitive** via une barre de navigation personnalisée (`BottomBar`)
- 💾 **Sauvegarde des données locales** avec `sqflite` et `shared_preferences`
- 🎨 **Thème visuel cohérent** avec gestion centralisée des couleurs et typographies personnalisées
- 📦 **Appel d'API** avec OMDb

## 🚀 Stack technique

- **Flutter SDK** `^3.7.0`
- **Localisation** : `flutter_localizations`, `intl`, `flutter_gen`
- **Stockage local** : `sqflite`, `shared_preferences`
- **UI/UX** : `introduction_screen`, `salomon_bottom_bar`, `awesome_snackbar_content`

## 📁 Assets

- Splash screen
- Logos adaptatifs
- Illustrations (watch, rating, etc.)
- Fichier JSON de crédits
- Police personnalisée : ArchivoBlack

## 📦 Installation

```bash
git clone https://github.com/unkn0wndfbx/LetterRound.git
cd letter_round
flutter pub get
flutter run
```
