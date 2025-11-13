import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class CreateBookingEvent extends BookingEvent {
  final int hotelId;
  final int guestId;
  final int roomId;
  final String checkInDate; // yyyy-MM-dd
  final String checkOutDate;

  const CreateBookingEvent({
    required this.hotelId,
    required this.guestId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  List<Object?> get props => [hotelId, guestId, roomId, checkInDate, checkOutDate];
}
