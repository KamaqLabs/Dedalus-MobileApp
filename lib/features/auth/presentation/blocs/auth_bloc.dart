import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedalus/features/auth/data/repositories/auth_repository.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';
import 'package:dedalus/features/auth/data/models/user_request_dto.dart';
import 'package:dedalus/features/auth/domain/entities/user.dart';
import 'package:dedalus/features/auth/domain/entities/auth_result.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_event.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthBloc({
    AuthRepository? authRepository,
    UserRepository? userRepository,
  })  : _authRepository = authRepository ?? AuthRepository(),
        _userRepository = userRepository ?? UserRepository(),
        super(InitialAuthState()) {
    on<SignInEvent>(_onSignIn);
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      final AuthResult result = await _authRepository.signIn(
        username: event.username,
        password: event.password,
      );

      // Si por alguna razón user es null, intentamos leer localmente como fallback
      User? user = result.user;
      if (user == null) {
        user = await _userRepository.getCurrentUser();
      }

      emit(SuccessAuthState(session: result.session, user: user));
    } catch (e) {
      emit(FailureAuthState(errorMessage: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(LoadingAuthState());
    try {
      // Usar todos los campos requeridos por la API
      final dto = RegisterUserRequestDto(
        username: event.username,
        password: event.password,
        name: event.firstName,
        lastName: event.lastName,
        dni: event.dni,
        email: event.email,
        phoneNumber: event.phoneNumber,
      );

      final User user = await _authRepository.register(dto);

      emit(RegisteredAuthState(user: user));
    } catch (e) {
      emit(FailureAuthState(errorMessage: e.toString()));
    }
  }
}
