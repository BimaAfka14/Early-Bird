//lib\widgets\daily_ayah_card.dart
import 'package:flutter/material.dart';

class DailyAyahCard extends StatelessWidget {
  final String? surahName;
  final int? ayahNumber;
  final String? ayahArabic;
  final String? ayahTranslation;
  final bool isLoading;

  const DailyAyahCard({
    Key? key,
    required this.surahName,
    required this.ayahNumber,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surahName != null && ayahNumber != null
                        ? "$surahName - Ayat $ayahNumber"
                        : "Memuat nama surah...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    ayahArabic ?? "Gagal memuat ayat",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  SizedBox(height: 16),
                  Text(
                    ayahTranslation ?? "Gagal memuat terjemahan",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}