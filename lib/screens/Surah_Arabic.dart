import 'package:flutter/material.dart';
import '../services/api_client.dart';

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

  @override
  void initState() {
    super.initState();
    fetchArabicData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Surah ${widget.surahNumber} - Arabic Saja'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length +
                  (widget.surahNumber != 1
                      ? 1
                      : 0), // Menambahkan 1 hanya jika bukan surah 1
              itemBuilder: (context, index) {
                if (index == 0 && widget.surahNumber != 1) {
                  // Menampilkan Basmalah hanya jika Surah bukan 1
                  return ListTile(
                    title: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', // Menampilkan Basmalah
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Mengakses ayat yang benar (untuk surah selain 1, index - 1)
                final ayah = ayahs[widget.surahNumber != 1 ? index - 1 : index];

                // Menampilkan teks ayat, hapus Basmalah untuk ayat pertama selain Surah 1
                String ayahText = ayah['text'] ?? '';
                if (widget.surahNumber != 1 &&
                    ayahText
                        .startsWith('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
                  ayahText = ayahText
                      .replaceFirst(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', '')
                      .trim();
                }

                return ListTile(
                  title: Text(
                    ayahText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
