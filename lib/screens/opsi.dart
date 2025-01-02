//lib\screens\opsi.dart
import 'package:flutter/material.dart';
import '../widgets/JuzPage.dart';
import '../screens/Surah_Arabic.dart';
import '../screens/Surah_Terjemah.dart';
import '../screens/Juz_Arabic.dart';
import '../screens/Juz_Terjemah.dart';

class Opsi extends StatelessWidget {
  final int number; // Nomor Surah atau Juz
  final String type; // Jenis: 'surah' atau 'juz'

  const Opsi({Key? key, required this.number, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Validasi type
    assert(type == 'surah' || type == 'juz', "Type must be 'surah' or 'juz'");

    String title = type == 'surah' ? 'Surah $number' : 'Juz $number';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Opsi untuk $title'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Arabic Saja'),
            onTap: () {
              // Navigasi ke file Arabic berdasarkan type
              if (type == 'surah') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahArabic(
                      surahNumber: number,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuzArabic(
                      juzNumber: number,
                    ),
                  ),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Dengan Terjemahan'),
            onTap: () {
              // Navigasi ke file Dengan Terjemahan berdasarkan type
              if (type == 'surah') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahTerjemah(
                      surahNumber: number,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JuzTerjemah(
                      juzNumber: number,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
