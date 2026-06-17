import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RestCountriesApp());
}

class RestCountriesApp extends StatelessWidget {
  const RestCountriesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST Countries',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}