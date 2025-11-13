import 'package:dedalus/features/favorites/data/datasources/favorite_hotel_dao.dart';
import 'package:dedalus/features/favorites/data/models/favorite_hotel_dto.dart';
import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';

class FavoriteHotelRepository {
  final FavoriteHotelDao _dao = FavoriteHotelDao();

  Future<void> insertFavoriteHotel(FavoriteHotel favoriteHotel) async {
    await _dao.insertFavoriteHotel(FavoriteHotelDto.fromDomain(favoriteHotel));
  }

  // Cambiado a int
  Future<void> deleteFavoriteHotel(int id) async {
    await _dao.deleteFavoriteHotel(id);
  }

  Future<List<FavoriteHotel>> getAllFavoriteHotels() async {
    final favoriteHotels = await _dao.getAllFavoriteHotels();
    return favoriteHotels.map((dto) => dto.toDomain()).toList();
  }

  // Cambiado a int
  Future<bool> isFavorite(int id) async {
    return await _dao.isFavorite(id);
  }
}
