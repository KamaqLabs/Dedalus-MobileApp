import 'package:flutter/material.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/auth/data/datasources/profile_service.dart';
import 'package:dedalus/features/auth/data/repositories/user_repository.dart';
import 'package:dedalus/features/auth/domain/entities/user.dart';
import 'package:dedalus/features/auth/presentation/pages/login_page.dart';
import 'package:dedalus/features/payment/presentation/pages/payment_methods_page.dart';
import 'package:dedalus/features/profile/presentation/pages/privacy_policy_page.dart';
import 'package:dedalus/features/profile/presentation/pages/terms_and_conditions_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _profileService = ProfileService();
  final UserRepository _userRepository = UserRepository();

  bool _isLoading = true;
  String? _errorMessage;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _lastNameCtrl = TextEditingController();
  final TextEditingController _dniCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final local = await _userRepository.getCurrentUser();
      if (local != null) {
        _applyUserToControllers(local);
        _currentUser = local;
      }

      int? profileId = local?.id;
      if (profileId == null) {
        // getAuthProfileMeta() es async -> await
        final meta = await _userRepository.getAuthProfileMeta();
        if (meta != null) {
          final raw = meta['profileId'];
          if (raw is int) {
            profileId = raw;
          } else if (raw != null) {
            profileId = int.tryParse(raw.toString());
          }
        }
      }

      if (profileId != null) {
        final remoteDto = await _profileService.getGuestProfile(profileId);
        final remote = remoteDto.toDomain();
        await _userRepository.saveUser(remote);
        _applyUserToControllers(remote);
        _currentUser = remote;
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading user data: $e';
        });
      }
    }
  }

  void _applyUserToControllers(User user) {
    _nameCtrl.text = user.name;
    _lastNameCtrl.text = user.lastName;
    _dniCtrl.text = user.dni;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phoneNumber;
  }

  Future<void> _updateProfile() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No profile to update')));
      return;
    }

    // Validación simple
    final name = _nameCtrl.text.trim();
    final lastName = _lastNameCtrl.text.trim();
    final dni = _dniCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();

    if (name.isEmpty || lastName.isEmpty || dni.isEmpty || email.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid email')));
      return;
    }

    if (int.tryParse(dni) == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('DNI must be numeric')));
      return;
    }

    final id = _currentUser!.id;
    final body = {
      'name': name,
      'lastName': lastName,
      'dni': dni,
      'email': email,
      'phoneNumber': phone,
    };

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedDto = await _profileService.updateGuestProfile(id, body);
      final updated = updatedDto.toDomain();
      await _userRepository.saveUser(updated);

      if (mounted) {
        setState(() {
          _currentUser = updated;
          _isLoading = false;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    } catch (e) {
      if (mounted) setState(() {
        _isLoading = false;
        _errorMessage = 'Update failed: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  void _logout() async {
    await _userRepository.clear();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dniCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Only editable attributes are exposed in the form
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _lastNameCtrl,
                    decoration: const InputDecoration(labelText: 'Last name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _dniCtrl,
                    decoration: const InputDecoration(labelText: 'DNI'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPalette.primaryColor,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Update profile'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: const Text('Payment Method'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentMethodsPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: const Text('Terms & Conditions'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Logout'),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
    );
  }
}
