import 'package:flutter/material.dart';
import '../services/api_client.dart';

class JuzArabic extends StatefulWidget {
  final int juzNumber;

  const JuzArabic({Key? key, required this.juzNumber}) : super(key: key);

  @override
  _JuzArabicState createState() => _JuzArabicState();
}

class _JuzArabicState extends State<JuzArabic> {
  final ApiClient _apiClient = ApiClient();
  List<dynamic> ayahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJuzData();
  }

  Future<void> fetchJuzData() async {
    try {
      final data = await ApiClient.getJuz(widget.juzNumber);
      setState(() {
        ayahs = data['data']['ayahs'];
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
        title: Text('Juz ${widget.juzNumber} - Arabic Saja'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return ListTile(
                  title: Text(
                    ayah['text'],
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
    );
  }
}
