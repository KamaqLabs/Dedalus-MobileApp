import 'package:dedalus/features/auth/domain/entities/user.dart';
import 'package:dedalus/features/auth/domain/entities/auth_session.dart';

abstract class AuthState {
  const AuthState();
}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final AuthSession session;
  final User? user; // puede ser null si aún no tenemos el perfil completo
  const SuccessAuthState({required this.session, this.user});
}

// Estado cuando el usuario se ha registrado correctamente (sin sesión)
class RegisteredAuthState extends AuthState {
  final User user;
  const RegisteredAuthState({required this.user});
}

class FailureAuthState extends AuthState {
  final String errorMessage;
  const FailureAuthState({required this.errorMessage});
}
