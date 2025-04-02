import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'user_data.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL
      )
    ''');
  }

  Future<void> saveUsername(String username) async {
    final db = await database;
    int updated = await db.update(
      'user',
      {'username': username},
      where: 'id = ?',
      whereArgs: [1],
    );

    if (updated == 0) {
      await db.insert('user', {
        'id': 1,
        'username': username,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<String?> getUsername() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query('user');

    if (result.isNotEmpty) {
      return result.first['username'] as String;
    }
    return null;
  }
}
