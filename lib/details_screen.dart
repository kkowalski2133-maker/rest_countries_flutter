import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String countryName;

  const DetailsScreen({super.key, required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(countryName),
      ),
      body: Center(
        child: Text('Tutaj będą szczegóły kraju: $countryName'),
      ),
    );
  }
}