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
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: JuzListView(),
          ),
        ),
      ),
    );
  }
}

class JuzListView extends StatelessWidget {
  const JuzListView({Key? key}) : super(key: key);

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
            surahSet[ayah['surah']['number'].toString()] = {
              'name': ayah['surah']['englishName'],
              'translation': ayah['surah']['englishNameTranslation'],
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
              final juzNumber = juz['juzNumber'];
              final surahs = juz['surahs'] as List<Map<String, dynamic>>;
              final ayahCount = juz['ayahCount'];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Juz $juzNumber",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Opsi(
                                    number: juzNumber,
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
                    // Body Card
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...surahs.map((surah) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${surah['name']} (${surah['translation']})",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
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
                          const SizedBox(height: 8.0),
                          Text(
                            "Jumlah Ayat: $ayahCount",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
