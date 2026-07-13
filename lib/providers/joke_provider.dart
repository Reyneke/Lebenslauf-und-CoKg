import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JokeProvider extends ChangeNotifier {
  static const String _jokeKey = 'daily_joke';
  static const String _dateKey = 'joke_date';

  String? _joke;
  bool _isLoading = false;
  String? _error;

  String? get joke => _joke;
  bool get isLoading => _isLoading;
  String? get error => _error;

  JokeProvider() {
    _loadCachedJoke();
  }

  Future<void> _loadCachedJoke() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedDate = prefs.getString(_dateKey);
    final today = _todayDateString();

    if (cachedDate == today) {
      _joke = prefs.getString(_jokeKey);
      if (_joke != null) {
        notifyListeners();
        return;
      }
    }

    // No valid cached joke → fetch a new one
    await fetchJoke();
  }

  String _todayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> fetchJoke() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try JokeAPI first with "Programming" category
      final response = await http.get(
        Uri.parse('https://v2.jokeapi.dev/joke/Programming?type=single&safe-mode'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['error'] == false) {
          _joke = data['joke'] as String?;
        }
      }

      // Fallback: try icanhazdadjoke
      if (_joke == null) {
        final fallbackResponse = await http.get(
          Uri.parse('https://icanhazdadjoke.com/'),
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'Lebenslauf-und-CoKg (https://github.com/Reyneke/Lebenslauf-und-CoKg)',
          },
        );

        if (fallbackResponse.statusCode == 200) {
          final data = json.decode(fallbackResponse.body) as Map<String, dynamic>;
          _joke = data['joke'] as String?;
        }
      }

      if (_joke != null) {
        // Cache the joke
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_jokeKey, _joke!);
        await prefs.setString(_dateKey, _todayDateString());
      } else {
        _error = 'Konnte keinen Witz laden.';
      }
    } catch (e) {
      _error = 'Fehler beim Laden des Witzes: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}