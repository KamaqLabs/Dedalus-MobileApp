import 'package:dedalus/features/discover/domain/entities/room.dart';
import 'package:dedalus/features/discover/data/models/room_class_dto.dart';

class RoomDto {
  final int id;
  final int hotelId;
  final String roomNumber;
  final int? floor;
  final String? nfcKey;
  final List<int> modulesId;
  final String roomStatus;
  final RoomClassDto roomClass;

  const RoomDto({
    required this.id,
    required this.hotelId,
    required this.roomNumber,
    this.floor,
    this.nfcKey,
    required this.modulesId,
    required this.roomStatus,
    required this.roomClass,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    List<int> parseModules(dynamic v) {
      if (v == null) return <int>[];
      if (v is List) {
        return v.map((e) {
          if (e is int) return e;
          return int.tryParse(e.toString()) ?? 0;
        }).where((i) => i != 0).toList();
      }
      return <int>[];
    }

    final roomClassJson = json['roomClass'] ?? json['room_class'] ?? <String, dynamic>{};

    return RoomDto(
      id: parseInt(json['id'] ?? json['Id']),
      hotelId: parseInt(json['hotelId'] ?? json['hotel_id']),
      roomNumber: (json['roomNumber'] ?? json['room_number'] ?? '') as String,
      floor: json['floor'] is int ? json['floor'] as int : (json['floor'] != null ? int.tryParse(json['floor'].toString()) : null),
      nfcKey: (json['nfcKey'] ?? json['nfc_key']) as String?,
      modulesId: parseModules(json['modulesId'] ?? json['modules_id']),
      roomStatus: (json['roomStatus'] ?? json['room_status'] ?? '') as String,
      roomClass: RoomClassDto.fromJson(roomClassJson as Map<String, dynamic>),
    );
  }

  Room toDomain() {
    return Room(
      id: id,
      hotelId: hotelId,
      roomNumber: roomNumber,
      floor: floor,
      nfcKey: nfcKey,
      modulesId: modulesId,
      roomStatus: roomStatus,
      roomClass: roomClass.toDomain(),
    );
  }
}
