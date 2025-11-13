import 'dart:convert';
import 'dart:io';
import 'package:dedalus/features/bookings/archive/book_item_dto.dart';
import 'package:dedalus/features/bookings/archive/book_item_request_dto.dart';
import 'package:dedalus/features/bookings/archive/book_item.dart';
import 'package:http/http.dart' as http;

class BookItemService {
  final String baseUrl = 'https://logisticsmasters.onrender.com';

  // Método privado para manejar respuestas HTTP y convertir a BookItem
  Future<BookItem> _processResponse(http.Response response, {BookItem? originalBooking}) {
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    
    if (response.statusCode == HttpStatus.ok || 
        response.statusCode == HttpStatus.created) {
      
      // Si la respuesta está vacía o no es un JSON válido, usar los datos enviados
      if (response.body.isEmpty && originalBooking != null) {
        print("Empty response, using original BookItem");
        return Future.value(originalBooking);
      }
      
      try {
        final json = jsonDecode(response.body);
        // Asegurarse de que el ID sea un string
        if (json['id'] != null && json['id'] is int) {
          json['id'] = json['id'].toString();
        }
        return Future.value(BookItemDto.fromJson(json).toDomain());
      } catch (parseError) {
        print("Error parsing response: $parseError");
        if (originalBooking != null) {
          return Future.value(originalBooking);
        }
        return Future.error(Exception('Error parsing response: $parseError'));
      }
    }
    
    return Future.error(Exception('HTTP Error: ${response.statusCode}'));
  }

  // Crear una nueva reserva
  Future<BookItem> createBooking(BookItem booking, String userId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings');
    
    try {
      final requestDto = BookItemRequestDto.fromDomain(booking, userId);
      final jsonData = requestDto.toJson();
      
      print("Sending booking data: $jsonData");
      
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      
      return _processResponse(response, originalBooking: booking);
    } catch (e) {
      print("Exception in createBooking: $e");
      
      // Si la excepción ocurrió después de crear exitosamente la reserva,
      // pero hubo un problema al procesar la respuesta, devolver el objeto original
      if (e.toString().contains("type 'int' is not a subtype of type 'String'")) {
        print("Type error detected but booking likely created. Returning original booking.");
        return booking;
      }
      
      throw Exception('Error creating booking: $e');
    }
  }

  // Obtener todas las reservas de un usuario
  Future<List<BookItem>> getUserBookings(String userId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings?userId=$userId');
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => BookItemDto.fromJson(json).toDomain())
            .where((booking) => booking.status != 'deleted') // Filtrar elementos eliminados
            .toList();
      }
      
      throw Exception('Failed to load bookings: ${response.statusCode}');
    } catch (e) {
      print("Error in getUserBookings: $e");
      throw Exception('Error loading bookings: $e');
    }
  }

  // Obtener una reserva específica
  Future<BookItem> getBooking(String bookingId) async {
    final Uri uri = Uri.parse('$baseUrl/bookings/$bookingId');
    
    try {
      final response = await http.get(uri);
      return _processResponse(response);
    } catch (e) {
      print("Error in getBooking: $e");
      throw Exception('Error fetching booking: $e');
    }
  }

  // Método privado para actualizar el estado de una reserva
  Future<BookItem> _updateBookingStatus(String bookingId, String status, {String? userId}) async {
    final Uri uri = Uri.parse('$baseUrl/bookings/$bookingId');
    
    try {
      // Primero obtenemos la reserva actual
      final getResponse = await http.get(uri);
      
      if (getResponse.statusCode == HttpStatus.ok) {
        // Obtener los datos actuales de la reserva
        final Map<String, dynamic> bookingData = jsonDecode(getResponse.body);
        
        // Verificar que el usuario sea el propietario si se proporciona un userId
        if (userId != null && 
            bookingData['userId'] != null && 
            bookingData['userId'].toString() != userId) {
          throw Exception('User is not authorized to modify this booking');
        }
        
        // Actualizar el estado
        bookingData['status'] = status;
        
        // Actualizar la reserva con el nuevo estado
        final updateResponse = await http.put(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(bookingData),
        );
        
        return _processResponse(updateResponse);
      } else {
        throw Exception('Failed to get booking: ${getResponse.statusCode}');
      }
    } catch (e) {
      print("Error updating booking status to $status: $e");
      throw Exception('Error updating booking status: $e');
    }
  }

  // Cancelar una reserva
  Future<BookItem> cancelBooking(String bookingId) async {
    return _updateBookingStatus(bookingId, 'cancelled');
  }

  // Eliminar una reserva (lógicamente)
  Future<BookItem> deleteBooking(String bookingId, String userId) async {
    return _updateBookingStatus(bookingId, 'deleted', userId: userId);
  }

  // Añadir método para restaurar reservas eliminadas

  // Restaurar una reserva eliminada (deshacer eliminación lógica)
  Future<BookItem> undoDeleteBooking(String bookingId, String userId) async {
    // Para restaurar, simplemente cambiamos el estado de nuevo a 'completed' o al estado anterior
    return _updateBookingStatus(bookingId, 'completed', userId: userId);
  }
}
