import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dedalus/features/auth/data/models/user_dto.dart';

class ProfileService {
  static const String _defaultBase = 'http://localhost:3000/api/v1';
  static final String baseUrl =
      const String.fromEnvironment('API_URL_Dedalus', defaultValue: _defaultBase);

  /// GET {baseUrl}/profile/guest-profiles/{id}
  Future<UserDto> getGuestProfile(int id) async {
    final uri = Uri.parse('$baseUrl/profile/guest-profiles/$id');
    final headers = {'Content-Type': 'application/json'};

    final resp = await http.get(uri, headers: headers);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return UserDto.fromJson(data);
    } else {
      String message = 'Failed fetching profile (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// PUT {baseUrl}/profile/guest-profiles/{id}
  /// Body must contain: { name, lastName, dni, email, phoneNumber }
  Future<UserDto> updateGuestProfile(int id, Map<String, dynamic> body) async {
    final uri = Uri.parse('$baseUrl/profile/guest-profiles/$id');
    final headers = {'Content-Type': 'application/json'};
    final resp = await http.put(uri, headers: headers, body: jsonEncode(body));

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return UserDto.fromJson(data);
    } else {
      String message = 'Failed updating profile (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }
}
