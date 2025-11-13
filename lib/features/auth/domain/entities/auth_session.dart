class AuthSession {
  final String token;
  final String? refreshToken;
  final int profileId;
  final String username;
  final String rol;

  const AuthSession({
    required this.token,
    this.refreshToken,
    required this.profileId,
    required this.username,
    required this.rol,
  });
}
