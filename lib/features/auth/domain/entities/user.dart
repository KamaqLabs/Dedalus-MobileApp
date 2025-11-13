class User {
  final int id;
  final String username;
  final String name;
  final String lastName;
  final String dni;
  final String email;  
  final String phoneNumber;

  // Campos provenientes del backend
  final int? accountId;
  final String? status;
  final String? nfcKey;
  final String? guestCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
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
}
