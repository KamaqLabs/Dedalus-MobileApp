import 'package:dedalus/features/favorites/data/datasources/app_database.dart';
import 'package:dedalus/features/favorites/data/models/favorite_hotel_dto.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteHotelDao {
  final String tableName = 'favorite_hotels';

  Future<void> insertFavoriteHotel(FavoriteHotelDto favoriteHotel) async {
    Database db = await AppDatabase().database;
    await db.insert(
      tableName,
      favoriteHotel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavoriteHotel(int id) async {
    Database db = await AppDatabase().database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<FavoriteHotelDto>> getAllFavoriteHotels() async {
    Database db = await AppDatabase().database;
    final maps = await db.query(tableName);
    return maps.map((e) => FavoriteHotelDto.fromMap(e)).toList();
  }

  Future<bool> isFavorite(int id) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
