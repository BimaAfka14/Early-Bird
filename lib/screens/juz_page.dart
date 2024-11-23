import 'package:flutter/material.dart';
import '../services/api_client.dart';

class JuzPage extends StatefulWidget {
  final int juzNumber;

  const JuzPage({Key? key, required this.juzNumber}) : super(key: key);

  @override
  _JuzPageState createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> {
  late Future<dynamic> _juzData;

  @override
  void initState() {
    super.initState();
    _juzData =
        ApiClient.getJuz(widget.juzNumber); // Ambil data API untuk Juz tertentu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Juz ${widget.juzNumber}'),
      ),
      body: FutureBuilder<dynamic>(
        future: _juzData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available.'));
          } else {
            // Ambil daftar ayat dari snapshot
            final juzData = snapshot.data;
            final ayahs = juzData['data']['ayahs'] ?? [];

            if (ayahs.isEmpty) {
              return const Center(
                  child: Text('No Ayahs available in this Juz.'));
            }

            return ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return ListTile(
                  title:
                      Text(ayah['text'] ?? 'No text'), // Menampilkan teks ayat
                  subtitle: Text(
                    '${ayah['surah']['englishName']} (${ayah['surah']['name']})',
                  ), // Menampilkan nama surah
                  trailing: Text('Ayat ${ayah['numberInSurah']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
