//lib\screens\Surah_Arabic.dart
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
                        : 0), // No Basmalah for Surah 1 and 9
                itemBuilder: (context, index) {
                  if (index == 0 &&
                      widget.surahNumber != 1 &&
                      widget.surahNumber != 9) {
                    // Displaying Basmalah if Surah is not 1 and 9
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

                  // Access the correct Ayah (adjust index for Surah > 1)
                  final ayah = ayahs[
                      widget.surahNumber != 1 && widget.surahNumber != 9
                          ? index - 1
                          : index];

                  // Remove Basmalah from Ayah text if it starts with it
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

                  // Get the Ayah number
                  final ayahNumber =
                      widget.surahNumber != 1 && widget.surahNumber != 9
                          ? index
                          : index + 1;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display Ayah number
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          'Ayah $ayahNumber',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // Divider between verses
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        height: 20,
                      ),
                      // Arabic Ayah text with right alignment
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
                                  height:
                                      1.5, // Adjust line height for readability
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
