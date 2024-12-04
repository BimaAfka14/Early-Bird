// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../widgets/favorite_provider.dart';

// class FavoritesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Favorit'),
//           centerTitle: true,
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Ayat'),
//               Tab(text: 'Surah'),
//               Tab(text: 'Juz'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             AyatFavoritesTab(),
//             SurahFavoritesTab(),
//             JuzFavoritesTab(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AyatFavoritesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final favorites = Provider.of<FavoriteProvider>(context).favoriteAyahs;

//     return favorites.isEmpty
//         ? Center(
//             child: Text(
//               'Belum ada ayat favorit.',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           )
//         : ListView.builder(
//             itemCount: favorites.length,
//             itemBuilder: (context, index) {
//               final ayah = favorites[index];
//               return ListTile(
//                 title: Text(
//                   ayah['arabic'] ?? '',
//                   textAlign: TextAlign.right,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontFamily: 'ScheherazadeNew',
//                   ),
//                 ),
//                 subtitle: Text(
//                   ayah['translation'] ?? '',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               );
//             },
//           );
//   }
// }

// class SurahFavoritesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final favorites = Provider.of<FavoriteProvider>(context).favoriteSurahs;

//     return favorites.isEmpty
//         ? Center(
//             child: Text(
//               'Belum ada surah favorit.',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           )
//         : ListView.builder(
//             itemCount: favorites.length,
//             itemBuilder: (context, index) {
//               final surah = favorites[index];
//               return ListTile(
//                 title: Text(
//                   surah['name'] ?? '',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   'Surah ${surah['number'] ?? ''}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               );
//             },
//           );
//   }
// }

// class JuzFavoritesTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final favorites = Provider.of<FavoriteProvider>(context).favoriteJuz;

//     return favorites.isEmpty
//         ? Center(
//             child: Text(
//               'Belum ada Juz favorit.',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//           )
//         : ListView.builder(
//             itemCount: favorites.length,
//             itemBuilder: (context, index) {
//               final juz = favorites[index];
//               return ListTile(
//                 title: Text(
//                   'Juz $juz',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               );
//             },
//           );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/favorite_provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorit'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ayat'),
              Tab(text: 'Surah'),
              Tab(text: 'Juz'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AyatFavoritesTab(),
            SurahFavoritesTab(),
            JuzFavoritesTab(),
          ],
        ),
      ),
    );
  }
}

class AyatFavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoriteProvider>(context).favoriteAyahs;

    return favorites.isEmpty
        ? const Center(
            child: Text(
              'Belum ada ayat favorit.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final ayah = favorites[index];
              return ListTile(
                title: Text(
                  ayah['arabic'] ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'ScheherazadeNew',
                  ),
                ),
                subtitle: Text(
                  ayah['translation'] ?? '',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeAyahFavorite(ayah);
                  },
                ),
              );
            },
          );
  }
}

class SurahFavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoriteProvider>(context).favoriteSurahs;

    return favorites.isEmpty
        ? const Center(
            child: Text(
              'Belum ada surah favorit.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final surah = favorites[index];
              return ListTile(
                title: Text(
                  surah['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Surah ${surah['number'] ?? ''}',
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeSurahFavorite(surah);
                  },
                ),
              );
            },
          );
  }
}

class JuzFavoritesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoriteProvider>(context).favoriteJuz;

    return favorites.isEmpty
        ? const Center(
            child: Text(
              'Belum ada Juz favorit.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          )
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final juz = favorites[index];
              return ListTile(
                title: Text(
                  'Juz $juz',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    Provider.of<FavoriteProvider>(context, listen: false)
                        .removeJuzFavorite(juz);
                  },
                ),
              );
            },
          );
  }
}
