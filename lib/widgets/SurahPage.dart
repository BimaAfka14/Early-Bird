import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../screens/Surah_Arabic.dart';
import '../screens/opsi.dart';

class SurahPage extends StatefulWidget {
  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> surahList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurahData();
  }

  Future<void> fetchSurahData() async {
    try {
      final surahs = await _apiClient.fetchSurahs();
      setState(() {
        surahList = surahs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Surah Al-Quran'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: surahList.length,
              itemBuilder: (context, index) {
                final surah = surahList[index];
                return ListTile(
                  title: Text('${surah['englishName']} (${surah['name']})'),
                  subtitle: Text('Jumlah Ayat: ${surah['numberOfAyahs']}'),
                  trailing: Text(surah['revelationType']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Opsi(
                          number: surah['number'], // Pass juzNumber
                          type: 'surah', // Specify the type as 'juz'
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
