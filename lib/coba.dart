import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quranconnect/screens/juz_page.dart';
 // Halaman baru untuk menampilkan seluruh juz

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? _ayahArabic; // Teks ayat dalam bahasa Arab
  String? _ayahTranslation; // Terjemahan ayat dalam bahasa Indonesia
  String? _surahName; // Nama surah
  int? _ayahNumber; // Untuk menyimpan nomor surat
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRandomAyah(); // Fetch ayat harian saat aplikasi dimulai
  }

  Future<void> fetchRandomAyah() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Generate random ayah reference
      final randomAyahNumber = Random().nextInt(6236) + 1;

      // Endpoint untuk mendapatkan ayat dalam dua edisi
      final urlArab =
          "http://api.alquran.cloud/v1/ayah/$randomAyahNumber/editions/quran-uthmani";
      final urlTranslation =
          "http://api.alquran.cloud/v1/ayah/$randomAyahNumber/editions/id.indonesian";

      // Mengambil data dari kedua API secara paralel
      final responses = await Future.wait([
        http.get(Uri.parse(urlArab)),
        http.get(Uri.parse(urlTranslation)),
      ]);

      if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
        final dataArab = jsonDecode(responses[0].body)['data'];
        final dataTranslation = jsonDecode(responses[1].body)['data'];

        setState(() {
          // Ambil data Arab dan terjemahan dari hasil API
          _ayahArabic = dataArab[0]['text']; // Ayat dalam teks Arab
          _ayahTranslation =
              dataTranslation[0]['text']; // Terjemahan bahasa Indonesia
          _surahName =
              "${dataArab[0]['surah']['englishName']} (${dataArab[0]['surah']['name']})"; // Nama surah
          _ayahNumber = dataArab[0]['numberInSurah']; // Nomor ayat dalam surah
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
                // Ayat Harian Section
                Card(
                  color: Colors.green[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Surah dan Nomor Ayat
                              Text(
                                _surahName != null && _ayahNumber != null
                                    ? "$_surahName - Ayat $_ayahNumber"
                                    : "Memuat nama surah...",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[800],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Teks Ayat (Bahasa Arab)
                              Text(
                                _ayahArabic ?? "Gagal memuat ayat",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 16),
                              // Terjemahan Ayat (Bahasa Indonesia)
                              Text(
                                _ayahTranslation ?? "Gagal memuat terjemahan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 20),
                // Other Dashboard Widgets
                Text(
                  "Akses Cepat",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                aksescepat(),
                SizedBox(height: 20),
                // ListView untuk Juz 1 - Juz 30
                Text(
                  "Pilih Juz",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 300, // Tinggi untuk memungkinkan pengguliran
                  child: ListView.builder(
                    itemCount: 30, // Total 30 Juz
                    itemBuilder: (context, index) {
                      int juzNumber = index + 1; // Juz dimulai dari 1
                      return Card(
                        child: ListTile(
                          title: Text("Juz $juzNumber"),
                          onTap: () {
                            // Navigasi ke halaman JuzPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JuzPage(juzNumber: juzNumber),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row aksescepat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionButton(
          icon: Icons.book,
          label: "Baca Quran",
          onTap: () {
            // Navigate to Quran reading page
          },
        ),
        _buildQuickActionButton(
          icon: Icons.history,
          label: "Riwayat",
          onTap: () {
            // Navigate to history page
          },
        ),
        _buildQuickActionButton(
          icon: Icons.favorite,
          label: "Favorit",
          onTap: () {
            // Navigate to favorites page
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[200],
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
