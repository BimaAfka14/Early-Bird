import 'package:flutter/material.dart';
import '../services/api_client.dart'; // Pastikan path file api_client.dart sudah benar

class SurahTerjemah extends StatefulWidget {
  final int surahNumber;

  const SurahTerjemah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _SurahTerjemahState createState() => _SurahTerjemahState();
}

class _SurahTerjemahState extends State<SurahTerjemah> {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, String>> ayahs = [];
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
        ayahs = data;
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
        title: Text('Surah ${widget.surahNumber} - Dengan Terjemahan'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: widget.surahNumber != 1 && ayahs.isNotEmpty
                  ? ayahs.length + 1 // Tambahkan 1 untuk Basmalah
                  : ayahs.length,
              itemBuilder: (context, index) {
                // Tampilkan Basmalah jika bukan Surah 1
                if (index == 0 &&
                    widget.surahNumber != 1 &&
                    ayahs.isNotEmpty &&
                    ayahs.first['arabic']!
                        .contains('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ')) {
                  return ListTile(
                    title: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Hitung indeks untuk daftar ayat
                final int ayahIndex = widget.surahNumber == 1
                    ? index // Al-Fatihah, gunakan indeks asli
                    : index - 1; // Kurangi 1 jika Basmalah ditampilkan

                // Pastikan tidak mencoba mengakses indeks yang tidak valid
                if (ayahIndex < 0 || ayahIndex >= ayahs.length) {
                  return const SizedBox.shrink(); // Kembalikan widget kosong
                }

                final ayah = ayahs[ayahIndex];
                return ListTile(
                  title: Text(
                    ayah['arabic'] ?? '',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    ayah['translation'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
