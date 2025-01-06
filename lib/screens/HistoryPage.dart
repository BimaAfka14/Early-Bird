import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quranconnect/screens/Juz_Terjemah.dart';
import 'package:http/http.dart' as http;
import '../services/database_helper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<String, int>? bookmark;
  String? arabicText;
  String? translationText;
  String? surahName;  // Menambahkan variabel untuk nama surah
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookmarkAndData();
  }

  // Mengambil bookmark terakhir dan detail ayat
  Future<void> fetchBookmarkAndData() async {
    try {
      final history = await DatabaseHelper().getReadingHistory();

      if (history != null && history['surah'] != 0 && history['ayah'] != 0) {
        final surahNumber = history['surah']!;
        final ayahNumber = history['ayah']!;

        // Ambil teks Arab
        final arabicUrl =
            'https://api.alquran.cloud/v1/surah/$surahNumber/id.asad';
        final arabicResponse = await http.get(Uri.parse(arabicUrl));
        final arabicData = json.decode(arabicResponse.body);

        // Ambil terjemahan
        final translationUrl =
            'https://api.alquran.cloud/v1/surah/$surahNumber/id.indonesian';
        final translationResponse = await http.get(Uri.parse(translationUrl));
        final translationData = json.decode(translationResponse.body);

        // Ambil ayah sesuai nomor
        final arabicText = arabicData['data']['ayahs'][ayahNumber - 1]['text'];
        final translationText =
            translationData['data']['ayahs'][ayahNumber - 1]['text'];

        // Ambil nama Surah (menggunakan englishName)
        final surahName = arabicData['data']['englishName'];  // Menggunakan englishName

        setState(() {
          bookmark = history;
          this.arabicText = arabicText;
          this.translationText = translationText;
          this.surahName = surahName;  // Menyimpan nama Surah
          isLoading = false;
        });
      } else {
        // Jika tidak ada riwayat, set data kosong
        setState(() {
          bookmark = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching bookmark: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Bookmark'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookmark == null
              ? Center(
                  child: Text(
                    'Tidak ada bookmark yang tersimpan.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.all(16.0),
                  children: [
                    Text(
                      'Surah ${surahName ?? 'Tidak Diketahui'} Ayat ${bookmark!['ayah']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      arabicText ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      translationText ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        // Arahkan pengguna ke halaman Juz Terjemah dan ambil data yang diperbarui
                        final updatedBookmark = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JuzTerjemah(juzNumber: bookmark!['surah']!),
                          ),
                        );

                        // Setelah halaman Juz Terjemah ditutup, update bookmark di HistoryPage
                        if (updatedBookmark != null) {
                          // Perbarui data di HistoryPage
                          setState(() {
                            bookmark = updatedBookmark;
                            fetchBookmarkAndData();  // Segera panggil ulang fetchBookmarkAndData untuk update data terbaru
                          });
                        }
                      },
                      child: Text('Buka Ayat'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
    );
  }
}