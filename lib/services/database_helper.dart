import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quran_app.db');

    print('Membuka database di path: $path');

    return openDatabase(
      path,
      version: 2, // Update versi database untuk migrasi
      onCreate: (db, version) async {
        print('Membuat tabel reading_history');
        await db.execute('''
          CREATE TABLE reading_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah INTEGER,
            ayah INTEGER
          )
        ''');

        print('Membuat tabel favorites');
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah INTEGER,
            ayah INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          print('Migrasi database ke versi 2, menambahkan tabel favorites');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS favorites (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              surah INTEGER,
              ayah INTEGER
            )
          ''');
        }
      },
    );
  }

  // Reading History
  Future<void> saveReadingHistory(int surah, int ayah) async {
    final db = await database;
    await db.delete('reading_history'); // Hapus riwayat lama
    await db.insert('reading_history', {'surah': surah, 'ayah': ayah});
  }

  Future<Map<String, int>?> getReadingHistory() async {
    final db = await database;
    final result = await db.query('reading_history', limit: 1);

    if (result.isNotEmpty) {
      return {
        'surah': result.first['surah'] as int,
        'ayah': result.first['ayah'] as int,
      };
    }
    return null;
  }

  // Favorites
  Future<void> addFavorite(int surah, int ayah) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'surah': surah, 'ayah': ayah},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(int surahNumber, int ayahNumber) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'surah = ? AND ayah = ?',
      whereArgs: [surahNumber, ayahNumber],
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }

  Future<bool> isFavorite(int surah, int ayah) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'surah = ? AND ayah = ?',
      whereArgs: [surah, ayah],
    );
    return result.isNotEmpty;
  }
}
