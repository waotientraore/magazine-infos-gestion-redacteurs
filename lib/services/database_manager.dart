import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

import '../modele/redacteur.dart';

// Gère toute la communication avec la base SQLite locale.
class DatabaseManager {
  static Database? _database;

  // Retourne l'instance de la base, en l'ouvrant si ce n'est pas déjà fait.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Ouvre (ou crée) le fichier de base de données redacteurs.db.
  Future<Database> _initDatabase() async {
    // Sur le web, sqflite doit utiliser un moteur basé sur IndexedDB (ffi_web)
    // au lieu du moteur SQLite natif, qui n'existe pas dans le navigateur.
    DatabaseFactory factory = kIsWeb ? databaseFactoryFfiWeb : databaseFactory;

    final path = kIsWeb
        ? 'redacteurs.db'
        : join(await getDatabasesPath(), 'redacteurs.db');

    return await factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE redacteurs(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              nom TEXT,
              prenom TEXT,
              email TEXT
            )
          ''');
        },
      ),
    );
  }

  // Récupère tous les rédacteurs enregistrés dans SQLite.
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');
    return List.generate(maps.length, (i) => Redacteur.fromMap(maps[i]));
  }

  // Insère un nouveau rédacteur dans la base.
  Future<void> insertRedacteur(Redacteur redacteur) async {
    final db = await database;
    await db.insert(
      'redacteurs',
      redacteur.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Met à jour un rédacteur existant en se basant sur son id.
  Future<void> updateRedacteur(Redacteur redacteur) async {
    final db = await database;
    await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // Supprime un rédacteur à partir de son id.
  Future<void> deleteRedacteur(int id) async {
    final db = await database;
    await db.delete('redacteurs', where: 'id = ?', whereArgs: [id]);
  }
}
