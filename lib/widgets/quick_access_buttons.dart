import 'package:flutter/material.dart';

class QuickAccessButtons extends StatelessWidget {
  final VoidCallback onReadQuran;
  final VoidCallback onHistory;
  final VoidCallback onFavorites;

  QuickAccessButtons({
    required this.onReadQuran,
    required this.onHistory,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionButton(
          icon: Icons.book,
          label: "Baca Quran",
          onTap: onReadQuran,
        ),
        _buildQuickActionButton(
          icon: Icons.history,
          label: "Riwayat",
          onTap: onHistory,
        ),
        _buildQuickActionButton(
          icon: Icons.favorite,
          label: "Favorit",
          onTap: onFavorites,
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green[200],
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
