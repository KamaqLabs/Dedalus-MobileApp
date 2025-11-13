import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedalus/features/discover/data/models/room_dto.dart';

class RoomService {
  static const String _defaultBase = 'http://localhost:3000/api/v1';
  static final String baseUrl =
      const String.fromEnvironment('API_URL_Dedalus', defaultValue: _defaultBase);

  /// GET {baseUrl}/Hotel/Rooms/ByHotel/{hotelId}
  Future<List<RoomDto>> getRoomsByHotel(int hotelId) async {
    final uri = Uri.parse('$baseUrl/Hotel/Rooms/ByHotel/$hotelId');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => RoomDto.fromJson(e))
          .toList();
    } else {
      String message = 'Failed fetching rooms (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }
}
