import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _keywordController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // Store Arabic Ayah text here
  Map<String, String> arabicAyahs = {};

  Future<void> searchAyah(String keyword) async {
    setState(() {
      _isLoading = true;
      _searchResults = [];
    });

    try {
      final url =
          'https://api.alquran.cloud/v1/search/$keyword/all/id.indonesian'; // Search endpoint
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _searchResults = data['data']['matches'];
          _hasSearched = true;
        });

        // After search results are loaded, fetch Arabic text for each Ayah
        for (var match in _searchResults) {
          await fetchArabicText(
              match['surah']['number'], match['numberInSurah']);
        }
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error during search: $e');
      setState(() {
        _hasSearched = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchArabicText(int surahNumber, int ayahNumber) async {
    try {
      final url =
          'https://api.alquran.cloud/v1/surah/$surahNumber/id.asad'; // Arabic Surah endpoint
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final surahData = data['data']['ayahs'] as List;

        // Find the specific Ayah
        final ayah = surahData.firstWhere(
          (ayah) => ayah['numberInSurah'] == ayahNumber,
          orElse: () => null, // Return null if not found
        );

        if (ayah != null) {
          final arabicAyah = ayah['text']; // Get Arabic text of the Ayah
          setState(() {
            arabicAyahs['$surahNumber-$ayahNumber'] =
                arabicAyah; // Store Arabic text
          });
        } else {
          print('Ayah $ayahNumber not found in Surah $surahNumber');
        }
      } else {
        print('Failed to load Arabic text for Surah $surahNumber');
      }
    } catch (e) {
      print('Error fetching Arabic text: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Ayat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                labelText: 'Masukkan kata kunci',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    if (_keywordController.text.isNotEmpty) {
                      searchAyah(_keywordController.text.trim());
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_hasSearched && _searchResults.isEmpty)
              const Center(
                child: Text(
                  'Tidak ada hasil yang ditemukan.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final match = _searchResults[index];
                    final arabicAyahKey =
                        '${match['surah']['number']}-${match['numberInSurah']}';
                    final arabicAyah = arabicAyahs[arabicAyahKey] ??
                        ''; // Retrieve Arabic text
                    final translationText = match['text']; // Translation text

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          translationText, // Translation in Indonesian
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              arabicAyah.isNotEmpty
                                  ? arabicAyah // Display Arabic Ayah text
                                  : 'Arabic text not found',
                              style: const TextStyle(fontSize: 18),
                              textDirection: TextDirection
                                  .rtl, // Set text direction for Arabic
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${match['surah']['englishName']} (${match['surah']['name']}) - Ayat ${match['numberInSurah']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
