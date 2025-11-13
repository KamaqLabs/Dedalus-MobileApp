import 'package:get_storage/get_storage.dart';
import 'package:dedalus/features/auth/domain/entities/user.dart';

class UserRepository {
  static const String _currentUserKey = 'current_user';
  static const String _authProfileKey = 'auth_profile';
  final GetStorage _storage = GetStorage();

  // Inicializar GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  // Guardar usuario (almacena solo campos reales que devuelve el backend)
  Future<void> saveUser(User user) async {
    await _storage.write(_currentUserKey, {
      'id': user.id,
      'username': user.username,
      'name': user.name,
      'lastName': user.lastName,
      'dni': user.dni,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'accountId': user.accountId,
      'status': user.status,
      'nfcKey': user.nfcKey,
      'guestCode': user.guestCode,
      'createdAt': user.createdAt?.toIso8601String(),
      'updatedAt': user.updatedAt?.toIso8601String(),
    });
  }
  
  // Obtener usuario actual
  Future<User?> getCurrentUser() async {
    final userData = _storage.read(_currentUserKey);
    
    if (userData != null && userData is Map) {
      int? parseInt(dynamic v) {
        if (v == null) return null;
        if (v is int) return v;
        return int.tryParse(v.toString());
      }

      DateTime? parseDate(dynamic v) {
        if (v == null) return null;
        if (v is DateTime) return v;
        return DateTime.tryParse(v.toString());
      }

      final id = parseInt(userData['id']) ?? 0;
      final username = (userData['username'] ?? '') as String;
      final name = (userData['name'] ?? '') as String;
      final lastName = (userData['lastName'] ?? userData['last_name'] ?? '') as String;
      final dni = (userData['dni'] ?? '') as String;
      final email = (userData['email'] ?? '') as String;
      final phoneNumber = (userData['phoneNumber'] ?? userData['phone_number'] ?? '') as String;
      final accountId = parseInt(userData['accountId'] ?? userData['account_id']);
      final status = userData['status'] as String?;
      final nfcKey = userData['nfcKey'] as String? ?? userData['nfc_key'] as String?;
      final guestCode = userData['guestCode'] as String? ?? userData['guest_code'] as String?;
      final createdAt = parseDate(userData['createdAt'] ?? userData['created_at']);
      final updatedAt = parseDate(userData['updatedAt'] ?? userData['updated_at']);

      return User(
        id: id,
        username: username,
        name: name,
        lastName: lastName,
        dni: dni,
        email: email,
        phoneNumber: phoneNumber,
        accountId: accountId,
        status: status,
        nfcKey: nfcKey,
        guestCode: guestCode,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }
    
    return null;
  }
  
  // Obtener metadatos de autenticación / profile (p. ej. { "profileId": 1, ... })
  Future<Map<String, dynamic>?> getAuthProfileMeta() async {
    final meta = _storage.read(_authProfileKey);
    if (meta != null && meta is Map) {
      return Map<String, dynamic>.from(meta);
    }
    return null;
  }

  // Guardar metadatos de autenticación (opcional, usado por AuthRepository)
  Future<void> saveAuthProfileMeta(Map<String, dynamic> meta) async {
    await _storage.write(_authProfileKey, meta);
  }

  // Borra todo lo relacionado con el usuario/autorization (compatibilidad con clear())
  Future<void> clear() async {
    await _storage.remove(_currentUserKey);
    await _storage.remove(_authProfileKey);
  }

  // Cerrar sesión
  Future<void> logout() async {
    await clear();
  }
}
