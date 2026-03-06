import 'package:flutter/material.dart';
import 'package:reservapp_mobile/components/header_component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _search(String query) {
    print("Buscar: $query");
    // Aquí llamar a la API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(onSearch: _search),
      body: const Center(
        child: Text("Home"),
      ),
    );
  }
}