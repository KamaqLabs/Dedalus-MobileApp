import 'package:dedalus/features/discover/data/datasources/hotel_service.dart';
import 'package:dedalus/features/discover/domain/entities/hotel.dart';

class HotelRepository {
  final HotelService _service;

  HotelRepository({HotelService? service}) : _service = service ?? HotelService();

  /// Obtiene hotel por id y devuelve la entidad de dominio Hotel
  Future<Hotel> getHotel(int id) async {
    final dto = await _service.getHotelById(id);
    return dto.toDomain();
  }

  /// Obtiene todos los hoteles (usa el endpoint GET /Hotel/Hotels)
  Future<List<Hotel>> getHotels() async {
    final dtos = await _service.getAllHotels();
    return dtos.map((d) => d.toDomain()).toList();
  }

  /// Búsqueda por texto: por ahora no hay endpoint, dejar para que el Bloc filtre localmente
  Future<List<Hotel>> searchHotels(String query) async {
    // Intentamos usar getAllHotels y luego filtrar en la capa superior.
    final all = await getHotels();
    final q = query.toLowerCase();
    return all.where((h) {
      return h.name.toLowerCase().contains(q) ||
             h.address.toLowerCase().contains(q) ||
             h.ruc.toLowerCase().contains(q);
    }).toList();
  }
}
