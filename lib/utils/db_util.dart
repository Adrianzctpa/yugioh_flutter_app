import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBUtil {

  static sql.Database? _database;

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();

    return _database!;
  }

  static Future<sql.Database> initDB() async {
    final dbPath = await sql.getDatabasesPath();
    final joinedPath = path.join(dbPath, 'cool_locations.db');
    return sql.openDatabase(joinedPath, version: 1, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE card_images (id INT NOT NULL, image_url[], image_url_small TEXT[])"
      );
    });
  }

  Future<void> insert(String table, Map<String, Object> data) async {
    final dbClient = await database;
    await dbClient.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final dbClient = await database;
    return dbClient.query(table);
  } 
}