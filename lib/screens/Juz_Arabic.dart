//lib\screens\Juz_Arabic.dart
import 'package:flutter/material.dart';
import '../services/api_client.dart';

class JuzArabic extends StatefulWidget {
  final int juzNumber;

  const JuzArabic({Key? key, required this.juzNumber}) : super(key: key);

  @override
  _JuzArabicState createState() => _JuzArabicState();
}

class _JuzArabicState extends State<JuzArabic> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJuzData();
  }

  Future<void> fetchJuzData() async {
    try {
      final data = await ApiClient.getJuz(widget.juzNumber);
      final rawAyahs = data['data']['ayahs'];
      List<dynamic> processedAyahs = [];
      String? bismillahSeparator;

      for (var ayah in rawAyahs) {
        String arabicText = ayah['text'] ?? '';
        int surahNumber = ayah['surah']['number'];
        int ayahNumber = ayah['numberInSurah'];

        // Pisahkan Basmalah jika ayat pertama
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

        // Tambahkan Basmalah sebagai penanda perpindahan surah
        if (bismillahSeparator != null) {
          processedAyahs.add({
            'text': bismillahSeparator,
            'isBismillah': true,
          });
          bismillahSeparator = null;
        }

        // Tambahkan ayat yang telah diproses
        processedAyahs.add({
          'text': arabicText,
          'numberInSurah': ayahNumber,
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

                // Jika Basmalah, tampilkan sebagai penanda perpindahan surah
                if (ayah['isBismillah'] == true) {
                  return Column(
                    children: [
                      Text(
                        ayah['text'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }

                // Jika ayat biasa, tampilkan seperti biasa
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ayat ${ayah['numberInSurah']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
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
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
    );
  }
}
