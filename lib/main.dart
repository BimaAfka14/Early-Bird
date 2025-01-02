//lib\main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import './screens/dashboard.dart';
import './widgets/Favorite_Provider.dart'; // Import FavoriteProvider

void main() {
  runApp(QuranConnectApp());
}

class QuranConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => FavoriteProvider()), // Daftarkan Provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: Dashboard(),
      ),
    );
  }
}
