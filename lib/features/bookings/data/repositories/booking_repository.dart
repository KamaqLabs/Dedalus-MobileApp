import 'package:dedalus/features/bookings/data/datasources/booking_service.dart';
import 'package:dedalus/features/bookings/data/models/create_booking_request_dto.dart';
import 'package:dedalus/features/bookings/domain/entities/booking.dart';

class BookingRepository {
  final BookingService _service;

  BookingRepository({BookingService? service}) : _service = service ?? BookingService();

  /// Crea un booking para el hotelId usando los datos proporcionados.
  Future<Booking> createBooking({
    required int hotelId,
    required int guestId,
    required int roomId,
    required String checkInDate, // yyyy-MM-dd
    required String checkOutDate, // yyyy-MM-dd
  }) async {
    final req = CreateBookingRequestDto(
      guestId: guestId,
      roomId: roomId,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
    );
    final dto = await _service.createBooking(hotelId, req);
    return dto.toDomain();
  }
}
