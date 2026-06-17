import 'package:flutter/material.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Krajów'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Tymczasowa nawigacja do testów
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailsScreen(countryName: 'Polska'),
              ),
            );
          },
          child: const Text('Przejdź do szczegółów (Test)'),
        ),
      ),
    );
  }
}