import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('match.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE football_match(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        time TEXT NOT NULL,
        league TEXT NOT NULL,
        home_team TEXT NOT NULL,
        away_team TEXT NOT NULL,
        home_team_img TEXT NOT NULL,
        away_team_img TEXT NOT NULL,
        create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
        update_time DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<Map<String, dynamic>> createMatch(Map<String, dynamic> match) async {
    final db = await instance.database;
    final id = await db.insert('football_match', match);
    return {...match, 'id': id};
  }

  Future<List<Map<String, dynamic>>> getAllMatches() async {
    final db = await instance.database;
    return await db.query('football_match');
  }

  Future<Map<String, dynamic>?> getMatch(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'football_match',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getMatchesByDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'football_match',
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getMatchesByLeague(String league) async {
    final db = await instance.database;
    return await db.query(
      'football_match',
      where: 'league = ?',
      whereArgs: [league],
    );
  }

  Future<int> updateMatch(Map<String, dynamic> match) async {
    final db = await instance.database;
    return db.update(
      'football_match',
      match,
      where: 'id = ?',
      whereArgs: [match['id']],
    );
  }

  Future<int> deleteMatch(int id) async {
    final db = await instance.database;
    return await db.delete(
      'football_match',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
