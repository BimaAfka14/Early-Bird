import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://api.alquran.cloud/v1';

  /// Mendapatkan seluruh Al-Qur'an
  static Future<dynamic> getQuran() async {
    const url = '$baseUrl/quran/id.asad';
    return await _getRequest(url);
  }

  /// Mendapatkan data Juz tertentu
  static Future<dynamic> getJuz(int juzNumber) async {
    final url = '$baseUrl/juz/$juzNumber/id.asad';
    return await _getRequest(url);
  }

  /// Mendapatkan data Juz 30
  static Future<void> fetchJuzData() async {
    final url = Uri.parse('$baseUrl/juz/30/id.asad');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data['data']); // Akses data ayat di sini
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Melakukan GET request umum
  static Future<dynamic> _getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse JSON menjadi Map
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  /// Mendapatkan daftar surah
  Future<List<dynamic>> fetchSurahs() async {
    final url = Uri.parse('$baseUrl/surah');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data']; // Mengembalikan daftar surah
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  /// Mendapatkan detail surah tertentu berdasarkan edition
  Future<Map<String, dynamic>> fetchSurahDetails(
      int surahNumber, String edition) async {
    final url = '$baseUrl/surah/$surahNumber/$edition';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Mengembalikan data surah
    } else {
      throw Exception('Failed to fetch surah details');
    }
  }

  /// Mendapatkan data ayat dari Surah dengan teks Arab dan terjemahan
  Future<List<Map<String, String>>> fetchArabicAndTranslation(
      int surahNumber) async {
    try {
      // Ambil teks Arab
      final arabicResponse = await fetchSurahDetails(surahNumber, 'ar.asad');
      final arabicAyahs = arabicResponse['ayahs'];

      // Ambil terjemahan
      final translationResponse =
          await fetchSurahDetails(surahNumber, 'id.indonesian');
      final translationAyahs = translationResponse['ayahs'];

      // Gabungkan data
      List<Map<String, String>> combinedAyahs = [];
      for (int i = 0; i < arabicAyahs.length; i++) {
        combinedAyahs.add({
          'arabic': arabicAyahs[i]['text'] ?? '',
          'translation': translationAyahs[i]['text'] ?? '',
          'number': arabicAyahs[i]['numberInSurah'].toString(),
        });
      }

      return combinedAyahs;
    } catch (e) {
      throw Exception('Error fetching Arabic and Translation: $e');
    }
  }

  // Fungsi untuk mengambil terjemahan Juz
  Future<dynamic> getJuzTranslation(int juzNumber) async {
    final url = '$baseUrl/juz/$juzNumber/id.indonesian';
    return await _getRequest(url);
  }
}
