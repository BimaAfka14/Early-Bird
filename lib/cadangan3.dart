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
      final data = await _apiClient.fetchArabicAndTranslation(widget.surahNumber);

      debugPrint('Data fetched: $data');

      setState(() {
        if (data.isNotEmpty) {
          ayahs = processAyahs(data);
        } else {
          ayahs = [];
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

  List<Map<String, dynamic>> processAyahs(List<Map<String, dynamic>> data) {
    const String basmalah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
    if (data.isNotEmpty && data[0]['text'].startsWith(basmalah)) {
      final firstAyah = data[0];
      final remainingText = firstAyah['text'].replaceFirst(basmalah, '').trim();
      if (remainingText.isNotEmpty) {
        firstAyah['text'] = remainingText;
        data[0] = firstAyah;
      } else {
        data.removeAt(0);
      }
      data.insert(0, {
        'number': 0,
        'numberInSurah': 0,
        'arabic': basmalah,
        'translation': 'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang',
      });
    }
    return data;
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
          : ayahs.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada data untuk ditampilkan.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = ayahs[index];
                    final numberInSurah = ayah['numberInSurah'] ?? 0;
                    final text = ayah['arabic'] ?? '';
                    final translation = ayah['translation'] ?? '';

                    bool showBasmalah =
                        index == 0 && widget.surahNumber != 9; // At-Taubah tidak memiliki Basmalah
                    const basmalah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";

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
