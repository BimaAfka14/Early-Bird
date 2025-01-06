import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SurahPage extends StatefulWidget {
  final int surahNumber;

  const SurahPage({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  List<dynamic> ayahs = [];
  List<dynamic> translation = [];
  bool isLoading = true;
  String surahName = '';

  @override
  void initState() {
    super.initState();
    fetchSurahData();
  }

  // Ambil data surah dan terjemahannya dari API
  Future<void> fetchSurahData() async {
    final surahUrl = 'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/ar.alafasy';
    final translationUrl = 'https://api.alquran.cloud/v1/surah/${widget.surahNumber}/id.indonesian';

    try {
      final surahResponse = await http.get(Uri.parse(surahUrl));
      final translationResponse = await http.get(Uri.parse(translationUrl));

      if (surahResponse.statusCode == 200 && translationResponse.statusCode == 200) {
        final surahData = json.decode(surahResponse.body)['data'];
        final translationData = json.decode(translationResponse.body)['data'];

        setState(() {
          ayahs = surahData['ayahs'];
          translation = translationData['ayahs'];
          surahName = surahData['englishName']; // Nama surah
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load Surah or Translation');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching Surah data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(surahName.isNotEmpty ? surahName : 'Surah ${widget.surahNumber}'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ayahs.isEmpty
              ? const Center(child: Text('No Ayahs found'))
              : ListView.builder(
                  itemCount: ayahs.length,
                  itemBuilder: (context, index) {
                    final ayah = ayahs[index];
                    final translatedText = translation.isNotEmpty
                        ? translation[index]['text'] ?? ''
                        : '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ayah Number
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Ayah ${ayah['numberInSurah']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(),
                              // Ayah Arabic
                              Text(
                                ayah['text'] ?? '',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Amiri',
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Terjemahan
                              Text(
                                translatedText,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
