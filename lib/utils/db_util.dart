import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:yugioh_flutter_app/models/card_image.dart';
import 'package:yugioh_flutter_app/models/deck.dart';

class DBUtil {

  static sql.Database? _database;

  Future<sql.Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();

    return _database!;
  }

  static Future<void> deleteDB() async {
    final dbPath = await sql.getDatabasesPath();
    final joinedPath = path.join(dbPath, 'YGODB.db');
    await sql.deleteDatabase(joinedPath);
  }

  static Future<sql.Database> initDB() async {
    final dbPath = await sql.getDatabasesPath();
    final joinedPath = path.join(dbPath, 'YGODB.db');

    return sql.openDatabase(joinedPath, version: 1, onCreate: (db, version) async {

      await db.execute(
        '''
        CREATE TABLE card_images (id INT NOT NULL, image_url TEXT[], image_url_small TEXT[]);
        '''
      );
      await db.execute(
        '''
        CREATE TABLE decks (id INT NOT NULL, name TEXT, cards INT[]);
        '''
      );
    });
  }

  Future<void> insertDeck(Deck deck) async {
    final dbClient = await database;

    await dbClient.insert(
      'decks',
      {
        'id': deck.id,
        'name': deck.name,
        'cards': deck.cards,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  Future<void> insertImage(CardImage image) async {
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

  Future<List<Map<String, dynamic>>> getDeckData() async {
    final dbClient = await database;
    return dbClient.query('decks');
  }

  Future<List<Map<String, dynamic>>> getImageData() async {
    final dbClient = await database;
    return dbClient.query('card_images');
  } 

  Future<void> deleteDeck(int id) async {
    final dbClient = await database;
    await dbClient.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, Object?>>> getCardImage(int id) async {
    final dbClient = await database;
    return dbClient.query('card_images', where: 'id = ?', whereArgs: [id]);
  }
}