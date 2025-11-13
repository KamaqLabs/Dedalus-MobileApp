import 'package:dedalus/features/favorites/domain/entities/favorite_hotel.dart';

class FavoriteHotelDto {
  final int id;
  final String name;
  final String ruc;
  final String address;

  const FavoriteHotelDto({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
  });

  factory FavoriteHotelDto.fromDomain(FavoriteHotel hotel) {
    return FavoriteHotelDto(
      id: hotel.id,
      name: hotel.name,
      ruc: hotel.ruc,
      address: hotel.address,
    );
  }

  FavoriteHotel toDomain() {
    return FavoriteHotel(
      id: id,
      name: name,
      ruc: ruc,
      address: address,
    );
  }

  factory FavoriteHotelDto.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    final id = parseInt(map['id'] ?? map['Id']);
    final name = (map['name'] ?? map['hotelName'] ?? '') as String;
    final ruc = (map['ruc'] ?? map['RUC'] ?? '') as String;
    final address = (map['address'] ?? map['direccion'] ?? '') as String;

    return FavoriteHotelDto(
      id: id,
      name: name,
      ruc: ruc,
      address: address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ruc': ruc,
      'address': address,
    };
  }
}
