import 'package:shared_preferences/shared_preferences.dart';

class HistoryService {
  // Mendapatkan data surah dan ayah terakhir yang dibaca
  static Future<Map<String, dynamic>> getLastRead() async {
    final prefs = await SharedPreferences.getInstance();
    final surahNumber = prefs.getInt('lastSurah') ?? 1; // Default ke Surah 1
    final ayahNumber = prefs.getInt('lastAyah') ?? 1; // Default ke Ayah 1
    final juzNumber = prefs.getInt('lastJuz') ?? 1; // Default ke Juz 1
    final arabicText = prefs.getString('lastArabicText') ?? ''; // Default ke string kosong
    final translationText = prefs.getString('lastTranslationText') ?? ''; // Default ke string kosong
    return {'surah': surahNumber, 'ayah': ayahNumber, 'juz': juzNumber, 'arabicText': arabicText, 'translationText': translationText};
  }

  // Menyimpan surah dan ayah yang terakhir dibaca
  static Future<void> saveLastRead(int surahNumber, int ayahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSurah', surahNumber);
    await prefs.setInt('lastAyah', ayahNumber);
  }
}
