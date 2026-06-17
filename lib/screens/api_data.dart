import 'dart:convert';
import 'package:http/http.dart' as http;

// --- MODELE DANYCH ---

class Country {
  final String name;
  final String flagUrl;
  final String alpha3Code;

  Country({required this.name, required this.flagUrl, required this.alpha3Code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']['common'] ?? 'Brak nazwy',
      flagUrl: json['flags']['png'] ?? '',
      alpha3Code: json['cca3'] ?? '',
    );
  }
}

class CountryDetails {
  final String name;
  final String flagUrl;
  final String capital;
  final String region;
  final int population;

  CountryDetails({
    required this.name,
    required this.flagUrl,
    required this.capital,
    required this.region,
    required this.population,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) {
    return CountryDetails(
      name: json['name']['common'] ?? 'Brak nazwy',
      flagUrl: json['flags']['png'] ?? '',
      capital: (json['capital'] as List<dynamic>?)?.first ?? 'Brak stolicy',
      region: json['region'] ?? 'Brak regionu',
      population: json['population'] ?? 0,
    );
  }
}

// --- LOGIKA API ---

class ApiService {
  final String baseUrl = 'https://restcountries.com/v3.1';

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all?fields=name,flags,cca3'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Błąd: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd połączenia z API.');
    }
  }

  Future<CountryDetails> fetchCountryDetails(String alpha3Code) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/alpha/$alpha3Code'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return CountryDetails.fromJson(data.first);
      } else {
        throw Exception('Błąd: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd pobierania szczegółów.');
    }
  }
}