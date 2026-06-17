import 'package:flutter/material.dart';
import 'api_data.dart';

class DetailsScreen extends StatefulWidget {
  final String alpha3Code;

  const DetailsScreen({super.key, required this.alpha3Code});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ApiService _apiService = ApiService();
  late Future<CountryDetails> _countryDetailsFuture;

  @override
  void initState() {
    super.initState();
    _countryDetailsFuture = _apiService.fetchCountryDetails(widget.alpha3Code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szczegóły kraju')),
      body: FutureBuilder<CountryDetails>(
        future: _countryDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Brak danych.'));
          }

          final details = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.network(details.flagUrl, height: 150)),
                const SizedBox(height: 24),
                Text('Nazwa: ${details.name}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Stolica: ${details.capital}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Region: ${details.region}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text('Populacja: ${details.population}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}