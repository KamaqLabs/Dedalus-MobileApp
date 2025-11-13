import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dedalus/features/auth/data/datasources/auth_service.dart';
import 'package:dedalus/features/auth/data/models/auth_response_dto.dart';
import 'package:dedalus/features/auth/domain/entities/auth_result.dart';
import 'package:dedalus/features/auth/domain/entities/auth_session.dart';
import 'package:dedalus/features/auth/data/datasources/profile_service.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';
import 'package:dedalus/features/auth/data/models/user_request_dto.dart';
import 'package:dedalus/features/auth/data/models/user_dto.dart';
import 'package:dedalus/features/auth/domain/entities/user.dart';

class AuthRepository {
  final AuthService _service = AuthService();
  final FlutterSecureStorage _secure = const FlutterSecureStorage();
  final GetStorage _storage = GetStorage();

  // servicios/repo para perfil
  final ProfileService _profileService = ProfileService();
  final UserRepository _userRepository = UserRepository();

  static const String _tokenKey = 'auth_token';
  static const String _refreshKey = 'refresh_token';
  static const String _authProfileKey = 'auth_profile';

  /// Sign in and persist tokens securely.
  /// Returns an AuthSession (domain) suitable for Blocs/UI.
  // antes: Future<AuthSession> signIn(...)
  Future<AuthResult> signIn({
    required String username,
    required String password,
    bool persistTokensSecure = true,
  }) async {
    final AuthResponseDto dto = await _service.signIn(username: username, password: password);

    // persistir tokens (secure) y meta pública (GetStorage)
    if (persistTokensSecure) {
      await _secure.write(key: _tokenKey, value: dto.token);
      if (dto.refreshToken != null) {
        await _secure.write(key: _refreshKey, value: dto.refreshToken);
      }
    } else {
      // fallback (not recommended) - keep tokens in GetStorage
      await _storage.write(_authProfileKey, {
        'token': dto.token,
        'refreshToken': dto.refreshToken,
        'profileId': dto.profileId,
        'username': dto.username,
        'rol': dto.rol,
      });
    }

    // Persist public auth meta for quick access (non-sensitive)
    await _storage.write('auth_profile_meta', {
      'profileId': dto.profileId,
      'username': dto.username,
      'rol': dto.rol,
    });

    // Obtener perfil remoto por profileId, convertir y guardar localmente
    final session = AuthSession(
      token: dto.token,
      refreshToken: dto.refreshToken,
      profileId: dto.profileId,
      username: dto.username,
      rol: dto.rol,
    );

    User? user;
    try {
      final userDto = await _profileService.getGuestProfile(dto.profileId);
      user = userDto.toDomain();
      await _userRepository.saveUser(user);
    } catch (_) {
      user = null; // no bloquear el login
    }

    return AuthResult(session: session, user: user);
  }

  /// Logout: remove tokens and public meta
  Future<void> logout() async {
    await _secure.delete(key: _tokenKey);
    await _secure.delete(key: _refreshKey);
    await _storage.remove('auth_profile_meta');
  }

  /// Get access token from secure storage (nullable)
  Future<String?> getAccessToken() => _secure.read(key: _tokenKey);

  /// Get refresh token from secure storage (nullable)
  Future<String?> getRefreshToken() => _secure.read(key: _refreshKey);

  /// Read public auth profile meta from GetStorage
  Map<String, dynamic>? getAuthProfile() {
    final data = _storage.read('auth_profile_meta');
    if (data == null || data is! Map) return null;
    return {
      'profileId': data['profileId'],
      'username': data['username'],
      'rol': data['rol'],
    };
  }

  /// Registra un guest profile usando AuthService.registerGuestProfile,
  /// convierte a dominio, lo guarda en UserRepository y devuelve User.
  Future<User> register(RegisterUserRequestDto dto) async {
    final UserDto userDto = await _service.registerGuestProfile(dto);
    final user = userDto.toDomain();
    await _userRepository.saveUser(user);
    return user;
  }
}
