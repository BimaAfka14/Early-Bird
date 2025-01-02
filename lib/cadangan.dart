import 'package:flutter/material.dart';
import '../services/api_client.dart';

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

  @override
  void initState() {
    super.initState();
    fetchJuzDataWithTranslation();
  }

  Future<void> fetchJuzDataWithTranslation() async {
    try {
      // Memanggil endpoint untuk mendapatkan teks Arab dari Juz tertentu
      final arabicData = await ApiClient.getJuz(widget.juzNumber);
      final arabicAyahs = arabicData['data']['ayahs'];

      // Memanggil endpoint untuk mendapatkan terjemahan Juz tertentu
      final translationData =
          await _apiClient.getJuzTranslation(widget.juzNumber);
      final translationAyahs = translationData['data']['ayahs'];

      // Menggabungkan teks Arab dan terjemahan untuk setiap ayat
      List<Map<String, String>> combinedAyahs = List<Map<String, String>>.from(
        arabicAyahs.asMap().map((index, ayah) {
          final translatedAyah = translationAyahs[index];
          String arabicText = (ayah['text'] ?? '').toString();
          String translationText =
              (translatedAyah['text'] ?? 'Terjemahan tidak tersedia')
                  .toString();

          // Pisahkan Basmalah jika ayat pertama dan bukan Surah 1
          if (index == 0 && ayah['surah']['number'] != 1) {
            arabicText = arabicText
                .replaceFirst('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', '')
                .trim();
          }

          return MapEntry(index, {
            'arabic': arabicText,
            'translation': translationText,
          });
        }).values,
      );

      setState(() {
        ayahs = combinedAyahs;
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
        title: Text(
            'Juz ${widget.juzNumber} - Dengan Terjemahan'), // Menampilkan judul
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length + 1, // Tambahkan 1 untuk Basmalah
              itemBuilder: (context, index) {
                // Menampilkan Basmalah jika bukan Surah 1
                if (index == 0 &&
                    ayahs.isNotEmpty &&
                    ayahs.first['arabic']!
                        .contains('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
                  return ListTile(
                    title: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', // Basmalah
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Pastikan indeks dalam range saat mengakses ayahs
                final ayahIndex = index - 1; // Hitung indeks sebenarnya
                if (ayahIndex < 0 || ayahIndex >= ayahs.length) {
                  return const SizedBox
                      .shrink(); // Hindari error dengan widget kosong
                }

                // Tampilkan ayat mulai dari indeks yang benar
                final ayah = ayahs[index - 1];

                return ListTile(
                  title: Text(
                    ayah['arabic'] ?? '', // Teks Arab
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    ayah['translation'] ?? '', // Terjemahan
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
