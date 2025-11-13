import 'dart:convert';

class AuthResponseDto {
  final String token;
  final String? refreshToken;
  final int profileId;
  final String username;
  final String rol;

  const AuthResponseDto({
    required this.token,
    this.refreshToken,
    required this.profileId,
    required this.username,
    required this.rol,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '0') ?? 0;
    }

    return AuthResponseDto(
      token: json['token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? json['refresh_token'] as String?,
      profileId: parseInt(json['profileId'] ?? json['profile_id']),
      username: json['username'] as String? ?? '',
      rol: json['rol'] as String? ?? json['role'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'profileId': profileId,
      'username': username,
      'rol': rol,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
