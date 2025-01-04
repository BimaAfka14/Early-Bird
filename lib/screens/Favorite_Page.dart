import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/database_helper.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      // Ambil data dari database favorit
      final data = await DatabaseHelper().getFavorites();
      List<Map<String, dynamic>> detailedFavorites = [];

      for (var favorite in data) {
        final surahNumber = favorite['surah'];
        final ayahNumber = favorite['ayah'];

        // Ambil detail dari API
        final arabicUrl =
            'https://api.alquran.cloud/v1/surah/$surahNumber/ar.alafasy';
        final translationUrl =
            'https://api.alquran.cloud/v1/surah/$surahNumber/id.indonesian';

        final arabicResponse = await http.get(Uri.parse(arabicUrl));
        final translationResponse = await http.get(Uri.parse(translationUrl));

        if (arabicResponse.statusCode == 200 &&
            translationResponse.statusCode == 200) {
          final arabicData = json.decode(arabicResponse.body)['data'];
          final translationData = json.decode(translationResponse.body)['data'];

          // Cari ayat yang sesuai
          final arabicAyah = arabicData['ayahs']
              .firstWhere((ayah) => ayah['numberInSurah'] == ayahNumber);
          final translationAyah = translationData['ayahs']
              .firstWhere((ayah) => ayah['numberInSurah'] == ayahNumber);

          detailedFavorites.add({
            'surahName': arabicData['englishName'], // Nama surah
            'arabic': arabicAyah['text'], // Teks Arab
            'translation': translationAyah['text'], // Terjemahan
            'ayahNumber': ayahNumber,
            'surah': surahNumber, // Simpan juga nomor surah
          });
        }
      }

      setState(() {
        favorites = detailedFavorites;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Ayahs')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? Center(child: Text('No favorites yet.'))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return ListTile(
                      title: Text(
                        '${favorite['surahName']} (Ayah ${favorite['ayahNumber']})',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            favorite['arabic'],
                            style: TextStyle(fontSize: 23, fontFamily: 'Amiri'),
                          ),
                          SizedBox(height: 5),
                          Text(
                            favorite['translation'],
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final surahNumber = favorite['surah'];
                          final ayahNumber = favorite['ayahNumber'];

                          // Pastikan surahNumber valid
                          if (surahNumber != null && ayahNumber != null) {
                            await DatabaseHelper().removeFavorite(
                              surahNumber, // Gunakan surahNumber langsung
                              ayahNumber, // Gunakan ayahNumber langsung
                            );
                            loadFavorites(); // Reload favorites setelah dihapus
                          }
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
