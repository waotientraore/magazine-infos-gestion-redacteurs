import 'package:flutter/material.dart';

import '../modele/redacteur.dart';
import '../services/database_manager.dart';

// Écran principal : formulaire + liste des rédacteurs.
class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _dbManager = DatabaseManager();

  // Contrôleurs liés aux champs de saisie du formulaire d'ajout.
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Liste des rédacteurs actuellement affichée à l'écran.
  List<Redacteur> _redacteurs = [];

  @override
  void initState() {
    super.initState();
    // Appelée une seule fois à la création du widget : on charge les données existantes.
    _chargerRedacteurs();
  }

  // Récupère tous les rédacteurs depuis SQLite et met à jour l'affichage.
  Future<void> _chargerRedacteurs() async {
    final liste = await _dbManager.getAllRedacteurs();
    // Met à jour l'affichage après la récupération des données.
    setState(() {
      _redacteurs = liste;
    });
  }

  // Ajoute un rédacteur à partir des champs saisis.
  Future<void> _ajouterRedacteur() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();

    // Validation simple : aucun champ ne doit être vide.
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    final nouveau = Redacteur.sansId(nom: nom, prenom: prenom, email: email);
    await _dbManager.insertRedacteur(nouveau);

    // Recharge la liste pour afficher le nouveau rédacteur.
    await _chargerRedacteurs();

    // Vide les champs après un ajout réussi.
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
  }

  // Ouvre une boîte de dialogue pré-remplie pour modifier un rédacteur.
  Future<void> _ouvrirDialogueModification(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier Rédacteur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(labelText: 'Nouveau Nom'),
              ),
              TextField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: 'Nouveau Prénom'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Nouvel Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () async {
                // On garde le même id, seuls les champs changent.
                final modifie = Redacteur(
                  id: redacteur.id,
                  nom: nomController.text.trim(),
                  prenom: prenomController.text.trim(),
                  email: emailController.text.trim(),
                );
                await _dbManager.updateRedacteur(modifie);
                await _chargerRedacteurs();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  // Ouvre une boîte de dialogue de confirmation avant suppression.
  Future<void> _confirmerSuppression(Redacteur redacteur) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer ce rédacteur ?'),
          content: Text(
            'Voulez-vous vraiment supprimer ${redacteur.nom} ${redacteur.prenom} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _dbManager.deleteRedacteur(redacteur.id!);
                await _chargerRedacteurs();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Libère les contrôleurs quand le widget est détruit, pour éviter les fuites mémoire.
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des rédacteurs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _ajouterRedacteur,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter un Rédacteur'),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _redacteurs.isEmpty
                  ? const Center(child: Text('Aucun rédacteur enregistré.'))
                  : ListView.builder(
                      itemCount: _redacteurs.length,
                      itemBuilder: (context, index) {
                        final redacteur = _redacteurs[index];
                        return Card(
                          child: ListTile(
                            title: Text('${redacteur.nom} ${redacteur.prenom}'),
                            subtitle: Text(redacteur.email),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _ouvrirDialogueModification(redacteur),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _confirmerSuppression(redacteur),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
