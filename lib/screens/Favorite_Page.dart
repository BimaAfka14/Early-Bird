import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/database_helper.dart';
import 'surah_page.dart';  // Import SurahPage

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
      final data = await DatabaseHelper().getFavorites();
      List<Map<String, dynamic>> detailedFavorites = [];

      for (var favorite in data) {
        final surahNumber = favorite['surah'];
        final ayahNumber = favorite['ayah'];

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

          final arabicAyah = arabicData['ayahs']
              .firstWhere((ayah) => ayah['numberInSurah'] == ayahNumber);
          final translationAyah = translationData['ayahs']
              .firstWhere((ayah) => ayah['numberInSurah'] == ayahNumber);

          detailedFavorites.add({
            'surahName': arabicData['englishName'],
            'arabic': arabicAyah['text'],
            'translation': translationAyah['text'],
            'ayahNumber': ayahNumber,
            'surah': surahNumber,
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
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
              ? const Center(child: Text('No favorites yet.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final favorite = favorites[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigasi ke SurahPage dengan mengirimkan surahNumber
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahPage(
                              surahNumber: favorite['surah'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${favorite['surahName']} (Ayah ${favorite['ayahNumber']})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                favorite['arabic'],
                                style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: 'Amiri',
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                favorite['translation'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    final surahNumber = favorite['surah'];
                                    final ayahNumber = favorite['ayahNumber'];

                                    if (surahNumber != null && ayahNumber != null) {
                                      await DatabaseHelper().removeFavorite(
                                        surahNumber,
                                        ayahNumber,
                                      );

                                      // Perbarui tampilan langsung setelah penghapusan
                                      loadFavorites();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
