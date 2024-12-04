import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Map<String, String>> _favoriteAyahs = [];
  final List<Map<String, dynamic>> _favoriteSurahs = [];
  final List<int> _favoriteJuz = [];

  List<Map<String, String>> get favoriteAyahs => List.unmodifiable(_favoriteAyahs);
  List<Map<String, dynamic>> get favoriteSurahs => List.unmodifiable(_favoriteSurahs);
  List<int> get favoriteJuz => List.unmodifiable(_favoriteJuz);

  FavoriteProvider() {
    _loadFavorites();
  }

  // Toggle Ayah Favorite
  void toggleAyahFavorite(Map<String, String> ayah) {
    final exists = _favoriteAyahs.any((fav) => fav['arabic'] == ayah['arabic']);
    if (exists) {
      _favoriteAyahs.removeWhere((fav) => fav['arabic'] == ayah['arabic']);
    } else {
      _favoriteAyahs.add(ayah);
    }
    notifyListeners();
    _saveFavorites();
  }

  // Toggle Surah Favorite
  void toggleSurahFavorite(Map<String, dynamic> surah) {
    final exists =
        _favoriteSurahs.any((fav) => fav['number'] == surah['number']);
    if (exists) {
      _favoriteSurahs.removeWhere((fav) => fav['number'] == surah['number']);
    } else {
      _favoriteSurahs.add(surah);
    }
    notifyListeners();
    _saveFavorites();
  }

  // Toggle Juz Favorite
  void toggleJuzFavorite(int juz) {
    if (_favoriteJuz.contains(juz)) {
      _favoriteJuz.remove(juz);
    } else {
      _favoriteJuz.add(juz);
    }
    notifyListeners();
    _saveFavorites();
  }

  // Load Favorites from SharedPreferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Load Ayahs
    final ayahData = prefs.getString('favoriteAyahs');
    if (ayahData != null) {
      _favoriteAyahs
        ..clear()
        ..addAll(
          List<Map<String, String>>.from(jsonDecode(ayahData)),
        );
    }

    // Load Surahs
    final surahData = prefs.getString('favoriteSurahs');
    if (surahData != null) {
      _favoriteSurahs
        ..clear()
        ..addAll(
          List<Map<String, dynamic>>.from(jsonDecode(surahData)),
        );
    }

    // Load Juz
    final juzData = prefs.getString('favoriteJuz');
    if (juzData != null) {
      _favoriteJuz
        ..clear()
        ..addAll(
          List<int>.from(jsonDecode(juzData)),
        );
    }

    notifyListeners();
  }

  // Save Favorites to SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Save Ayahs
    await prefs.setString('favoriteAyahs', jsonEncode(_favoriteAyahs));

    // Save Surahs
    await prefs.setString('favoriteSurahs', jsonEncode(_favoriteSurahs));

    // Save Juz
    await prefs.setString('favoriteJuz', jsonEncode(_favoriteJuz));
  }
}
