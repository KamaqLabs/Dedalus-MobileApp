class CreateBookingRequestDto {
  final int guestId;
  final int roomId;
  final String checkInDate; // yyyy-MM-dd
  final String checkOutDate; // yyyy-MM-dd

  const CreateBookingRequestDto({
    required this.guestId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'guestId': guestId,
      'roomId': roomId,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
    };
  }
}
