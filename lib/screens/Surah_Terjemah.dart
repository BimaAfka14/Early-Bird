// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Import Provider
// import '../services/api_client.dart';
// import '../widgets/favorite_provider.dart'; // Import FavoriteProvider

// class SurahTerjemah extends StatefulWidget {
//   final int surahNumber;

//   const SurahTerjemah({Key? key, required this.surahNumber}) : super(key: key);

//   @override
//   _SurahTerjemahState createState() => _SurahTerjemahState();
// }

// class _SurahTerjemahState extends State<SurahTerjemah> {
//   final ApiClient _apiClient = ApiClient();
//   List<Map<String, String>> ayahs = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchArabicAndTranslation();
//   }

//   Future<void> fetchArabicAndTranslation() async {
//     try {
//       final data =
//           await _apiClient.fetchArabicAndTranslation(widget.surahNumber);
//       setState(() {
//         ayahs = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Surah ${widget.surahNumber} - Dengan Terjemahan',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: ayahs.length,
//               itemBuilder: (context, index) {
//                 final ayah = ayahs[index];
//                 final favoriteProvider =
//                     Provider.of<FavoriteProvider>(context); // Use listen: true

//                 return Column(
//                   children: [
//                     ListTile(
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 8.0, horizontal: 16.0),
//                       title: Row(
//                         children: [
//                           Text(
//                             'Ayat ${index + 1}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               ayah['arabic'] ?? '',
//                               textAlign: TextAlign.right,
//                               style: const TextStyle(
//                                 fontSize: 22,
//                                 fontFamily: 'ScheherazadeNew',
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               favoriteProvider.favoriteAyahs.any(
//                                       (fav) => fav['arabic'] == ayah['arabic'])
//                                   ? Icons.favorite
//                                   : Icons.favorite_border,
//                               color: favoriteProvider.favoriteAyahs.any(
//                                       (fav) => fav['arabic'] == ayah['arabic'])
//                                   ? Colors.red
//                                   : Colors.grey,
//                             ),
//                             onPressed: () {
//                               favoriteProvider
//                                   .toggleAyahFavorite(ayah); // Toggle favorite
//                             },
//                           ),
//                         ],
//                       ),
//                       subtitle: Padding(
//                         padding: const EdgeInsets.only(top: 8.0),
//                         child: Text(
//                           ayah['translation'] ?? '',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       color: Colors.grey.shade400,
//                       thickness: 1,
//                       indent: 16,
//                       endIndent: 16,
//                     ),
//                   ],
//                 );
//               },
//             ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../services/api_client.dart';
import '../widgets/favorite_provider.dart'; // Import FavoriteProvider

class SurahTerjemah extends StatefulWidget {
  final int surahNumber;

  const SurahTerjemah({Key? key, required this.surahNumber}) : super(key: key);

  @override
  _SurahTerjemahState createState() => _SurahTerjemahState();
}

class _SurahTerjemahState extends State<SurahTerjemah> {
  final ApiClient _apiClient = ApiClient();
  List<Map<String, String>> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArabicAndTranslation();
  }

  Future<void> fetchArabicAndTranslation() async {
    try {
      final data =
          await _apiClient.fetchArabicAndTranslation(widget.surahNumber);
      setState(() {
        ayahs = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah ${widget.surahNumber} - Dengan Terjemahan',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                final favoriteProvider =
                    Provider.of<FavoriteProvider>(context); // Use listen: true

                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      title: Row(
                        children: [
                          Text(
                            'Ayat ${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ayah['arabic'] ?? '',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'ScheherazadeNew',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteProvider.isFavorite(ayah)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteProvider.isFavorite(ayah)
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              favoriteProvider.toggleAyahFavorite(ayah);
                            },
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          ayah['translation'] ?? '',
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
            ),
    );
  }
}
