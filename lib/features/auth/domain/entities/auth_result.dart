import 'package:dedalus/features/auth/domain/entities/auth_session.dart';
import 'package:dedalus/features/auth/domain/entities/user.dart';

class AuthResult {
  final AuthSession session;
  final User? user;

  const AuthResult({required this.session, this.user});
}
