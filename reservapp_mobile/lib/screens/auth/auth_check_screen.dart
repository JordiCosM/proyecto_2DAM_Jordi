import 'package:flutter/material.dart';
import 'package:reservapp_mobile/screens/auth/login_screen.dart';
import 'package:reservapp_mobile/screens/home_screen.dart';
import 'package:reservapp_mobile/services/auth_service.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    final token = await _authService.getToken();
    if (!mounted) return;

    if (token == null || token.isEmpty) {
      _goToLogin();
      return;
    }

    final isValid = await _authService.verifyToken();
    if (!mounted) return;

    if (isValid) {
      _goToHome();
    } else {
      await _authService.logout();
      if (mounted) _goToLogin();
    }
  }

  void _goToHome() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );

  void _goToLogin() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded, size: 80, color: color),
            const SizedBox(height: 16),
            Text(
              'Reservapp',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
