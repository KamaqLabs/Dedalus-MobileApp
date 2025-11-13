import 'package:dedalus/features/discover/domain/entities/room_class.dart';

class Room {
  final int id;
  final int hotelId;
  final String roomNumber;
  final int? floor;
  final String? nfcKey;
  final List<int> modulesId;
  final String roomStatus;
  final RoomClass roomClass;

  const Room({
    required this.id,
    required this.hotelId,
    required this.roomNumber,
    this.floor,
    this.nfcKey,
    required this.modulesId,
    required this.roomStatus,
    required this.roomClass,
  });
}
