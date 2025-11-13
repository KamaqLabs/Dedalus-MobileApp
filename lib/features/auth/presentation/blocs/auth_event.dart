abstract class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final String username;
  final String password;

  const SignInEvent({required this.username, required this.password});
}

// Campos requeridos por la API
class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String dni;
  final String phoneNumber;

  const RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.dni,
    required this.phoneNumber,
  });
}
