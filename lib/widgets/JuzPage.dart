import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quranconnect/screens/opsi.dart';

class JuzPage extends StatelessWidget {
  const JuzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Juz"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: JuzListView(),
          ),
        ),
      ),
    );
  }
}

class JuzListView extends StatelessWidget {
  JuzListView({Key? key}) : super(key: key);

  final List<String> manualTranslations = [
    // List manual translations
    "Pembuka",
    "Sapi Betina",
    "Keluarga Imran",
    "Wanita",
    "Jamuan",
    "Hewan Ternak",
    "Tempat yang Tertinggi",
    "Harta Rampasan Perang",
    "Pengampunan",
    "Nabi Yunus",
    "Nabi Hud",
    "Nabi Yusuf",
    "Guruh",
    "Nabi Ibrahim",
    "Gunung Al Hijr",
    "Lebah",
    "Perjalanan Malam",
    "Gua",
    "Maryam",
    "Taha",
    "Para Nabi",
    "Haji",
    "Orang-orang mukmin",
    "Cahaya",
    "Pembeda",
    "Penyair",
    "Semut",
    "Kisah-kisah",
    "Laba-laba",
    "Bangsa Romawi",
    "Keluarga Luqman",
    "Sajdah",
    "Golongan-golongan yang Bersekutu",
    "Kaum Saba'",
    "Pencipta",
    "Yasin",
    "Barisan-barisan",
    "Shaad",
    "Rombongan-rombongan",
    "Yang Mengampuni",
    "Yang Dijelaskan",
    "Musyawarah",
    "Perhiasan",
    "Kabut",
    "Yang Bertekuk Lutut",
    "Bukit-bukit Pasir",
    "Nabi Muhammad",
    "Kemenangan",
    "Kamar-kamar",
    "Qaaf",
    "Angin yang Menerbangkan",
    "Bukit",
    "Bintang",
    "Bulan",
    "Yang Maha Pemurah",
    "Hari Kiamat",
    "Besi",
    "Wanita yang Mengajukan Gugatan",
    "Pengusiran",
    "Wanita yang Diuji",
    "Satu Barisan",
    "Hari Jum'at",
    "Orang-orang yang Munafik",
    "Hari Dinampakkan Kesalahan-kesalahan",
    "Talak",
    "Penghargaan",
    "Kerajaan",
    "Pena",
    "Hari Kiamat",
    "Tempat Naik",
    "Nabi Nuh",
    "Jin",
    "Orang yang Berselimut",
    "Orang yang Berkemul",
    "Kiamat",
    "Manusia",
    "Malaikat-Malaikat Yang Diutus",
    "Berita Besar",
    "Malaikat-Malaikat Yang Mencabut",
    "Ia Bermuka Masam",
    "Menggulung",
    "Terbelah",
    "Orang-orang yang Curang",
    "Terbelah",
    "Gugusan Bintang",
    "Yang Datang di Malam Hari",
    "Yang Paling Tinggi",
    "Hari Pembalasan",
    "Fajar",
    "Negeri",
    "Matahari",
    "Malam",
    "Waktu Matahari Sepenggalahan Naik",
    "Melapangkan",
    "Buah Tin",
    "Segumpal Darah",
    "Kemuliaan",
    "Pembuktian",
    "Kegoncangan",
    "Berlari Kencang",
    "Hari Kiamat",
    "Bermegah-megahan",
    "Masa",
    "Pengumpat",
    "Gajah",
    "Suku Quraisy",
    "Barang-barang yang Berguna",
    "Nikmat yang Berlimpah",
    "Orang-Orang Kafir",
    "Pertolongan",
    "Gejolak Api",
    "Ikhlas",
    "Waktu Subuh",
    "Umat Manusia"
  ];

  Future<List<Map<String, dynamic>>> fetchJuzList() async {
    List<Map<String, dynamic>> juzData = [];
    for (int i = 1; i <= 30; i++) {
      try {
        final response = await http
            .get(Uri.parse('https://api.alquran.cloud/v1/juz/$i/id.asad'));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body)['data'];
          final surahSet = <String, Map<String, dynamic>>{};
          for (var ayah in data['ayahs']) {
            int surahNumber = ayah['surah']['number'];
            surahSet[surahNumber.toString()] = {
              'name': ayah['surah']['englishName'],
              'translation': manualTranslations[surahNumber - 1],
              'revelation': ayah['surah']['revelationType'],
              'ayahCount': ayah['surah']['numberOfAyahs'],
            };
          }
          juzData.add({
            'juzNumber': data['number'],
            'ayahCount': data['ayahs'].length,
            'surahs': surahSet.values.toList(),
          });
        } else {
          throw Exception('Failed to load Juz $i');
        }
      } catch (e) {
        debugPrint("Error fetching data for Juz $i: $e");
      }
    }
    return juzData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchJuzList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Data tidak ditemukan."));
        } else {
          final juzData = snapshot.data!;
          return ListView.builder(
            itemCount: juzData.length,
            itemBuilder: (context, index) {
              final juz = juzData[index];
              return JuzCard(
                juzNumber: juz['juzNumber'],
                surahs: juz['surahs'] as List<Map<String, dynamic>>,
                ayahCount: juz['ayahCount'],
              );
            },
          );
        }
      },
    );
  }
}

class JuzCard extends StatefulWidget {
  final int juzNumber;
  final List<Map<String, dynamic>> surahs;
  final int ayahCount;

  const JuzCard({
    Key? key,
    required this.juzNumber,
    required this.surahs,
    required this.ayahCount,
  }) : super(key: key);

  @override
  _JuzCardState createState() => _JuzCardState();
}

class _JuzCardState extends State<JuzCard> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Juz ${widget.juzNumber}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${widget.ayahCount} Ayat",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Opsi(
                          number: widget.juzNumber,
                          type: 'juz',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Show More / Show Less
          if (_showMore)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: widget.surahs.map((surah) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${surah['name']} (${surah['translation']})",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          "${surah['revelation']} • ${surah['ayahCount']} Ayat",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _showMore = !_showMore;
                });
              },
              child: Text(
                _showMore ? "Show Less" : "Show More",
                style: const TextStyle(
                    color: Colors.teal, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
