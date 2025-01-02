//lib\screens\Surah_Terjemah.dart
import 'package:flutter/material.dart';
import '../services/api_client.dart';

class SurahTerjemah extends StatefulWidget {
  final int surahNumber;

  const SurahTerjemah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _SurahTerjemahState createState() => _SurahTerjemahState();
}

class _SurahTerjemahState extends State<SurahTerjemah> {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, dynamic>> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArabicAndTranslation();
  }

  Future<void> fetchArabicAndTranslation() async {
    try {
      final data =
          await _apiClient.fetchArabicAndTranslation(widget.surahNumber);

      setState(() {
        ayahs = data
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item))
            .toList();
  
        // Hapus Bismillah pada teks ayat pertama kecuali Surah 1 dan 9
        if (ayahs.isNotEmpty &&
            widget.surahNumber != 1 &&
            widget.surahNumber != 9) {
          final firstAyah = ayahs.first;

          // Cetak teks ayat untuk debugging
          debugPrint('Teks sebelum penghapusan: ${firstAyah['arabic']}');

          // Deteksi dan hapus Bismillah menggunakan RegEx
          final bismillahPattern =
              RegExp(r'^بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ');
          String ayahText = firstAyah['arabic'] ?? '';

          if (bismillahPattern.hasMatch(ayahText)) {
            firstAyah['arabic'] =
                ayahText.replaceFirst(bismillahPattern, '').trim();
          }

          // Cetak teks setelah penghapusan untuk debugging
          debugPrint('Teks setelah penghapusan: ${firstAyah['arabic']}');
        }

        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah ${widget.surahNumber} - Dengan Terjemahan',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];

                final numberInSurah = ayah['numberInSurah'] ?? index + 1;
                String text = ayah['arabic'] ?? '';
                final translation = ayah['translation'] ?? '';

                // Tampilkan Basmalah di atas Surah, kecuali Surah At-Taubah (9)
                bool showBasmalah = index == 0 &&
                    widget.surahNumber != 1 &&
                    widget.surahNumber != 9;

                String basmalah = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showBasmalah)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            basmalah,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: 'ScheherazadeNew',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      title: Row(
                        children: [
                          Text(
                            'Ayat $numberInSurah',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              text,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'ScheherazadeNew',
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          translation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
