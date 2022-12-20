import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:yugioh_flutter_app/models/card_image.dart';

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
        "CREATE TABLE card_images (id INT NOT NULL, image_url TEXT[], image_url_small TEXT[])"
      );
    });
  }

  Future<void> insert(CardImage image) async {
    final dbClient = await database;

    await dbClient.insert(
      'card_images',
      {
        'id': image.id,
        'image_url': '${image.imageUrl}',
        'image_url_small': '${image.imageUrlSmall}',
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final dbClient = await database;
    return dbClient.query('card_images');
  } 

  Future<List<Map<String, Object?>>> getCardImage(int id) async {
    final dbClient = await database;
    return dbClient.query('card_images', where: 'id = ?', whereArgs: [id]);
  }
}