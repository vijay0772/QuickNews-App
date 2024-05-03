import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  // Define table and database initialization
  Future<Database> get db async {
    if (_db != null) return _db!;

    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'login.db');
    print(path);
    // Open/create the database at a given path
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Create the table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        username TEXT,
        password TEXT
      )
    ''');
  }

  // Insert a user into the database
  Future<int> insertUser(String username, String password) async {
    final db = await this.db;
    return await db
        .insert('users', {'username': username, 'password': password});
  }

  Future<bool> loginUser(String username, String password) async {
    final db = await this.db;
    var result = await db.query('users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password]);
    return result.isNotEmpty;
  }
}
