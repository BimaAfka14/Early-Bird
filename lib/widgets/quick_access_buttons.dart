import 'package:flutter/material.dart';
import 'package:quranconnect/widgets/SurahPage.dart';
import '../widgets/JuzPage.dart';
import '../screens/Favorite_Pages.dart';

class QuickAccessButtons extends StatelessWidget {
  final VoidCallback onQuran;
  final VoidCallback onHistory;
  final VoidCallback onFavorites;

  QuickAccessButtons({
    required this.onQuran,
    required this.onHistory,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2, // 2 kolom
      crossAxisSpacing: 16, // Spasi horizontal antar item
      mainAxisSpacing: 16, // Spasi vertikal antar item
      padding: EdgeInsets.all(16), // Padding di sekitar GridView
      shrinkWrap: true, // Menyesuaikan tinggi GridView dengan konten
      childAspectRatio: 1, // Rasio aspek untuk setiap card
      children: [
        _buildQuickActionCard(
          icon: Icons.book,
          label: "Baca Quran",
          onTap: (() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SurahPage()));
          }),
        ),
        _buildQuickActionCard(
          icon: Icons.book,
          label: "Baca Juz",
          onTap: (() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => JuzPage()));
          }),
        ),
        _buildQuickActionCard(
          icon: Icons.history,
          label: "Riwayat",
          onTap: onHistory,
        ),
        _buildQuickActionCard(
          icon: Icons.favorite,
          label: "Favorit",
          onTap: (() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FavoritePages()));
          }),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4, // Memberikan bayangan pada card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Sudut tumpul pada card
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // Sudut tumpul pada InkWell
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Menyusun ikon dan teks di tengah
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green[200],
                child: Icon(icon, size: 30, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // Menyelaraskan teks di tengah
              ),
            ],
          ),
        ),
      ),
    );
  }
}
