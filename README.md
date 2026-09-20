
# Documentation du projet — Magazine Infos : Gestion des rédacteurs

A brief description of what this project does and who it's for


## 1. Présentation

Cette application Flutter permet à l'éditeur en chef du magazine Magazine Infos de gérer ses rédacteurs : ajouter un nouveau rédacteur, afficher la liste de ceux déjà enregistrés, modifier leurs informations et les supprimer. Les données sont stockées localement grâce à une base SQLite, via le package sqflite, ce qui permet de conserver les informations même après fermeture de l'application.
## 2. Structure du projet

lib/
├── main.dart
├── modele/
│   └── redacteur.dart
├── services/
│   └── database_manager.dart
└── views/
    └── redacteur_interface.dart

* main.dart : point d'entrée de l'application. Contient MonApplication, un StatelessWidget qui configure le MaterialApp et définit RedacteurInterface comme écran d'accueil.

* modele/redacteur.dart : définit la classe Redacteur, qui représente un rédacteur (id, nom, prénom, email). Contient les méthodes toMap() et fromMap() pour convertir entre l'objet Dart et les lignes de la base SQLite.

* services/database_manager.dart : gère toute la communication avec la base de données locale (création, insertion, lecture, mise à jour, suppression).

* views/redacteur_interface.dart : écran principal (StatefulWidget). Contient le formulaire de saisie, le bouton d'ajout, la liste des rédacteurs et les boîtes de dialogue de modification/suppression.
## 3. Base de données SQLite

La base est un fichier nommé redacteurs.db, ouvert avec openDatabase() (ou son équivalent web via sqflite_common_ffi_web). Elle contient une seule table :

CREATE TABLE redacteurs(
    
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  nom TEXT,

  prenom TEXT,

  email TEXT
);

La création de la table se fait dans le callback onCreate, exécuté uniquement lors de la toute première ouverture de la base.


## 4. Opérations CRUD

Opération	Méthode	Description

Create	insertRedacteur()	Ajoute un nouveau rédacteur dans la table

Read	getAllRedacteurs()	Récupère tous les rédacteurs enregistrés

Update	updateRedacteur()	Met à jour un rédacteur existant, identifié par son id

Delete	deleteRedacteur()	Supprime un rédacteur à partir de son id

Chaque opération d'écriture (ajout, modification, suppression) est suivie d'un rechargement de la liste (_chargerRedacteurs()) pour que l'affichage reste synchronisé avec la base.
## 5. Concepts Flutter utilisés

* StatefulWidget : widget dont l'affichage dépend de données qui peuvent changer dans le temps (ici, la liste des rédacteurs). Utilisé pour RedacteurInterface.

* setState() : méthode qui informe Flutter qu'une donnée a changé et qu'il faut redessiner l'écran.

* initState() : appelée une seule fois à la création du widget, avant le premier affichage. Utilisée ici pour charger automatiquement les rédacteurs existants au démarrage.

* TextEditingController : objet qui relie un champ de saisie (TextField) à une variable, permettant de lire ou modifier son contenu.

* ListView.builder : construit dynamiquement une liste défilante, en ne générant que les éléments visibles à l'écran (performant pour de grandes listes).

* AlertDialog / showDialog() : affichent une boîte de dialogue par-dessus l'écran, utilisée ici pour la modification d'un rédacteur et la confirmation de suppression.

* Future / async / await : gèrent les opérations asynchrones (accès à la base de données), qui prennent un temps indéterminé avant de renvoyer un résultat.
## 6. Choix techniques

* Le projet cible principalement Android/iOS/desktop (conforme aux maquettes du sujet). Une adaptation Flutter Web a été ajoutée via sqflite_common_ffi_web, qui remplace le moteur SQLite natif par un moteur basé sur IndexedDB dans le navigateur.

* Aucune architecture complexe (pas de state management externe, pas de backend) : le projet reste centré sur Flutter + Dart + SQLite, conformément aux consignes.
## Tech Stack

**Client:** Flutter/Dart

**Server:** SQLITE


## Authors

- [waotientraore](https://github.com/waotientraore/magazine-infos-gestion-redacteurs)

Developpeur junior flutter

