// Représente un rédacteur enregistré dans notre application.
class Redacteur {
  final int? id; // nullable : généré automatiquement par SQLite à l'insertion
  final String nom;
  final String prenom;
  final String email;

  // Constructeur complet, utilisé quand on récupère un rédacteur déjà en base.
  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans id, utilisé quand on crée un nouveau rédacteur
  // avant insertion (l'id n'existe pas encore).
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // Convertit l'objet en Map pour l'insertion/mise à jour dans SQLite.
  // Les clés doivent correspondre EXACTEMENT aux noms de colonnes de la table.
  Map<String, dynamic> toMap() {
    return {'id': id, 'nom': nom, 'prenom': prenom, 'email': email};
  }

  // Reconstruit un objet Redacteur à partir d'une ligne (Map) lue en base.
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}
