//lib\screens\Favorite_Pages.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/favorite_provider.dart'; // Path ke FavoriteProvider
import '../models/favorite_ayah.dart'; // Path ke model Ayah

class FavoritePages extends StatelessWidget {
  const FavoritePages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayat Favorit',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, _) {
          // Mengambil daftar ayat favorit
          final favoriteAyahs = favoriteProvider.favoriteAyahs;

          if (favoriteAyahs.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada ayat favorit.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteAyahs.length,
            itemBuilder: (context, index) {
              final ayah = favoriteAyahs[index];

              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    title: Row(
                      children: [
                        Text(
                          'Ayat ${ayah.numberInSurah}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ayah.text,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'ScheherazadeNew',
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ayah.text, // Gunakan terjemahan atau lainnya
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
