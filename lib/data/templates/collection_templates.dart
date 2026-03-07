import '../models/enums/field_type.dart';

/// Describes a single field within a template.
class TemplateField {
  final String name;
  final FieldType type;
  final bool isRequired;
  final bool showInList;
  final bool showInCard;
  final bool searchable;
  final bool sortable;
  final Map<String, dynamic> options;

  const TemplateField({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.showInList = true,
    this.showInCard = true,
    this.searchable = true,
    this.sortable = false,
    this.options = const {},
  });
}

/// Describes a pre-configured collection template.
class CollectionTemplate {
  final String id;
  final String name;
  final String emoji;
  final String colorKey;
  final String? description;
  final List<TemplateField> fields;

  const CollectionTemplate({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorKey,
    this.description,
    required this.fields,
  });
}

/// All available collection templates.
abstract final class CollectionTemplates {
  static const List<CollectionTemplate> all = [
    books,
    lego,
    movies,
    wines,
    recipes,
    loyaltyCards,
    videoGames,
    plants,
    tools,
    vinyls,
    collections,
    gym,
  ];

  static const books = CollectionTemplate(
    id: 'books',
    name: 'Livres',
    emoji: '\u{1F4DA}',
    colorKey: 'teal',
    description: 'Votre bibliothèque personnelle',
    fields: [
      TemplateField(
          name: 'Titre', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'Auteur', type: FieldType.text, sortable: true),
      TemplateField(
          name: 'ISBN', type: FieldType.barcode, showInCard: false),
      TemplateField(
        name: 'Genre',
        type: FieldType.select,
        options: {
          'options': [
            'Roman',
            'SF',
            'Fantasy',
            'Polar',
            'BD',
            'Essai',
            'Biographie',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Note', type: FieldType.rating),
      TemplateField(name: 'Lu ?', type: FieldType.boolean),
      TemplateField(
          name: 'Couverture', type: FieldType.image, showInList: false),
    ],
  );

  static const lego = CollectionTemplate(
    id: 'lego',
    name: 'LEGO',
    emoji: '\u{1F9F1}',
    colorKey: 'orange',
    description: 'Vos sets LEGO',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'N\u00B0 Set', type: FieldType.text),
      TemplateField(
        name: 'Thème',
        type: FieldType.select,
        options: {
          'options': [
            'City',
            'Technic',
            'Star Wars',
            'Creator',
            'Ninjago',
            'Friends',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Pièces', type: FieldType.number, sortable: true),
      TemplateField(name: 'Prix', type: FieldType.currency),
      TemplateField(name: 'Complet ?', type: FieldType.boolean),
    ],
  );

  static const movies = CollectionTemplate(
    id: 'movies',
    name: 'Films',
    emoji: '\u{1F3AC}',
    colorKey: 'green',
    description: 'Votre filmothèque',
    fields: [
      TemplateField(
          name: 'Titre', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(
          name: 'Réalisateur', type: FieldType.text, sortable: true),
      TemplateField(name: 'Année', type: FieldType.number, sortable: true),
      TemplateField(
        name: 'Genre',
        type: FieldType.select,
        options: {
          'options': [
            'Action',
            'Comédie',
            'Drame',
            'Horreur',
            'SF',
            'Animation',
            'Documentaire',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Note', type: FieldType.rating),
      TemplateField(name: 'Vu ?', type: FieldType.boolean),
      TemplateField(
          name: 'Affiche', type: FieldType.image, showInList: false),
    ],
  );

  static const wines = CollectionTemplate(
    id: 'wines',
    name: 'Vins',
    emoji: '\u{1F377}',
    colorKey: 'red',
    description: 'Votre cave à vins',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'Domaine', type: FieldType.text, sortable: true),
      TemplateField(name: 'Année', type: FieldType.number, sortable: true),
      TemplateField(
        name: 'Cépage',
        type: FieldType.select,
        options: {
          'options': [
            'Cabernet Sauvignon',
            'Merlot',
            'Pinot Noir',
            'Chardonnay',
            'Sauvignon Blanc',
            'Syrah',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Note', type: FieldType.rating),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
    ],
  );

  static const recipes = CollectionTemplate(
    id: 'recipes',
    name: 'Recettes',
    emoji: '\u{1F373}',
    colorKey: 'orange',
    description: 'Vos recettes de cuisine',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(
        name: 'Catégorie',
        type: FieldType.select,
        options: {
          'options': [
            'Entrée',
            'Plat',
            'Dessert',
            'Apéritif',
            'Boisson',
            'Sauce',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Temps de préparation', type: FieldType.text),
      TemplateField(name: 'Temps de cuisson', type: FieldType.text),
      TemplateField(
          name: 'Portions', type: FieldType.number),
      TemplateField(
          name: 'Ingrédients', type: FieldType.textArea, showInCard: false),
      TemplateField(
          name: 'Instructions', type: FieldType.textArea, showInCard: false),
      TemplateField(name: 'Note', type: FieldType.rating),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
    ],
  );

  static const loyaltyCards = CollectionTemplate(
    id: 'loyalty_cards',
    name: 'Cartes fidélité',
    emoji: '\u{1F4B3}',
    colorKey: 'yellow',
    description: 'Vos cartes de fidélité',
    fields: [
      TemplateField(
          name: 'Enseigne',
          type: FieldType.text,
          isRequired: true,
          sortable: true),
      TemplateField(name: 'N\u00B0 Carte', type: FieldType.barcode),
      TemplateField(
          name: 'Logo', type: FieldType.image, showInList: false),
      TemplateField(name: 'Expiration', type: FieldType.date),
    ],
  );

  static const videoGames = CollectionTemplate(
    id: 'video_games',
    name: 'Jeux vidéo',
    emoji: '\u{1F3AE}',
    colorKey: 'purple',
    description: 'Votre ludothèque',
    fields: [
      TemplateField(
          name: 'Titre', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(
        name: 'Plateforme',
        type: FieldType.select,
        options: {
          'options': ['PC', 'PS5', 'Xbox', 'Switch', 'Mobile', 'Autre']
        },
      ),
      TemplateField(
        name: 'Genre',
        type: FieldType.select,
        options: {
          'options': [
            'Action',
            'RPG',
            'FPS',
            'Stratégie',
            'Sport',
            'Aventure',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Note', type: FieldType.rating),
      TemplateField(name: 'Terminé ?', type: FieldType.boolean),
      TemplateField(
          name: 'Jaquette', type: FieldType.image, showInList: false),
    ],
  );

  static const plants = CollectionTemplate(
    id: 'plants',
    name: 'Plantes',
    emoji: '\u{1F331}',
    colorKey: 'green',
    description: 'Votre jardin',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'Espèce', type: FieldType.text),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
      TemplateField(
          name: 'Date achat', type: FieldType.date, sortable: true),
      TemplateField(
        name: 'Arrosage',
        type: FieldType.select,
        options: {
          'options': [
            'Quotidien',
            'Tous les 2 jours',
            'Hebdomadaire',
            'Bi-mensuel',
            'Mensuel'
          ]
        },
      ),
      TemplateField(name: 'Emplacement', type: FieldType.text),
    ],
  );

  static const tools = CollectionTemplate(
    id: 'tools',
    name: 'Outils',
    emoji: '\u{1F527}',
    colorKey: 'orange',
    description: 'Votre atelier',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'Marque', type: FieldType.text, sortable: true),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
      TemplateField(
        name: 'Catégorie',
        type: FieldType.select,
        options: {
          'options': [
            'Électroportatif',
            'Manuel',
            'Jardin',
            'Plomberie',
            'Électricité',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Emplacement', type: FieldType.text),
      TemplateField(name: 'Prêté à ?', type: FieldType.text),
    ],
  );

  static const vinyls = CollectionTemplate(
    id: 'vinyls',
    name: 'Vinyles',
    emoji: '\u{1F4C0}',
    colorKey: 'teal',
    description: 'Votre collection de vinyles',
    fields: [
      TemplateField(
          name: 'Artiste',
          type: FieldType.text,
          isRequired: true,
          sortable: true),
      TemplateField(
          name: 'Album', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(name: 'Année', type: FieldType.number, sortable: true),
      TemplateField(
        name: 'Genre',
        type: FieldType.select,
        options: {
          'options': [
            'Rock',
            'Jazz',
            'Classique',
            'Pop',
            'Hip-Hop',
            'Électronique',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Label', type: FieldType.text),
      TemplateField(
        name: 'État',
        type: FieldType.select,
        options: {
          'options': [
            'Mint',
            'Near Mint',
            'Very Good',
            'Good',
            'Fair',
            'Poor'
          ]
        },
      ),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
    ],
  );

  static const collections = CollectionTemplate(
    id: 'collections',
    name: 'Collections',
    emoji: '\u{1F3C5}',
    colorKey: 'blue',
    description: 'Collection générique',
    fields: [
      TemplateField(
          name: 'Nom', type: FieldType.text, isRequired: true, sortable: true),
      TemplateField(
        name: 'Catégorie',
        type: FieldType.select,
        options: {
          'options': [
            'Timbres',
            'Pièces',
            'Figurines',
            'Cartes',
            'Autre'
          ]
        },
      ),
      TemplateField(name: 'Année', type: FieldType.number, sortable: true),
      TemplateField(
        name: 'État',
        type: FieldType.select,
        options: {
          'options': ['Neuf', 'Très bon', 'Bon', 'Correct', 'Usé']
        },
      ),
      TemplateField(name: 'Valeur', type: FieldType.currency, sortable: true),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false),
      TemplateField(
          name: 'Notes', type: FieldType.textArea, showInCard: false),
    ],
  );

  static const gym = CollectionTemplate(
    id: 'gym',
    name: 'Musculation',
    emoji: '\u{1F4AA}',
    colorKey: 'orange',
    description: 'Suivi de vos performances en salle',
    fields: [
      TemplateField(
          name: 'Machine',
          type: FieldType.text,
          isRequired: true,
          sortable: true),
      TemplateField(
        name: 'Groupe musculaire',
        type: FieldType.select,
        options: {
          'options': [
            'Pectoraux',
            'Dos',
            'Épaules',
            'Biceps',
            'Triceps',
            'Jambes',
            'Abdominaux',
            'Fessiers',
            'Mollets',
            'Autre',
          ]
        },
      ),
      TemplateField(
        name: 'Poids',
        type: FieldType.tracker,
        options: {
          'unit': 'kg',
          'improvementDirection': 'up',
          'step': 2.5,
        },
      ),
      TemplateField(
          name: 'Photo', type: FieldType.image, showInList: false, showInCard: false),
    ],
  );
}
