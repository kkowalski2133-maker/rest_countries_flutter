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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Szczegóły', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<CountryDetails>(
        future: _countryDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}\n(Brak połączenia z API w trybie offline dla szczegółów)', textAlign: TextAlign.center));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Brak danych.'));
          }

          final details = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sekcja Flagi
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      details.flagUrl,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sekcja Informacji
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(details.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                        const Divider(height: 30, thickness: 1),
                        _buildInfoRow(Icons.location_city, 'Stolica', details.capital),
                        const SizedBox(height: 15),
                        _buildInfoRow(Icons.map, 'Region', details.region),
                        const SizedBox(height: 15),
                        _buildInfoRow(Icons.people, 'Populacja', _formatPopulation(details.population)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Pomocniczy widget do ładnego wyświetlania wierszy
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey, size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  // Formatyzowanie liczby populacji (np. 1 000 000 zamiast 1000000)
  String _formatPopulation(int population) {
    return population.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');
  }
}