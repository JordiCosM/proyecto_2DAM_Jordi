import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reservapp_mobile/services/auth_service.dart';
import 'package:reservapp_mobile/screens/auth/login_screen.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onSearch;

  const AppHeader({super.key, this.onSearch});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.onSearch != null && value.isNotEmpty) {
        widget.onSearch!(value);
      }
    });
  }

  void _logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 16),
          const Text(
            "Reservapp",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),

          // Buscador
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: "Buscar empresas o servicios",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),

      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, size: 32),
          onSelected: (value) {
            if (value == 'logout') _logout();
            if (value == 'profile') {
              // TODO: navegar a editar perfil
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'profile',
              child: Text("Editar perfil"),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Text("Cerrar sesión"),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
