import 'package:dedalus/features/discover/data/datasources/room_service.dart';
import 'package:dedalus/features/discover/domain/entities/room.dart';

class RoomRepository {
  final RoomService _service;

  RoomRepository({RoomService? service}) : _service = service ?? RoomService();

  /// Obtiene las habitaciones de un hotel y devuelve entidades de dominio.
  Future<List<Room>> getRoomsByHotel(int hotelId) async {
    final dtos = await _service.getRoomsByHotel(hotelId);
    return dtos.map((d) => d.toDomain()).toList();
  }
}
