
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

import 'package:quranconnect/models/favorite_ayah.dart';

class DbHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorites.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE favorites(
            id INTEGER PRIMARY KEY,
            number INTEGER,
            text TEXT,
            numberInSurah INTEGER,
            juz INTEGER,
            manzil INTEGER,
            page INTEGER,
            ruku INTEGER,
            hizbQuarter INTEGER,
            sajda BOOLEAN
          )''',
        );
      },
      version: 1,
    );
  }

  Future<void> addFavorite(Ayah ayah) async {
    final db = await database;
    await db.insert('favorites', ayah.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ayah>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Ayah.fromJson(maps[i]);
    });
  }

  Future<void> removeFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
