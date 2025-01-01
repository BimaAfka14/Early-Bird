import 'package:flutter/material.dart';
import 'package:quranconnect/models/favorite_ayah.dart';
import 'package:quranconnect/services/DBhelper.dart';

class FavoriteProvider extends ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();
  List<Ayah> _favoriteAyahs = [];

  List<Ayah> get favoriteAyahs => _favoriteAyahs;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favoriteAyahs = await _dbHelper.getFavorites();
    notifyListeners();
  }

  // Future<void> toggleAyahFavorite(Ayah ayah) async {
  //   final isFavorite = _favoriteAyahs.any(
  //     (fav) => fav.number == ayah.number && fav.numberInSurah == ayah.numberInSurah,
  //   );

  //   if (isFavorite) {
  //     await _dbHelper.removeFavorite(ayah.number);
  //     _favoriteAyahs.removeWhere(
  //         (fav) => fav.number == ayah.number && fav.numberInSurah == ayah.numberInSurah);
  //   } else {
  //     await _dbHelper.addFavorite(ayah);
  //     _favoriteAyahs.add(ayah);
  //   }

  //   notifyListeners();
  // }
}
