import 'package:dedalus/features/discover/data/repositories/hotel_repository.dart'; // Añadir este import
import 'package:dedalus/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/auth/presentation/pages/login_page.dart';
import 'package:dedalus/features/app/main_page.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_event.dart';
import 'package:dedalus/features/auth/presentation/blocs/auth_state.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Nuevos controladores requeridos por la API
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // La ruta de registro emite RegisteredAuthState (sin auto-login).
        if (state is RegisteredAuthState) {
          // Navegar a MainPage pasando el nombre del usuario
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HotelBloc(
                  repository: HotelRepository(), 
                ),
                child: MainPage(userName: state.user.name),
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
                          "Let's Register!",
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
                          controller: _firstNameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "First name",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _lastNameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Last name",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _emailController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Email",
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
                          ),
                        ),
                      ),
                      // DNI (required)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _dniController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "DNI",
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
                          ),
                        ),
                      ),
                      // Phone number (required)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Phone number (e.g. +51987654321)",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _usernameController,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Username",
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
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          cursorColor: ColorPalette.primaryColor,
                          decoration: InputDecoration(
                            hintText: "Password",
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
                              Icons.lock_outline,
                              color: ColorPalette.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPalette.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                              // Enviar todos los campos requeridos por la API
                              context.read<AuthBloc>().add(
                                RegisterEvent(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                  dni: _dniController.text,
                                  phoneNumber: _phoneController.text,
                                ),
                              );
                            },
                            child: const Text(
                              "Register",
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: Text(
                                "Login",
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
