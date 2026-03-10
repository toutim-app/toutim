# Toutim

**Vos collections, votre univers.**

Toutim est une application mobile (Android/iOS) gratuite et open source pour organiser toutes vos collections : livres, LEGO, films, vinyles, recettes et bien plus.

## Fonctionnalites

- **Champs dynamiques** — Plus de 25 types de champs (texte, dates, codes-barres, sliders, checklists, images...) pour decrire vos items avec precision
- **Templates pre-configures** — Demarrez en un clic avec des modeles pour livres, films, LEGO, vins, jeux video, plantes et bien d'autres
- **Recherche globale** — Retrouvez n'importe quel item en un instant a travers toutes vos collections
- **Local-first** — Vos donnees restent sur votre appareil, aucun compte requis
- **Sync optionnelle** — Synchronisez entre vos appareils via le serveur officiel ou votre propre instance auto-hebergee
- **Design soigne** — Interface Material 3 adaptative avec mode sombre

## Stack technique

| Composant | Choix |
|-----------|-------|
| Framework | Flutter |
| State Management | Riverpod + codegen |
| Base locale | Drift (SQLite) |
| Navigation | GoRouter |
| Serialisation | Freezed + json_serializable |
| Theming | flex_color_scheme + Google Fonts |

## Demarrage rapide

```bash
# Cloner le depot
git clone https://codeberg.org/toutim/toutim.git
cd toutim

# Installer les dependances
flutter pub get

# Generer le code (Freezed, Riverpod, Drift)
dart run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

## Projets lies

| Depot | Description |
|-------|-------------|
| [toutim](https://codeberg.org/toutim/toutim) | Application mobile (Flutter) |
| [toutim-server](https://codeberg.org/toutim/toutim-server) | Serveur de synchronisation (Go) |

## Licence

Ce projet est open source. Consultez le fichier [LICENSE](LICENSE) pour plus de details.
