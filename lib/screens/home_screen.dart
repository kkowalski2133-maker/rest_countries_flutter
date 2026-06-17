import 'package:flutter/material.dart';
import 'api_data.dart';
import 'details_screen.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Country>> _countriesFuture;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _countriesFuture = _loadData();
  }

  // Sprytna funkcja ładująca dane (API lub Offline)
  Future<List<Country>> _loadData() async {
    try {
      final data = await _apiService.fetchCountries();
      await DatabaseHelper.instance.saveCountries(data); // Zapisz do bazy na przyszłość
      setState(() => _isOffline = false);
      return data;
    } catch (e) {
      // Jeśli API padnie, ładujemy z bazy
      final offlineData = await DatabaseHelper.instance.getCountries();
      if (offlineData.isNotEmpty) {
        setState(() => _isOffline = true);
        return offlineData;
      }
      throw Exception('Brak internetu i brak danych zapisanych offline.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Kraje Świata', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Błąd: ${snapshot.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontSize: 16)),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Brak danych do wyświetlenia.'));
          }

          final countries = snapshot.data!;
          return Column(
            children: [
              if (_isOffline)
                Container(
                  width: double.infinity,
                  color: Colors.orangeAccent,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Tryb Offline: Wyświetlam zapisane dane',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: countries.length,
                  itemBuilder: (context, index) {
                    final country = countries[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            country.flagUrl,
                            width: 60,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag, size: 40),
                          ),
                        ),
                        title: Text(country.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailsScreen(alpha3Code: country.alpha3Code)),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}