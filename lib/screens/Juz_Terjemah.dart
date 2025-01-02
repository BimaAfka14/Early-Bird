//lib\screens\Juz_Terjemah.dart
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
      List<Map<String, String>> combinedAyahs = [];
      String? bismillahSeparator;

      for (int i = 0; i < arabicAyahs.length; i++) {
        String arabicText = arabicAyahs[i]['text'] ?? '';
        String translationText = translationAyahs[i]['text'] ?? '';
        int surahNumber = arabicAyahs[i]['surah']['number'];
        String ayahNumber = arabicAyahs[i]['numberInSurah'].toString();

        // Deteksi basmalah dan pindahkan ke separator jika ayat pertama dalam surah
        if (i == 0 || arabicAyahs[i]['numberInSurah'] == 1) {
          if (surahNumber != 1 && surahNumber != 9) {
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
          'separator': bismillahSeparator ?? '', // Tambahkan separator jika ada
        });

        // Hapus separator setelah digunakan
        bismillahSeparator = null;
      }

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
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];

                // Tampilkan basmalah sebagai tanda perpindahan surah
                if (ayah['separator']?.isNotEmpty ?? false) {
                  return Column(
                    children: [
                      Text(
                        ayah['separator']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                          height: 10), // Spasi antara basmalah dan pembatas
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ayat ${ayah['number']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.grey), // Pembatas atas
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
                      const Divider(
                          height: 20,
                          thickness: 1,
                          color: Colors.grey), // Pembatas bawah
                    ],
                  );
                }

                // Tampilkan ayat tanpa separator
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ayat ${ayah['number']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Divider(
                        height: 20,
                        thickness: 1,
                        color: Colors.grey), // Pembatas atas
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
                    const Divider(
                        height: 20,
                        thickness: 1,
                        color: Colors.grey), // Pembatas bawah
                  ],
                );
              },
            ),
    );
  }
}
