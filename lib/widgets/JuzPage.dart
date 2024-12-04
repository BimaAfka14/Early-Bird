import 'package:flutter/material.dart';
import 'package:quranconnect/screens/opsi.dart'; // Pastikan path sesuai

class JuzPage extends StatelessWidget {
  const JuzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Juz"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.greenAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: JuzListView(),
          ),
        ),
      ),
    );
  }
}

class JuzListView extends StatelessWidget {
  const JuzListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30, // Menampilkan 30 Juz
      itemBuilder: (context, index) {
        int juzNumber = index + 1; // Menampilkan Juz 1 hingga Juz 30
        return Card(
          elevation: 6, // Memberikan bayangan pada card
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Sudut tumpul pada card
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.tealAccent,
              child: Text(
                "$juzNumber",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            title: Text(
              "Juz $juzNumber",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.teal,
            ),
            onTap: () {
              // Navigasi ke halaman Opsi berdasarkan Juz yang dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Opsi(
                    number: juzNumber,
                    type: 'juz',
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
