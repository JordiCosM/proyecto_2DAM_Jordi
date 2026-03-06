import 'package:flutter/material.dart';
import 'package:reservapp_mobile/screens/auth/auth_check_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthCheckScreen(),
    );
  }
}
