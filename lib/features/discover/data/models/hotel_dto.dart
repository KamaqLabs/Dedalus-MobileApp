import 'package:dedalus/features/discover/domain/entities/hotel.dart';

class HotelDto {
  final int id;
  final String name;
  final String ruc;
  final String address;

  const HotelDto({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
  });

  factory HotelDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    final rawId = json['id'] ?? json['Id'];
    final id = rawId is int ? rawId : parseInt(rawId);

    final name = (json['name'] ?? json['hotelName'] ?? '') as String;
    final ruc = (json['ruc'] ?? json['RUC'] ?? '') as String;
    final address = (json['address'] ?? json['direccion'] ?? '') as String;

    return HotelDto(
      id: id,
      name: name,
      ruc: ruc,
      address: address,
    );
  }

  Hotel toDomain() {
    return Hotel(
      id: id,
      name: name,
      ruc: ruc,
      address: address,
    );
  }
}
