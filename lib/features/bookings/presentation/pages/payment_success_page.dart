import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/app/main_page.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:dedalus/features/bookings/domain/entities/booking.dart';

class PaymentSuccessPage extends StatefulWidget {
  final Booking booking;
  
  const PaymentSuccessPage({
    super.key,
    required this.booking,
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage> {
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = true;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = await _userRepository.getCurrentUser();
      if (mounted) {
        setState(() {
          _userName = user?.username ?? 'User';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userName = 'User';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  
                  // Success icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: ColorPalette.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Success text
                  const Text(
                    'Payment Received Successfully',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Confirmation text
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Congratulations! ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '🎉',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'Your booking has been confirmed',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Back to home button
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // Volver a la página principal con el nombre de usuario y limpiar todas las rutas anteriores
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage(userName: _userName),
                            ),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
