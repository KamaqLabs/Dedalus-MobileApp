import 'package:dedalus/features/discover/domain/entities/hotel.dart';

class FavoriteHotel {
  final int id;
  final String name;
  final String ruc;
  final String address;

  const FavoriteHotel({
    required this.id,
    required this.name,
    required this.ruc,
    required this.address,
  });

  Hotel toHotel() {
    return Hotel(
      id: id,
      name: name,
      ruc: ruc,
      address: address,
    );
  }
}
