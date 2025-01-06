// lib/screens/Juz_Terjemah.dart
import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/database_helper.dart'; // Import helper SQLite

class JuzTerjemah extends StatefulWidget {
  final int juzNumber;

  const JuzTerjemah({Key? key, required this.juzNumber}) : super(key: key);

  @override
  _JuzTerjemahState createState() => _JuzTerjemahState();
}

class _JuzTerjemahState extends State<JuzTerjemah> {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, String>> ayahs = [];
  bool isLoading = true;
  Map<String, bool> bookmarkedAyahs = {}; // Menyimpan status bookmark
  Map<String, bool> favoriteAyahs = {}; // Menyimpan status favorit

  @override
  void initState() {
    super.initState();
    fetchJuzDataWithTranslation();
    loadBookmark(); // Memuat bookmark terakhir
    loadFavorites(); // Memuat favorit
  }

  Future<void> fetchJuzDataWithTranslation() async {
    try {
      final arabicData = await ApiClient.getJuz(widget.juzNumber);
      final arabicAyahs = arabicData['data']['ayahs'];

      final translationData =
          await _apiClient.getJuzTranslation(widget.juzNumber);
      final translationAyahs = translationData['data']['ayahs'];

      List<Map<String, String>> combinedAyahs = [];
      String? bismillahSeparator;

      for (int i = 0; i < arabicAyahs.length; i++) {
        String arabicText = arabicAyahs[i]['text'] ?? '';
        String translationText = translationAyahs[i]['text'] ?? '';
        int surahNumber = arabicAyahs[i]['surah']['number'];
        String ayahNumber = arabicAyahs[i]['numberInSurah'].toString();

        if (i == 0 || arabicAyahs[i]['numberInSurah'] == 1) {
          if (surahNumber != 1 && surahNumber != 9 && surahNumber != 1) {
            final bismillahPattern =
                RegExp(r'^بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\s*');
            if (bismillahPattern.hasMatch(arabicText)) {
              bismillahSeparator = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
              arabicText = arabicText.replaceFirst(bismillahPattern, '').trim();
            }
          }
        }

        combinedAyahs.add({
          'arabic': arabicText,
          'translation': translationText,
          'number': ayahNumber,
          'surah': surahNumber.toString(),
          'separator': bismillahSeparator ?? '',
        });

        bismillahSeparator = null;
      }

      if (mounted) {
        setState(() {
          ayahs = combinedAyahs;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
        title: Text('Juz ${widget.juzNumber} - Dengan Terjemahan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                final surah = int.parse(ayah['surah']!);
                final ayahNumber = int.parse(ayah['number']!);
                final key = '$surah:$ayahNumber';

                // Cek apakah ayat ini adalah awal surah baru
                bool isSurahStart = ayahNumber == 1;

                return Column(
                  children: [
                    // Tambahkan Bismillah jika ini adalah awal surah baru
                    if (isSurahStart && surah != 9) // Kecuali Surah At-Taubah
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Amiri',
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Informasi Ayat di Sebelah Kiri
                          Expanded(
                            child: Text(
                              'Ayat ${ayah['number']}',
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
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    favoriteAyahs[key] == true
                                        ? Icons.favorite // Ikon favorit aktif
                                        : Icons
                                            .favorite_border, // Ikon non-aktif
                                    color: favoriteAyahs[key] == true
                                        ? Colors.red
                                        : Colors.grey,
                                    key: ValueKey<bool>(
                                        favoriteAyahs[key] == true),
                                  ),
                                ),
                                onPressed: () =>
                                    toggleFavorite(surah, ayahNumber),
                              ),
                              IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    bookmarkedAyahs[key] == true
                                        ? Icons.history // Ikon riwayat aktif
                                        : Icons
                                            .history_outlined, // Ikon non-aktif
                                    color: bookmarkedAyahs[key] == true
                                        ? Colors.green
                                        : Colors.grey,
                                    key: ValueKey<bool>(
                                        bookmarkedAyahs[key] == true),
                                  ),
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
                        ayah['arabic'] ?? '',
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                        ayah['translation'] ?? '',
                        style: const TextStyle(fontSize: 16),
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