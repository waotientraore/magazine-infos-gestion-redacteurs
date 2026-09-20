import 'package:flutter/material.dart';

import 'views/redacteur_interface.dart';

void main() {
  runApp(const MonApplication());
}

// Widget racine de l'application. Il ne change jamais d'état,
// donc un StatelessWidget suffit ici.
class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Infos - Gestion des rédacteurs',
      theme: ThemeData(primarySwatch: Colors.pink, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      // La page d'accueil est l'écran de gestion des rédacteurs.
      home: const RedacteurInterface(),
    );
  }
}
