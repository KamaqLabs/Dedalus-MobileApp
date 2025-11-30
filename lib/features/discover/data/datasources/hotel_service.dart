import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedalus/features/discover/data/models/hotel_dto.dart';

class HotelService {
  static const String _defaultBase = 'https://sogw0gwg8w0w8ok8gkgwsso0.4.201.187.236.sslip.io/api/v1';
  static final String baseUrl =
      const String.fromEnvironment('API_URL_Dedalus', defaultValue: _defaultBase);

  /// GET {baseUrl}/Hotel/Hotels/{id}
  Future<HotelDto> getHotelById(int id) async {
    final uri = Uri.parse('$baseUrl/Hotel/Hotels/$id');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return HotelDto.fromJson(data);
    } else {
      String message = 'Failed fetching hotel (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// GET {baseUrl}/Hotel/Hotels
  Future<List<HotelDto>> getAllHotels() async {
    final uri = Uri.parse('$baseUrl/Hotel/Hotels');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
      return data
          .whereType<Map<String, dynamic>>()
          .map((e) => HotelDto.fromJson(e))
          .toList();
    } else {
      String message = 'Failed fetching hotels list (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// NOT IMPLEMENTED: search endpoint on backend — handled client-side by filtering getAllHotels
  Future<List<HotelDto>> searchHotels(String query) {
    throw UnsupportedError(
      'Use getAllHotels() + client-side filtering. Backend search not implemented.',
    );
  }
}
