import 'package:sqflite/sqflite.dart';
import 'api_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('countries.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$filePath';

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE countries (
      alpha3Code TEXT PRIMARY KEY,
      name TEXT,
      flagUrl TEXT
    )
    ''');
  }

  // Zapisywanie listy do bazy
  Future<void> saveCountries(List<Country> countries) async {
    final db = await instance.database;
    Batch batch = db.batch();
    await db.execute('DELETE FROM countries'); // Czyścimy stare dane

    for (var c in countries) {
      batch.insert('countries', {
        'alpha3Code': c.alpha3Code,
        'name': c.name,
        'flagUrl': c.flagUrl,
      });
    }
    await batch.commit(noResult: true);
  }

  // Odczytywanie z bazy (Tryb Offline)
  Future<List<Country>> getCountries() async {
    final db = await instance.database;
    final maps = await db.query('countries');

    return maps.map((map) => Country(
      name: map['name'] as String,
      flagUrl: map['flagUrl'] as String,
      alpha3Code: map['alpha3Code'] as String,
    )).toList();
  }
}