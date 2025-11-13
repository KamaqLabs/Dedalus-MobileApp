class Booking {
  final int id;
  final int hotelId;
  final int roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String bookStatus;
  final double totalPrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int durationInDays;
  final bool isActive;
  final Guest? guest;

  const Booking({
    required this.id,
    required this.hotelId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.bookStatus,
    required this.totalPrice,
    this.createdAt,
    this.updatedAt,
    required this.durationInDays,
    required this.isActive,
    this.guest,
  });
}

// Guest minimal domain model used inside booking (maps from UserDto)
class Guest {
  final int id;
  final String name;
  final String lastName;
  final String dni;
  final String email;
  final String phoneNumber;
  final String? status;
  final String? nfcKey;
  final String? guestCode;
  final int? accountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Guest({
    required this.id,
    required this.name,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phoneNumber,
    this.status,
    this.nfcKey,
    this.guestCode,
    this.accountId,
    this.createdAt,
    this.updatedAt,
  });
}
