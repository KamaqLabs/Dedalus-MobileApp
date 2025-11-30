import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auth_response_dto.dart';
import '../models/user_dto.dart';
import '../models/user_request_dto.dart';

class AuthService {
  // Se puede sobrescribir con --dart-define=API_URL_Dedalus=<url>
  static const String _defaultBase =
      'https://sogw0gwg8w0w8ok8gkgwsso0.4.201.187.236.sslip.io/api/v1'; 
  static final String baseUrl =
      const String.fromEnvironment('API_URL_Dedalus', defaultValue: _defaultBase);

  // Endpoint: {baseUrl}/authentication/sign-in
  Future<AuthResponseDto> signIn({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/authentication/sign-in');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': username, 'password': password});

    final resp = await http.post(uri, headers: headers, body: body);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return AuthResponseDto.fromJson(data);
    } else {
      String message = 'Auth failed (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) {message = err['message'].toString();}
        else if (err.containsKey('error')) {message = err['error'].toString();}
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// POST {baseUrl}/profile/guest-profiles
  /// Envía dto.toJson() y devuelve UserDto con el perfil creado.
  Future<UserDto> registerGuestProfile(RegisterUserRequestDto dto) async {
    final uri = Uri.parse('$baseUrl/profile/guest-profiles');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(dto.toJson());

    final resp = await http.post(uri, headers: headers, body: body);

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
      return UserDto.fromJson(data);
    } else {
      String message = 'Register failed (${resp.statusCode})';
      try {
        final Map<String, dynamic> err = jsonDecode(resp.body) as Map<String, dynamic>;
        if (err.containsKey('message')) message = err['message'].toString();
        else if (err.containsKey('error')) message = err['error'].toString();
      } catch (_) {}
      throw Exception(message);
    }
  }
}
