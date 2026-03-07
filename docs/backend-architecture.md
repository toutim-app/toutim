# Architecture Backend — Toutim Sync Server

> Document d'infrastructure décrivant le serveur de synchronisation Go avec une base SQLite par utilisateur.

## Vue d'ensemble

```
┌─────────────────────┐       HTTPS / WSS        ┌──────────────────────────────┐
│   App Flutter        │  ◄──────────────────►   │   api.toutim.app (Go)        │
│   app.toutim         │                          │                              │
│  Drift (SQLite)      │   JSON + Delta Sync      │  SQLite par utilisateur      │
│  Source de vérité    │                          │  Miroir opaque (backup/sync) │
└─────────────────────┘                          └──────────────────────────────┘
```

**Principes fondamentaux :**

- **Local-first** : l'app Flutter fonctionne à 100 % hors-ligne. Le serveur est optionnel.
- **Serveur opaque** : le serveur ne lit, n'interprète et n'exploite jamais les données utilisateur. Il se contente de stocker et synchroniser.
- **SQLite par utilisateur** : chaque utilisateur possède sa propre base SQLite sur le serveur, isolée des autres.
- **Sync incrémentale** : seuls les deltas (modifications depuis le dernier sync) transitent sur le réseau.
- **Open source** : le serveur est auto-hébergeable par n'importe qui.

---

## Pourquoi SQLite par utilisateur ?

### Le choix

Plutôt qu'une base PostgreSQL/MySQL partagée avec des tables multi-tenant, chaque utilisateur obtient son propre fichier SQLite sur le serveur :

```
data/
├── users.db                    # Base globale : comptes, auth, metadata
└── user_data/
    ├── a1b2c3d4.db            # SQLite de l'utilisateur a1b2c3d4
    ├── e5f6g7h8.db            # SQLite de l'utilisateur e5f6g7h8
    └── ...
```

### Avantages

| Avantage | Détail |
|----------|--------|
| **Isolation totale** | Aucune fuite de données possible entre utilisateurs. Pas de bug `WHERE user_id = ?` oublié. |
| **Schéma identique client/serveur** | Le schéma Drift de l'app Flutter est répliqué quasi tel quel côté serveur. Moins de mapping, moins de bugs. |
| **Backup trivial** | Sauvegarder un utilisateur = copier un fichier. Restaurer = remplacer le fichier. |
| **Suppression RGPD** | Supprimer toutes les données d'un utilisateur = supprimer un fichier. Aucun doute, aucun résidu. |
| **Performance prévisible** | Chaque base ne contient que les données d'un seul utilisateur. Pas de dégradation liée à la croissance globale. |
| **Pas de migrations multi-tenant** | Les migrations de schéma s'appliquent par base, sans risque d'impacter tous les utilisateurs d'un coup. |
| **Self-hosting simple** | Pas besoin de PostgreSQL/MySQL. Un binaire Go + un dossier de fichiers SQLite suffit. |
| **Export facile** | L'utilisateur peut télécharger directement sa base SQLite. |
| **Scalabilité horizontale** | Les fichiers SQLite peuvent être distribués sur plusieurs nœuds de stockage si nécessaire. |

### Inconvénients et mitigations

| Inconvénient | Mitigation |
|-------------|------------|
| **Pas de requêtes cross-users** | Non pertinent : le serveur ne lit jamais les données, il ne fait que stocker et synchroniser. |
| **Nombre de fichiers ouverts** | Les connexions SQLite sont ouvertes à la demande et fermées après un timeout d'inactivité (pool LRU). |
| **Migrations** | Un job de migration parcourt chaque fichier `.db` au démarrage ou de manière lazy au premier accès de l'utilisateur. |
| **Concurrence d'écriture** | SQLite supporte un seul writer — adapté ici car un utilisateur ne fait qu'un seul sync à la fois. Le mode WAL est activé pour permettre les lectures concurrentes. |

---

## Architecture Go

### Stack technique

| Composant | Choix | Justification |
|-----------|-------|---------------|
| Langage | Go 1.22+ | Binaire unique, performant, simple |
| HTTP | `net/http` + `chi` | Router léger, middleware composable |
| SQLite | `modernc.org/sqlite` (pure Go) | Pas de CGO, compilation croisée facile |
| Auth | JWT (access + refresh tokens) | Stateless, adapté au mobile |
| Config | Variables d'env + fichier TOML | 12-factor app |
| Logs | `log/slog` (stdlib) | Structuré, performant, standard |
| Tests | `testing` stdlib + `testify` | Simple et efficace |

### Structure du projet

```
toutim-server/
├── cmd/
│   └── server/
│       └── main.go                 # Point d'entrée
├── internal/
│   ├── config/
│   │   └── config.go               # Configuration (env, TOML)
│   ├── auth/
│   │   ├── handler.go              # Endpoints register/login/refresh
│   │   ├── jwt.go                  # Génération et validation JWT
│   │   ├── middleware.go           # Middleware d'authentification
│   │   └── password.go             # Hachage bcrypt/argon2
│   ├── database/
│   │   ├── manager.go              # Gestionnaire de bases par utilisateur
│   │   ├── pool.go                 # Pool LRU de connexions SQLite
│   │   ├── migrations.go           # Migrations de schéma
│   │   ├── users_db.go             # Accès à users.db (comptes)
│   │   └── schema/
│   │       └── user_schema.sql     # Schéma SQLite utilisateur
│   ├── sync/
│   │   ├── handler.go              # Endpoints push/pull
│   │   ├── engine.go               # Logique de synchronisation
│   │   ├── conflict.go             # Résolution de conflits
│   │   └── delta.go                # Calcul des deltas
│   ├── api/
│   │   ├── router.go               # Configuration des routes
│   │   ├── middleware.go            # Middlewares globaux (CORS, rate limit)
│   │   └── response.go             # Helpers de réponse JSON
│   └── model/
│       ├── user.go                 # Modèle utilisateur
│       ├── collection.go           # Modèle collection
│       ├── item.go                 # Modèle item
│       ├── field_definition.go     # Modèle définition de champ
│       └── field_value.go          # Modèle valeur de champ
├── docker/
│   ├── Dockerfile                  # Image de production
│   └── docker-compose.yml          # Dev local
├── go.mod
├── go.sum
└── README.md
```

### Gestionnaire de bases SQLite

Le composant central est le `DatabaseManager` qui gère le cycle de vie des connexions SQLite par utilisateur :

```go
// internal/database/manager.go

type DatabaseManager struct {
    dataDir  string          // Répertoire des fichiers .db
    usersDB  *sql.DB         // Base globale (comptes, auth)
    pool     *ConnectionPool // Pool LRU de connexions utilisateur
}

// UserDB retourne une connexion à la base de l'utilisateur.
// Crée la base si elle n'existe pas encore (premier sync).
func (m *DatabaseManager) UserDB(userID string) (*sql.DB, error) {
    // 1. Vérifier le pool LRU
    if db, ok := m.pool.Get(userID); ok {
        return db, nil
    }

    // 2. Construire le chemin : data/user_data/{userID}.db
    dbPath := filepath.Join(m.dataDir, "user_data", userID+".db")

    // 3. Ouvrir ou créer la base
    db, err := sql.Open("sqlite", dbPath+"?_journal_mode=WAL&_busy_timeout=5000")
    if err != nil {
        return nil, fmt.Errorf("open user db: %w", err)
    }

    // 4. Appliquer les migrations si nécessaire
    if err := m.migrate(db); err != nil {
        db.Close()
        return nil, fmt.Errorf("migrate user db: %w", err)
    }

    // 5. Ajouter au pool (évicte le plus ancien si plein)
    m.pool.Put(userID, db)

    return db, nil
}
```

### Pool de connexions LRU

```go
// internal/database/pool.go

type ConnectionPool struct {
    mu       sync.Mutex
    maxSize  int                        // Ex: 100 connexions simultanées
    items    map[string]*poolEntry
    order    *list.List                 // Doubly-linked list pour LRU
    timeout  time.Duration             // Fermeture après inactivité (ex: 5 min)
}

type poolEntry struct {
    db       *sql.DB
    userID   string
    lastUsed time.Time
    element  *list.Element
}

// Get récupère une connexion du pool et met à jour le LRU.
func (p *ConnectionPool) Get(userID string) (*sql.DB, bool) { ... }

// Put ajoute une connexion au pool, évicte la plus ancienne si nécessaire.
func (p *ConnectionPool) Put(userID string, db *sql.DB) { ... }

// cleanup est lancé en goroutine — ferme les connexions inactives.
func (p *ConnectionPool) cleanup() { ... }
```

---

## Schéma SQLite

### Base globale (`users.db`)

```sql
CREATE TABLE users (
    id            TEXT PRIMARY KEY,      -- UUID v4
    email         TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,         -- Argon2id
    created_at    TEXT NOT NULL,         -- RFC 3339
    updated_at    TEXT NOT NULL,
    last_sync_at  TEXT,                  -- Dernier sync réussi
    storage_bytes INTEGER DEFAULT 0,    -- Taille de la base utilisateur
    is_active     INTEGER DEFAULT 1
);

CREATE TABLE refresh_tokens (
    id         TEXT PRIMARY KEY,
    user_id    TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash TEXT NOT NULL,            -- SHA-256 du refresh token
    expires_at TEXT NOT NULL,
    created_at TEXT NOT NULL
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
```

### Base utilisateur (`{user_id}.db`)

Le schéma reproduit celui de Drift côté Flutter, avec des colonnes de sync ajoutées :

```sql
-- Identique au schéma Drift de l'app Flutter
CREATE TABLE collections (
    id          TEXT PRIMARY KEY,
    name        TEXT NOT NULL CHECK(length(name) BETWEEN 1 AND 200),
    description TEXT,
    icon        TEXT,
    color       TEXT NOT NULL CHECK(length(color) BETWEEN 1 AND 20),
    template_id TEXT,
    view_mode   TEXT NOT NULL DEFAULT 'list',
    sync_status TEXT NOT NULL DEFAULT 'synced',
    created_at  TEXT NOT NULL,           -- RFC 3339
    updated_at  TEXT NOT NULL
);

CREATE TABLE items (
    id            TEXT PRIMARY KEY,
    collection_id TEXT NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    favorite      INTEGER NOT NULL DEFAULT 0,
    sync_status   TEXT NOT NULL DEFAULT 'synced',
    created_at    TEXT NOT NULL,
    updated_at    TEXT NOT NULL
);

CREATE TABLE field_definitions (
    id            TEXT PRIMARY KEY,
    collection_id TEXT NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
    name          TEXT NOT NULL CHECK(length(name) BETWEEN 1 AND 200),
    type          TEXT NOT NULL,
    sort_order    INTEGER NOT NULL,
    is_required   INTEGER NOT NULL DEFAULT 0,
    show_in_list  INTEGER NOT NULL DEFAULT 1,
    show_in_card  INTEGER NOT NULL DEFAULT 1,
    searchable    INTEGER NOT NULL DEFAULT 1,
    sortable      INTEGER NOT NULL DEFAULT 0,
    default_value TEXT,                  -- JSON
    options       TEXT NOT NULL DEFAULT '{}',  -- JSON
    sync_status   TEXT NOT NULL DEFAULT 'synced'
);

CREATE TABLE item_field_values (
    id                  TEXT PRIMARY KEY,
    item_id             TEXT NOT NULL REFERENCES items(id) ON DELETE CASCADE,
    field_definition_id TEXT NOT NULL REFERENCES field_definitions(id) ON DELETE CASCADE,
    value               TEXT,            -- JSON (dynamic)
    updated_at          TEXT NOT NULL,
    UNIQUE(item_id, field_definition_id)
);

-- Table de suivi de sync (côté serveur uniquement)
CREATE TABLE sync_log (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    entity     TEXT NOT NULL,            -- 'collection', 'item', 'field_definition', 'field_value'
    entity_id  TEXT NOT NULL,
    action     TEXT NOT NULL,            -- 'create', 'update', 'delete'
    timestamp  TEXT NOT NULL,            -- RFC 3339, haute précision
    version    INTEGER NOT NULL          -- Compteur monotone par utilisateur
);

CREATE INDEX idx_sync_log_version ON sync_log(version);
CREATE INDEX idx_sync_log_entity ON sync_log(entity, entity_id);
CREATE INDEX idx_items_collection ON items(collection_id);
CREATE INDEX idx_field_defs_collection ON field_definitions(collection_id);
CREATE INDEX idx_field_values_item ON item_field_values(item_id);
```

**Note :** Les colonnes `server_id` présentes côté Flutter ne sont pas nécessaires côté serveur — les `id` UUID générés par le client sont utilisés directement comme clés primaires des deux côtés.

---

## Protocole de synchronisation

### Modèle de sync : push/pull incrémental

Le client maintient un **curseur de version** (`last_sync_version`). À chaque sync, il envoie ses modifications locales et récupère les modifications serveur depuis ce curseur.

```
Client                                  Serveur
  │                                        │
  │  1. POST /api/sync/push               │
  │  ──────────────────────────────────►   │
  │  { changes: [...], last_version: 42 }  │
  │                                        │  Applique les changements
  │                                        │  Détecte les conflits
  │  2. Réponse push                       │
  │  ◄──────────────────────────────────   │
  │  { conflicts: [...], version: 47 }     │
  │                                        │
  │  3. POST /api/sync/pull               │
  │  ──────────────────────────────────►   │
  │  { since_version: 42 }                │
  │                                        │
  │  4. Réponse pull                       │
  │  ◄──────────────────────────────────   │
  │  { changes: [...], version: 47 }       │
  │                                        │
  │  Client applique les changements       │
  │  Met à jour last_sync_version = 47     │
```

### Format des changements (delta)

```json
{
  "changes": [
    {
      "entity": "collection",
      "id": "uuid-de-la-collection",
      "action": "create",
      "data": {
        "name": "Mes livres",
        "color": "teal",
        "view_mode": "grid",
        "created_at": "2026-03-07T10:30:00Z",
        "updated_at": "2026-03-07T10:30:00Z"
      },
      "client_updated_at": "2026-03-07T10:30:00Z"
    },
    {
      "entity": "item",
      "id": "uuid-de-litem",
      "action": "update",
      "data": {
        "favorite": true,
        "updated_at": "2026-03-07T14:22:00Z"
      },
      "client_updated_at": "2026-03-07T14:22:00Z"
    },
    {
      "entity": "field_value",
      "id": "uuid-de-la-valeur",
      "action": "delete",
      "client_updated_at": "2026-03-07T15:00:00Z"
    }
  ],
  "last_version": 42
}
```

### Résolution de conflits

Stratégie **Last-Writer-Wins (LWW)** basée sur `updated_at` avec granularité par entité :

1. Le client envoie ses modifications avec `client_updated_at`
2. Le serveur compare avec le `updated_at` de sa version
3. Si `client_updated_at > server_updated_at` → le client gagne
4. Si `client_updated_at <= server_updated_at` → conflit détecté
5. Les conflits sont renvoyés au client avec la version serveur pour résolution manuelle (futur) ou application automatique du LWW

```go
// internal/sync/conflict.go

type ConflictResult struct {
    EntityType string          `json:"entity"`
    EntityID   string          `json:"id"`
    ClientData json.RawMessage `json:"client_data"`
    ServerData json.RawMessage `json:"server_data"`
    Resolution string          `json:"resolution"` // "client_wins", "server_wins"
}

func resolveConflict(clientChange Change, serverEntity Entity) ConflictResult {
    if clientChange.ClientUpdatedAt.After(serverEntity.UpdatedAt) {
        return ConflictResult{Resolution: "client_wins"}
    }
    return ConflictResult{Resolution: "server_wins"}
}
```

---

## API REST

### Authentification

```
POST   /api/auth/register        # Inscription
POST   /api/auth/login            # Connexion → access_token + refresh_token
POST   /api/auth/refresh          # Renouveler l'access_token
POST   /api/auth/logout           # Révoquer le refresh_token
DELETE /api/auth/account          # Supprimer le compte + base SQLite
```

### Synchronisation

```
POST   /api/sync/push             # Envoyer les modifications locales
POST   /api/sync/pull             # Récupérer les modifications serveur
GET    /api/sync/status           # État de la dernière sync
```

### Export

```
GET    /api/export/sqlite          # Télécharger sa base SQLite complète
GET    /api/export/json            # Exporter toutes ses données en JSON
```

### Headers

```
Authorization: Bearer <access_token>
Content-Type: application/json
X-Client-Version: 1.0.0           # Version de l'app Flutter
X-Schema-Version: 1                # Version du schéma SQLite
```

---

## Gestion des images et fichiers

Les champs de type `image` nécessitent un traitement particulier car les fichiers binaires ne se synchronisent pas bien en JSON.

### Stratégie

```
data/
└── user_data/
    ├── a1b2c3d4.db               # Base SQLite
    └── a1b2c3d4_files/           # Fichiers de l'utilisateur
        ├── img_abc123.jpg
        └── img_def456.jpg
```

1. Le champ `image` stocke une **référence** (identifiant du fichier), pas le binaire
2. Les images sont uploadées séparément via un endpoint dédié
3. Le sync des images est indépendant du sync des données

```
POST   /api/files/upload           # Upload un fichier, retourne un file_id
GET    /api/files/:file_id         # Télécharger un fichier
DELETE /api/files/:file_id         # Supprimer un fichier
```

### Flux de sync des images

```
1. Client crée un item avec un champ image
2. L'image est uploadée via POST /api/files/upload → file_id
3. La valeur du champ image = file_id (string)
4. Le sync push envoie le file_id comme valeur du champ
5. Sur un autre appareil, le sync pull récupère le file_id
6. Le client télécharge l'image via GET /api/files/:file_id
```

---

## Migrations

### Côté serveur

Les migrations sont versionnées et appliquées de manière **lazy** (au premier accès de l'utilisateur après un déploiement) :

```go
// internal/database/migrations.go

var migrations = []Migration{
    {Version: 1, SQL: schemaV1},     // Schéma initial
    {Version: 2, SQL: schemaV2},     // Ajout d'une table, colonne, etc.
}

func (m *DatabaseManager) migrate(db *sql.DB) error {
    currentVersion := getCurrentVersion(db) // PRAGMA user_version

    for _, migration := range migrations {
        if migration.Version > currentVersion {
            if _, err := db.Exec(migration.SQL); err != nil {
                return fmt.Errorf("migration v%d: %w", migration.Version, err)
            }
        }
    }

    setCurrentVersion(db, latestVersion) // PRAGMA user_version = N
    return nil
}
```

### Compatibilité client/serveur

Le header `X-Schema-Version` permet au serveur de :
- Refuser un sync si le client est trop ancien (migration incompatible)
- Appliquer les migrations nécessaires avant de traiter le sync

---

## Déploiement

### Binaire unique

```bash
# Compilation
go build -o toutim-server ./cmd/server

# Lancement
./toutim-server

# Ou avec configuration
TOUTIM_DATA_DIR=/var/lib/toutim \
TOUTIM_PORT=8080 \
TOUTIM_JWT_SECRET=your-secret-here \
./toutim-server
```

### Docker

```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go install
COPY . .
RUN go build -o toutim-server ./cmd/server

FROM alpine:3.19
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/toutim-server /usr/local/bin/
VOLUME /data
EXPOSE 8080
CMD ["toutim-server"]
```

```yaml
# docker-compose.yml
services:
  toutim:
    build: .
    ports:
      - "8080:8080"
    volumes:
      - toutim-data:/data
    environment:
      - TOUTIM_DATA_DIR=/data
      - TOUTIM_JWT_SECRET=${JWT_SECRET}

volumes:
  toutim-data:
```

### Configuration

```toml
# config.toml (ou variables d'environnement TOUTIM_*)

[server]
port = 8080
host = "0.0.0.0"

[data]
dir = "/var/lib/toutim"           # Répertoire des bases SQLite
max_user_storage = "500MB"        # Limite par utilisateur

[database]
pool_size = 100                   # Max connexions SQLite simultanées
idle_timeout = "5m"               # Fermeture après inactivité
busy_timeout = "5s"               # Timeout SQLite en cas de lock

[auth]
jwt_secret = ""                   # Obligatoire, via env var en prod
access_token_ttl = "15m"
refresh_token_ttl = "30d"

[sync]
max_changes_per_push = 1000       # Limite anti-abus
max_file_size = "10MB"            # Taille max par fichier uploadé
```

---

## Sécurité

| Mesure | Détail |
|--------|--------|
| **Isolation des données** | Une base SQLite par utilisateur. Aucun accès croisé possible. |
| **Auth JWT** | Access token courte durée (15 min) + refresh token longue durée (30 jours). |
| **Mots de passe** | Hachés avec Argon2id, jamais stockés en clair. |
| **Rate limiting** | Par IP et par utilisateur, pour éviter les abus. |
| **HTTPS obligatoire** | En production, TLS terminé par un reverse proxy (Caddy, nginx). |
| **Validation des entrées** | Toutes les données entrantes validées et sanitizées. |
| **Path traversal** | Les ID utilisateur sont des UUID v4 validés avant construction du chemin fichier. |
| **CORS** | Configuré strictement pour le client Flutter (pas de wildcard). |
| **Suppression RGPD** | `DELETE /api/auth/account` supprime le fichier SQLite entier. Aucun résidu. |

---

## Limites et évolutions futures

### Limites du modèle SQLite par utilisateur

- **Scalabilité verticale** : au-delà de ~50 000 utilisateurs actifs simultanés, il faudra envisager du sharding par répertoire ou serveur.
- **Pas de sync temps réel** : le modèle push/pull est basé sur des requêtes HTTP. Pour du temps réel (collaboration), il faudrait ajouter des WebSockets.

### Évolutions envisagées

- **Partage de collections** : un utilisateur peut partager une collection en lecture seule. Le serveur copie les données dans la base du destinataire.
- **Backup automatique** : rotation de snapshots des fichiers SQLite (copie à froid ou backup API SQLite).
- **Chiffrement E2E** : les données utilisateur peuvent être chiffrées côté client avant sync, rendant le serveur zero-knowledge.
