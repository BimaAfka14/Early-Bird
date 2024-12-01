import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quranconnect/widgets/SurahPage.dart';

import '../widgets/daily_ayah_card.dart';
import '../widgets/quick_access_buttons.dart';
import '../widgets/JuzPage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _ayahArabic;
  String? _ayahTranslation;
  String? _surahName;
  int? _ayahNumber;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomAyah();
  }

  Future<void> fetchRandomAyah() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final randomAyahNumber = Random().nextInt(6236) + 1;
      final urlArab =
          "http://api.alquran.cloud/v1/ayah/$randomAyahNumber/editions/quran-uthmani";
      final urlTranslation =
          "http://api.alquran.cloud/v1/ayah/$randomAyahNumber/editions/id.indonesian";

      final responses = await Future.wait([
        http.get(Uri.parse(urlArab)),
        http.get(Uri.parse(urlTranslation)),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final dataArab = jsonDecode(responses[0].body)['data'];
        final dataTranslation = jsonDecode(responses[1].body)['data'];

        setState(() {
          _ayahArabic = dataArab[0]['text'];
          _ayahTranslation = dataTranslation[0]['text'];
          _surahName =
              "${dataArab[0]['surah']['englishName']} (${dataArab[0]['surah']['name']})";
          _ayahNumber = dataArab[0]['numberInSurah'];
        });
      } else {
        throw Exception("Gagal memuat data ayat");
      }
    } catch (e) {
      print("Error fetching ayah: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuranConnect"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DailyAyahCard(
                  surahName: _surahName,
                  ayahNumber: _ayahNumber,
                  ayahArabic: _ayahArabic,
                  ayahTranslation: _ayahTranslation,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 20),
                Text(
                  "Akses Cepat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                QuickAccessButtons(
                  onQuran: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SurahPage()));
                  },
                  // Tambahkan navigasi ke halaman Quran
                  onHistory: () {
                    print("Navigasi ke halaman riwayat");
                    // Tambahkan navigasi ke halaman riwayat
                  },
                  onFavorites: () {
                    print("Navigasi ke halaman favorit");
                    // Tambahkan navigasi ke halaman favorit
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
