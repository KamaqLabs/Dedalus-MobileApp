import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart';
import 'package:dedalus/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/app/main_page.dart';
import 'package:dedalus/features/auth/presentation/pages/registration_page.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_event.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SuccessAuthState) {
          final displayName = state.user?.name ?? state.session.username;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HotelBloc(
                  repository: HotelRepository(),
                ),
                child: MainPage(userName: displayName),
              ),
            ),
          );
        } else if (state is FailureAuthState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state is LoadingAuthState;
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: AbsorbPointer(
                  absorbing: isLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/dedalus_logo.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Let's Login!",
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _usernameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Enter Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: ColorPalette.primaryColor,
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: Icon(
                              Icons.person_outlined,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: !_isVisible,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: ColorPalette.primaryColor,
                                width: 2.0,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: ColorPalette.primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isVisible = !_isVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor,
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    SignInEvent(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                            child: const Text('Sign In'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: ColorPalette.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLoading)
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
