import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/database_helper.dart'; // Import helper SQLite

class JuzArabic extends StatefulWidget {
  final int juzNumber;

  const JuzArabic({Key? key, required this.juzNumber}) : super(key: key);

  @override
  _JuzArabicState createState() => _JuzArabicState();
}

class _JuzArabicState extends State<JuzArabic> {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, dynamic>> ayahs = [];
  bool isLoading = true;
  Map<String, bool> bookmarkedAyahs = {}; // Menyimpan status bookmark
  Map<String, bool> favoriteAyahs = {}; // Menyimpan status favorit

  @override
  void initState() {
    super.initState();
    fetchJuzData();
    loadBookmark(); // Memuat bookmark terakhir
    loadFavorites(); // Memuat favorit
  }

  Future<void> fetchJuzData() async {
    try {
      final data = await ApiClient.getJuz(widget.juzNumber);
      final rawAyahs = data['data']['ayahs'];
      List<Map<String, dynamic>> processedAyahs = [];
      String? bismillahSeparator;

      for (var ayah in rawAyahs) {
        String arabicText = ayah['text'] ?? '';
        int surahNumber = ayah['surah']['number'];
        int ayahNumber = ayah['numberInSurah'];

        if (ayahNumber == 1) {
          if (surahNumber != 1 && surahNumber != 9) {
            final bismillahPattern =
                RegExp(r'^بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\s*');
            if (bismillahPattern.hasMatch(arabicText)) {
              bismillahSeparator = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
              arabicText = arabicText.replaceFirst(bismillahPattern, '').trim();
            }
          }
        }

        if (bismillahSeparator != null) {
          processedAyahs.add({
            'text': bismillahSeparator,
            'numberInSurah': 0,
            'surah': surahNumber,
            'isBismillah': true,
          });
          bismillahSeparator = null;
        }

        processedAyahs.add({
          'text': arabicText,
          'numberInSurah': ayahNumber,
          'surah': surahNumber,
          'isBismillah': false,
        });
      }

      setState(() {
        ayahs = processedAyahs;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleBookmark(int surah, int ayah) async {
    final key = '$surah:$ayah';
    final isBookmarked = bookmarkedAyahs[key] ?? false;

    if (!isBookmarked) {
      await DatabaseHelper().saveReadingHistory(surah, ayah);
    } else {
      await DatabaseHelper().saveReadingHistory(0, 0);
    }

    await loadBookmark();
  }

  Future<void> toggleFavorite(int surah, int ayah) async {
    final key = '$surah:$ayah';
    final isFavorited = favoriteAyahs[key] ?? false;

    if (!isFavorited) {
      await DatabaseHelper().addFavorite(surah, ayah);
    } else {
      await DatabaseHelper().removeFavorite(surah, ayah);
    }

    await loadFavorites();
  }

  Future<void> loadBookmark() async {
    final bookmark = await DatabaseHelper().getReadingHistory();

    if (bookmark != null) {
      setState(() {
        bookmarkedAyahs.clear();
        final key = '${bookmark['surah']}:${bookmark['ayah']}';
        bookmarkedAyahs[key] = true;
      });
    } else {
      setState(() {
        bookmarkedAyahs.clear();
      });
    }
  }

  Future<void> loadFavorites() async {
    final favorites = await DatabaseHelper().getFavorites();
    setState(() {
      favoriteAyahs.clear();
      for (var fav in favorites) {
        final key = '${fav['surah']}:${fav['ayah']}';
        favoriteAyahs[key] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${widget.juzNumber} - Arabic Saja'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                final surah = ayah['surah'];
                final ayahNumber = ayah['numberInSurah'];
                final key = '$surah:$ayahNumber';

                if (ayah['isBismillah'] == true) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      ayah['text'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                        color: Colors.blue,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Informasi Ayat di Sebelah Kiri
                          Expanded(
                            child: Text(
                              'Ayat $ayahNumber',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          // Ikon Favorit dan Riwayat di Sebelah Kanan
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  favoriteAyahs[key] == true
                                      ? Icons.favorite // Ikon favorit aktif
                                      : Icons.favorite_border, // Ikon non-aktif
                                  color: favoriteAyahs[key] == true
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () =>
                                    toggleFavorite(surah, ayahNumber),
                              ),
                              IconButton(
                                icon: Icon(
                                  bookmarkedAyahs[key] == true
                                      ? Icons.history // Ikon riwayat aktif
                                      : Icons
                                          .history_outlined, // Ikon non-aktif
                                  color: bookmarkedAyahs[key] == true
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                onPressed: () =>
                                    toggleBookmark(surah, ayahNumber),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                    ListTile(
                      title: Text(
                        ayah['text'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(height: 20, thickness: 1, color: Colors.grey),
                  ],
                );
              },
            ),
    );
  }
}