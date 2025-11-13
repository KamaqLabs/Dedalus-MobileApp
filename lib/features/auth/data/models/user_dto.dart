import 'package:dedalus/features/auth/domain/entities/user.dart';

class UserDto {
  final int id;
  final String username;
  final String name;
  final String lastName;
  final String dni;
  final String email;
  final String phoneNumber;

  // Nuevos campos
  final int? accountId;
  final String? status;
  final String? nfcKey;
  final String? guestCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserDto({
    required this.id,
    required this.username,
    required this.name,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phoneNumber,
    this.accountId,
    this.status,
    this.nfcKey,
    this.guestCode,
    this.createdAt,
    this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v;
      final s = v.toString();
      return DateTime.tryParse(s);
    }

    final rawId = json['id'] ?? json['Id'];
    final id = rawId is int ? rawId : (rawId != null ? int.tryParse(rawId.toString()) ?? 0 : 0);

    final rawAccountId = json['accountId'] ?? json['account_id'];
    final accountId = rawAccountId is int ? rawAccountId : (rawAccountId != null ? int.tryParse(rawAccountId.toString()) : null);

    final username = (json['username'] ?? json['user_name'] ?? '') as String;
    final name = (json['name'] ?? json['firstName'] ?? json['first_name'] ?? '') as String;
    final lastName = (json['lastName'] ?? json['last_name'] ?? '') as String;
    final dni = (json['dni'] ?? '') as String;
    final email = (json['email'] ?? '') as String;
    final phoneNumber = (json['phoneNumber'] ?? json['phone_number'] ?? '') as String;

    return UserDto(
      id: id,
      username: username,
      name: name,
      lastName: lastName,
      dni: dni,
      email: email,
      phoneNumber: phoneNumber,
      accountId: accountId,
      status: (json['status'] ?? json['account_status']) as String?,
      nfcKey: (json['nfcKey'] ?? json['nfc_key']) as String?,
      guestCode: (json['guestCode'] ?? json['guest_code']) as String?,
      createdAt: parseDate(json['createdAt'] ?? json['created_at']),
      updatedAt: parseDate(json['updatedAt'] ?? json['updated_at']),
    );
  }

  User toDomain() {
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
}
