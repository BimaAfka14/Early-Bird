import 'package:flutter/material.dart';
import 'package:quranconnect/screens/LoginPage.dart';
import 'package:quranconnect/screens/RegisterPage.dart';
// import 'screens/dashboard.dart';
// import 'screens/login_page.dart';
// import 'screens/register_page.dart';

void main() {
  runApp(QuranConnectApp());
}

class QuranConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}