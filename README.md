# Aplikacja REST Countries

Projekt zaliczeniowy z przedmiotu programowanie aplikacji mobilnych. Aplikacja pobiera dane o krajach z API i zapisuje je w lokalnej bazie danych na potrzeby obsługi trybu offline.

## Instrukcja uruchomienia

### 1. Ważna uwaga dotycząca bazy danych
Aplikacja korzysta z biblioteki sqflite (SQLite), która wymaga środowiska mobilnego. Aplikację należy uruchamiać wyłącznie na emulatorze systemu Android lub fizycznym urządzeniu z Androidem/iOS. Próba uruchomienia na systemie Windows lub w przeglądarce Chrome zakończy się błędem inicjalizacji bazy danych (databaseFactory not initialized).

### 2. Pobranie pakietów
Przed pierwszym uruchomieniem należy pobrać zależności:
```bash
flutter pub get
```

### 3. Uruchomienie projektu
Po uruchomieniu emulatora należy wpisać w konsoli:
```bash
flutter run
```

## Opis działania i funkcjonalności

*   **Pobieranie danych (Online):** Aplikacja łączy się z API (api.restcountries.com/countries/v5) przy użyciu klucza autoryzacyjnego przesłanego w nagłówku.
*   **Baza danych (Offline):** Pobrane kraje są zapisywane w bazie SQLite. W przypadku braku połączenia z internetem aplikacja wyświetla pomarańczowy komunikat informacyjny i ładuje dane z pamięci lokalnej.
*   **Podgląd szczegółów:** Kliknięcie na dany kraj na liście otwiera dedykowany ekran ze szczegółowymi informacjami (stolica, region, populacja) oraz flagą państwa.

## Struktura plików projektu

*   `lib/main.dart` - główny plik startowy.
*   `lib/screens/api_data.dart` - modele danych oraz obsługa zapytań HTTP do API.
*   `lib/screens/database_helper.dart` - implementacja bazy danych SQLite (klasa DatabaseHelper).
*   `lib/screens/home_screen.dart` - ekran główny z listą państw i obsługą trybu offline.
*   `lib/screens/details_screen.dart` - ekran szczegółowy wybranego państwa.