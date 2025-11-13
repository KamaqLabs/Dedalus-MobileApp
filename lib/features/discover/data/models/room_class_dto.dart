import 'package:dedalus/features/discover/domain/entities/room_class.dart';

class RoomClassDto {
  final int id;
  final String roomClassName;
  final int maxOccupancy;
  final double defaultPricePerNight;
  final String? description;

  const RoomClassDto({
    required this.id,
    required this.roomClassName,
    required this.maxOccupancy,
    required this.defaultPricePerNight,
    this.description,
  });

  factory RoomClassDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return RoomClassDto(
      id: parseInt(json['id'] ?? json['Id']),
      roomClassName: (json['roomClassName'] ?? json['room_class_name'] ?? '') as String,
      maxOccupancy: parseInt(json['maxOccupancy'] ?? json['max_occupancy']),
      defaultPricePerNight:
          parseDouble(json['defaultPricePerNight'] ?? json['default_price_per_night']),
      description: (json['description'] ?? json['desc']) as String?,
    );
  }

  RoomClass toDomain() {
    return RoomClass(
      id: id,
      roomClassName: roomClassName,
      maxOccupancy: maxOccupancy,
      defaultPricePerNight: defaultPricePerNight,
      description: description,
    );
  }
}
