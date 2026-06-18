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
      name: json['names']?['common'] ?? 'Brak nazwy',
      flagUrl: json['flag']?['url_png'] ?? json['flag']?['url_svg'] ?? '',
      alpha3Code: json['codes']?['alpha_3'] ?? '',
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
      name: json['names']?['common'] ?? 'Brak nazwy',
      flagUrl: json['flag']?['url_png'] ?? json['flag']?['url_svg'] ?? '',
      capital: (json['capitals'] is List && json['capitals'].isNotEmpty)
          ? json['capitals'][0]['name'] ?? 'Brak stolicy'
          : 'Brak stolicy',
      region: json['region'] ?? 'Brak regionu',
      population: json['population'] ?? 0,
    );
  }
}

// --- LOGIKA API ---

class ApiService {
  final String baseUrl = 'https://api.restcountries.com/countries/v5';

  // Twój wygenerowany klucz API
  final Map<String, String> headers = {
    'Authorization': 'Bearer rc_live_77f0faf11718499ab6dc88682f93e7c2'
  };

  Future<List<Country>> fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?limit=100&response_fields=names,flag,codes'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        // Pancerne wyciąganie listy (zabezpieczenie przed różnymi strukturami API)
        List<dynamic> dataList = [];
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          if (decodedData['data'] is List) {
            dataList = decodedData['data'];
          } else if (decodedData['data'] is Map && decodedData['data']['objects'] is List) {
            dataList = decodedData['data']['objects'];
          } else if (decodedData['objects'] is List) {
            dataList = decodedData['objects'];
          }
        }

        return dataList.map((json) => Country.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Błąd HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd połączenia z nowym API.');
    }
  }

  Future<CountryDetails> fetchCountryDetails(String alpha3Code) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/codes.alpha_3/$alpha3Code'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        List<dynamic> dataList = [];
        if (decodedData is List) {
          dataList = decodedData;
        } else if (decodedData is Map) {
          if (decodedData['data'] is List) {
            dataList = decodedData['data'];
          } else if (decodedData['data'] is Map && decodedData['data']['objects'] is List) {
            dataList = decodedData['data']['objects'];
          } else if (decodedData['objects'] is List) {
            dataList = decodedData['objects'];
          }
        }

        if (dataList.isEmpty) throw Exception('Brak kraju');
        return CountryDetails.fromJson(dataList.first as Map<String, dynamic>);
      } else {
        throw Exception('Błąd HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Błąd pobierania szczegółów.');
    }
  }
}