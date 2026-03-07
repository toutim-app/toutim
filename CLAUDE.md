# CLAUDE.md — Toutim Project Guidelines

> Ce fichier guide Claude (et Claude Code) pour travailler efficacement sur le projet Toutim.

## 🎯 Projet

**Toutim** est une application Flutter (Android/iOS) de gestion de collections universelles avec un moteur de champs dynamiques. L'utilisateur crée des collections (livres, LEGO, films, cartes de fidélité...), définit un schéma de champs personnalisés, puis ajoute des items.

- Application gratuite
- Local-first avec sync serveur optionnelle future
- UI soignée, Material 3 adaptatif

## 🏗️ Architecture

### Stack technique

| Composant        | Choix                            | Version min |
| ---------------- | -------------------------------- | ----------- |
| Framework        | Flutter                          | 3.x         |
| State Management | Riverpod + codegen               | 2.5+        |
| Base locale      | Drift (SQLite)                   | 2.x         |
| Navigation       | GoRouter                         | 14+         |
| Sérialisation    | Freezed + json_serializable      | 2.4+        |
| Theming          | flex_color_scheme + Google Fonts | 7.3+        |
| Icônes           | Lucide Icons ou Phosphor Icons   | —           |

### Structure des dossiers

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, routing, theming
├── core/
│   ├── theme/                        # Thèmes, couleurs, typographie
│   ├── router/                       # GoRouter config
│   ├── constants/                    # Constantes globales
│   ├── extensions/                   # Extensions Dart (context, etc.)
│   └── utils/                        # Utilitaires (json, date, etc.)
├── data/
│   ├── models/                       # Modèles Freezed
│   │   └── enums/                    # FieldType, ViewMode, SortDirection
│   ├── repositories/                 # Abstractions accès données
│   └── datasources/
│       ├── local/                    # Drift datasources
│       └── remote/                   # Futur : sync serveur
├── features/                         # Feature-first
│   ├── home/
│   ├── collection/
│   ├── item/
│   ├── field_editor/
│   ├── search/
│   ├── settings/
│   └── import_export/
└── shared/
    └── widgets/                      # Widgets réutilisables
```

### Patterns obligatoires

- **Feature-first** : chaque feature a ses propres `screens/`, `widgets/`, `providers/`
- **Repository pattern** : les features n'accèdent jamais directement aux datasources
- **Immutabilité** : tous les modèles de données utilisent Freezed
- **Riverpod codegen** : utiliser `@riverpod` annotation, pas les providers manuels
- **Separation of concerns** : UI → Provider → Repository → Datasource

## 🎨 Charte Graphique

### Palette de couleurs

```dart
// Couleurs principales — Color-Coding par catégorie
static const blue       = Color(0xFF2D9CDB); // Interface, navigation, actions primaires
static const teal       = Color(0xFF2ABFBF); // Culture, savoir (livres, vinyles)
static const orange     = Color(0xFFF2994A); // Divertissement, actions secondaires
static const green      = Color(0xFF27AE60); // Validation, succès, nature/finance
static const yellow     = Color(0xFFF2C94C); // Favoris, cartes fidélité (aspect gold)
static const red        = Color(0xFFEB5757); // Erreur, suppression, danger
static const purple     = Color(0xFF9B51E0); // Catégories spéciales

// Texte — JAMAIS de noir pur (#000000)
static const textPrimary   = Color(0xFF333333); // Gris anthracite
static const textSecondary = Color(0xFF666666);
static const textTertiary  = Color(0xFF999999);

// Surfaces
static const surface    = Color(0xFFFFFFFF);
static const surfaceAlt = Color(0xFFF8F9FA);
static const border     = Color(0xFFE8E8E8);
```

### Dark Mode

```dart
static const darkSurface    = Color(0xFF1A1A2E);
static const darkSurfaceAlt = Color(0xFF222236);
static const darkBorder     = Color(0xFF2E2E44);
static const darkText       = Color(0xFFE8E8E8);
// Les couleurs principales sont légèrement éclaircies en dark mode
// Les backgrounds de chips/tags utilisent la couleur à 15-20% d'opacité
```

### Typographie

```dart
// Titres et headers : Quicksand (Google Fonts)
// - Bold (700) pour les titres principaux
// - SemiBold (600) pour les sous-titres
//
// Corps de texte : Inter (Google Fonts)
// - Regular (400) pour le texte courant
// - Medium (500) pour les labels
// - SemiBold (600) pour les valeurs importantes
```

### Composants UI

- **Border Radius** : `BorderRadius.circular(16)` sur les cartes, `BorderRadius.circular(12)` sur les boutons et champs, `BorderRadius.circular(10)` sur les petits éléments
- **Élévation** : légère, `elevation: 2` max, préférer les ombres via `BoxShadow` avec la couleur bleue en opacité (`rgba(45, 156, 219, 0.08)`)
- **Cards** : fond blanc, border 1px `#E8E8E8`, border-radius 16, ombre subtile
- **FAB** : border-radius 16 (pas rond), couleur contextuelle (bleu sur home, couleur de la collection dans une collection), ombre colorée assortie
- **Icônes de champs** : chaque type de champ a une icône distinctive dans un conteneur arrondi avec fond coloré à faible opacité
- **Style** : Flat avec léger volume, coins arrondis partout, transitions fluides

### Iconographie

- Utiliser **Lucide Icons** ou **Phosphor Icons** (pas Material Icons par défaut)
- **UI générale** (navigation, actions, champs) : style **outline** (lignes fines, épuré, moderne)
- **Avatars/badges de collection** : style **filled/flat** (rempli, coloré) — cohérent avec le logo
- Chaque type de champ dynamique a une icône dédiée

## ⚡ Moteur de Champs Dynamiques

### Types supportés

```
text, textArea, number, decimal, currency, boolean, date, dateTime, time,
image, barcode, qrCode, rating, url, email, phone,
select, multiSelect, tags, color, location, slider, range,
duration, checklist, tracker
```

### Architecture du moteur

Chaque type de champ a :

1. Un `FieldDefinition` (schéma : nom, type, options, contraintes)
2. Un `FieldValue` (valeur stockée en JSON dynamique)
3. Un `FieldRenderer` en mode **edit** (widget de saisie)
4. Un `FieldRenderer` en mode **display** (widget d'affichage)

Les renderers sont résolus par une **factory** basée sur le `FieldType` enum :

```dart
// lib/features/item/widgets/field_renderers/field_renderer.dart
Widget buildFieldRenderer(FieldDefinition def, FieldValue? value, {required bool editMode});
```

### Modèle FieldDefinition

```dart
@freezed
class FieldDefinition with _$FieldDefinition {
  const factory FieldDefinition({
    required String id,
    required String name,
    required FieldType type,
    required int sortOrder,
    @Default(false) bool required,
    @Default(true) bool showInList,
    @Default(true) bool showInCard,
    @Default(true) bool searchable,
    @Default(false) bool sortable,
    dynamic defaultValue,
    @Default({}) Map<String, dynamic> options,
  }) = _FieldDefinition;
}
```

## 📦 Templates pré-configurés

Proposés à l'onboarding pour démarrer rapidement. Chaque template a une **couleur associée** utilisée pour le badge, le FAB contextuel et les accents dans la vue collection :

| Template | Couleur | Champs |
| --- | --- | --- |
| 📚 Livres | `teal` | Titre, Auteur, ISBN, Genre, Note, Lu ?, Couverture |
| 🧱 LEGO | `orange` | Nom, N° Set, Thème, Pièces, Prix, Complet ? |
| 🎬 Films | `green` | Titre, Réalisateur, Année, Genre, Note, Vu ?, Affiche |
| 🍷 Vins | `red` | Nom, Domaine, Année, Cépage, Note, Photo |
| 🍳 Recettes | `orange` | Nom, Catégorie, Temps prépa/cuisson, Portions, Ingrédients, Instructions, Note, Photo |
| 💳 Cartes fidélité | `yellow` | Enseigne, N° Carte, Logo, Expiration |
| 🎮 Jeux vidéo | `purple` | Titre, Plateforme, Genre, Note, Terminé ?, Jaquette |
| 🌱 Plantes | `green` | Nom, Espèce, Photo, Date achat, Arrosage, Emplacement |
| 🔧 Outils | `orange` | Nom, Marque, Photo, Catégorie, Emplacement, Prêté à ? |
| 📀 Vinyles | `teal` | Artiste, Album, Année, Genre, Label, État, Photo |
| 🏅 Collections | `blue` | Nom, Catégorie, Année, État, Valeur, Photo, Notes |
| 💪 Musculation | `blue` | Machine, Groupe musculaire, Poids (tracker), Photo |

> Pour les collections personnalisées, l'utilisateur choisit sa couleur parmi la palette.

## ✅ Conventions de Code

### Naming

- **Fichiers** : `snake_case.dart`
- **Classes** : `PascalCase`
- **Variables/fonctions** : `camelCase`
- **Constantes** : `camelCase` (Dart convention, pas SCREAMING_CASE)
- **Enums** : `PascalCase` pour le type, `camelCase` pour les valeurs

### Langue

- **Code** (classes, variables, commentaires techniques) : **anglais**
- **UI** (labels, messages, textes affichés) : **français** par défaut, i18n-ready
- **Documentation** : français

### Dart/Flutter

- Utiliser `const` constructors systématiquement quand possible
- Préférer les `final` variables
- Pas de `dynamic` sauf dans les valeurs de champs dynamiques (FieldValue.value)
- Utiliser les extensions pour enrichir les types existants
- Préférer `switch` expressions (Dart 3) aux chaînes de `if/else`
- Toujours typer explicitement les retours de fonctions publiques

### State Management (Riverpod)

- Utiliser l'annotation `@riverpod` avec code generation
- Un fichier provider par feature/écran
- Les providers ne contiennent pas de logique métier, ils délèguent aux repositories
- Utiliser `AsyncValue` pour les états async, jamais de `FutureBuilder`

### Commits

- Format : conventional commits
- `feat:` nouvelle fonctionnalité
- `fix:` correction de bug
- `refactor:` refactoring sans changement fonctionnel
- `style:` changements UI/cosmétiques
- `docs:` documentation
- `test:` ajout/modification de tests
- `chore:` maintenance, dépendances

## 🚫 À ne PAS faire

- Ne jamais utiliser `setState` — toujours Riverpod
- Ne jamais accéder à Drift/la DB directement depuis un widget ou provider — passer par le repository
- Ne jamais utiliser le noir pur `#000000` pour le texte — utiliser `#333333`
- Ne jamais hardcoder des strings UI — les centraliser pour la future i18n
- Ne pas utiliser Material Icons par défaut — préférer Lucide/Phosphor
- Ne pas créer de widgets God-class > 200 lignes — extraire en sous-widgets
- Ne pas mélanger logique métier et UI dans le même fichier
- Ne pas utiliser `late` sans bonne raison — préférer les nullable avec null-check

## 🔮 Futur (hors scope MVP)

- Sync serveur avec API REST (Go)
- Auth utilisateur
- Partage de collections entre utilisateurs
- Widgets home screen (Android/iOS)
- Mode hors-ligne avancé avec résolution de conflits
- Import depuis CSV/Excel
- Reconnaissance d'image pour remplir automatiquement les champs
