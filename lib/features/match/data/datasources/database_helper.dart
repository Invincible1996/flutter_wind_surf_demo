import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String dbUrl =
      'https://bigshot.oss-cn-shanghai.aliyuncs.com/match.db'; // Replace with your actual DB URL

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _downloadDatabaseIfNeeded();
    _database = await _initDB('match.db');
    return _database!;
  }

  Future<void> _downloadDatabaseIfNeeded() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'match.db');
    final file = File(path);

    try {
      if (!await file.exists()) {
        await _downloadDatabase(path);
      } else {
        // Optional: Check if database needs update based on some criteria
        // For example, you could check a last-modified header or version number
        await _downloadDatabase(path);
      }
    } catch (e) {
      // If download fails and no local DB exists, create a new one
      if (!await file.exists()) {
        await _createEmptyDatabase(path);
      }
    }
  }

  Future<void> _createEmptyDatabase(String path) async {
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
    await db.close();
  }

  Future<void> _downloadDatabase(String path) async {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

    try {
      final request = await httpClient.getUrl(Uri.parse(dbUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        final file = File(path);
        await file.writeAsBytes(await response.expand((e) => e).toList());
      } else {
        throw Exception('Failed to download database: ${response.statusCode}');
      }
    } finally {
      httpClient.close();
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Open the database without onCreate callback if it exists
    if (await File(path).exists()) {
      return await openDatabase(
        path,
        version: 1,
      );
    }

    // If database doesn't exist, create it with the schema
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
        home_possession INTEGER DEFAULT 50,
        away_possession INTEGER DEFAULT 50,
        home_shots INTEGER DEFAULT 0,
        away_shots INTEGER DEFAULT 0,
        home_passes INTEGER DEFAULT 0,
        away_passes INTEGER DEFAULT 0,
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
