// lib\main.dart
import 'package:flutter/material.dart';
import './screens/dashboard.dart';

void main() {
  runApp(QuranConnectApp());
}

class QuranConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Dashboard(),
    );
  }
}
