import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://api.alquran.cloud/v1';

  // Fungsi untuk mendapatkan seluruh Al-Qur'an
  static Future<dynamic> getQuran() async {
    const url = '$baseUrl/quran/id.asad';
    return await _getRequest(url);
  }

  // Fungsi untuk mendapatkan data Juz tertentu
  static Future<dynamic> getJuz(int juzNumber) async {
    final url = '$baseUrl/juz/$juzNumber/id.asad';
    return await _getRequest(url);
  }

  // Fungsi umum untuk melakukan GET request
  static Future<dynamic> _getRequest(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Parse JSON menjadi Map
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
