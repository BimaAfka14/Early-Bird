import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../services/database_helper.dart'; // Tambahkan dependensi database_helper

class SurahArabic extends StatefulWidget {
  final int surahNumber;

  const SurahArabic({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _SurahArabicState createState() => _SurahArabicState();
}

class _SurahArabicState extends State<SurahArabic> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> ayahs = [];
  bool isLoading = true;
  Map<String, bool> bookmarkedAyahs = {}; // Status bookmark
  Map<String, bool> favoriteAyahs = {}; // Status favorit

  @override
  void initState() {
    super.initState();
    fetchArabicData();
    loadBookmark(); // Memuat bookmark terakhir
    loadFavorites(); // Memuat daftar favorit
  }

  Future<void> fetchArabicData() async {
    try {
      final data = await _apiClient.fetchSurahDetails(
          widget.surahNumber, 'quran-simple');
      setState(() {
        ayahs = data['ayahs'];
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
        title: Text('Surah ${widget.surahNumber} - Arabic'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: ayahs.length +
                    (widget.surahNumber != 1 && widget.surahNumber != 9
                        ? 1
                        : 0),
                itemBuilder: (context, index) {
                  if (index == 0 &&
                      widget.surahNumber != 1 &&
                      widget.surahNumber != 9) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final ayah = ayahs[
                      widget.surahNumber != 1 && widget.surahNumber != 9
                          ? index - 1
                          : index];
                  String ayahText = ayah['text'] ?? '';

                  if (widget.surahNumber != 1 &&
                      widget.surahNumber != 9 &&
                      ayahText.startsWith(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
                    ayahText = ayahText
                        .replaceFirst(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', '')
                        .trim();
                  }

                  final ayahNumber =
                      widget.surahNumber != 1 && widget.surahNumber != 9
                          ? index
                          : index + 1;

                  final key = '${widget.surahNumber}:$ayahNumber';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ayah $ayahNumber',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    favoriteAyahs[key] == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: favoriteAyahs[key] == true
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                  onPressed: () => toggleFavorite(
                                      widget.surahNumber, ayahNumber),
                                ),
                                IconButton(
                                  icon: Icon(
                                    bookmarkedAyahs[key] == true
                                        ? Icons.history
                                        : Icons.history_outlined,
                                    color: bookmarkedAyahs[key] == true
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  onPressed: () => toggleBookmark(
                                      widget.surahNumber, ayahNumber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                ayahText,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
