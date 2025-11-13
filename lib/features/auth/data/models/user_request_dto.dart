class UserRequestDto {
  final String username;
  final String password;
  
  const UserRequestDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

//DTO para registro (guest profile)
class RegisterUserRequestDto {
  final String username;
  final String password;
  final String name;
  final String lastName;
  final String dni;
  final String email;
  final String phoneNumber;

  const RegisterUserRequestDto({
    required this.username,
    required this.password,
    required this.name,
    required this.lastName,
    required this.dni,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'name': name,
      'lastName': lastName,
      'dni': dni,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
