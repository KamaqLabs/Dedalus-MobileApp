import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _db;

  Future<Database> get database async {
    return _db ??= await _initDb();
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'dedalus.db');
    return await openDatabase(path, version: 1, onCreate: _oncreate);
  }

  Future<void> _oncreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_hotels (
        id INTEGER PRIMARY KEY,
        name TEXT,
        ruc TEXT,
        address TEXT
      )
    ''');
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
