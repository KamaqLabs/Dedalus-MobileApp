import 'package:dedalus/features/bookings/domain/entities/booking.dart';
import 'package:dedalus/features/auth/data/models/user_dto.dart';

class BookingDto {
  final int id;
  final int hotelId;
  final int roomId;
  final String checkInDate;
  final String checkOutDate;
  final String bookStatus;
  final double totalPrice;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? guest;
  final int durationInDays;
  final bool isActive;

  const BookingDto({
    required this.id,
    required this.hotelId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookStatus,
    required this.totalPrice,
    this.createdAt,
    this.updatedAt,
    this.guest,
    required this.durationInDays,
    required this.isActive,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) {
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

    return BookingDto(
      id: parseInt(json['id'] ?? json['Id']),
      hotelId: parseInt(json['hotelId'] ?? json['hotel_id']),
      roomId: parseInt(json['roomId'] ?? json['room_id']),
      checkInDate: (json['checkInDate'] ?? json['check_in_date'] ?? '') as String,
      checkOutDate: (json['checkOutDate'] ?? json['check_out_date'] ?? '') as String,
      bookStatus: (json['bookStatus'] ?? json['book_status'] ?? '') as String,
      totalPrice: parseDouble(json['totalPrice'] ?? json['total_price']),
      createdAt: (json['createdAt'] ?? json['created_at']) as String?,
      updatedAt: (json['updatedAt'] ?? json['updated_at']) as String?,
      guest: json['guest'] is Map<String, dynamic> ? Map<String, dynamic>.from(json['guest']) : null,
      durationInDays: parseInt(json['durationInDays'] ?? json['duration_in_days']),
      isActive: (json['isActive'] ?? json['is_active'] ?? true) as bool,
    );
  }

  Booking toDomain() {
    Guest? g;
    if (guest != null) {
      try {
        final ud = UserDto.fromJson(guest!);
        final u = ud.toDomain();
        g = Guest(
          id: u.id,
          name: u.name,
          lastName: u.lastName,
          dni: u.dni,
          email: u.email,
          phoneNumber: u.phoneNumber,
          status: u.status,
          nfcKey: u.nfcKey,
          guestCode: u.guestCode,
          accountId: u.accountId,
          createdAt: u.createdAt,
          updatedAt: u.updatedAt,
        );
      } catch (_) {
        g = null;
      }
    }

    DateTime parseDate(String s) {
      try {
        return DateTime.parse(s);
      } catch (_) {
        return DateTime.tryParse(s) ?? DateTime.fromMillisecondsSinceEpoch(0);
      }
    }

    return Booking(
      id: id,
      hotelId: hotelId,
      roomId: roomId,
      checkInDate: parseDate(checkInDate),
      checkOutDate: parseDate(checkOutDate),
      bookStatus: bookStatus,
      totalPrice: totalPrice,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
      durationInDays: durationInDays,
      isActive: isActive,
      guest: g,
    );
  }
}
