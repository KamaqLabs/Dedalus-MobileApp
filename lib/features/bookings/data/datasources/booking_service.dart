import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedalus/features/bookings/data/models/booking_dto.dart';
import 'package:dedalus/features/bookings/data/models/create_booking_request_dto.dart';

class BookingService {
  static const String _defaultBase = 'http://localhost:3000/api/v1';
  static final String baseUrl =
      const String.fromEnvironment('API_URL_Dedalus', defaultValue: _defaultBase);

  /// POST {baseUrl}/Booking/Bookings/{hotelId}
  Future<BookingDto> createBooking(int hotelId, CreateBookingRequestDto body) async {
    final uri = Uri.parse('$baseUrl/Booking/Bookings/$hotelId');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.post(uri, headers: headers, body: jsonEncode(body.toJson()));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return BookingDto.fromJson(data);
    } else {
      String message = 'Failed creating booking (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// GET {baseUrl}/Booking/Bookings/ByGuestId/{guestId}
  Future<List<BookingDto>> getBookingsByGuestId(int guestId) async {
    final uri = Uri.parse('$baseUrl/Booking/Bookings/ByGuestId/$guestId');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      try {
        final List<dynamic> list = jsonDecode(resp.body) as List<dynamic>;
        return list
            .map((e) => BookingDto.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      } catch (e) {
        // Si la respuesta no es lista o está vacía, devolver lista vacía
        return <BookingDto>[];
      }
    } else {
      String message = 'Failed fetching bookings (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }
}
