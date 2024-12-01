import 'package:flutter/material.dart';
import 'package:quranconnect/screens/opsi.dart'; // Pastikan path sesuai

class JuzPage extends StatelessWidget {
  const JuzPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Juz"),
        centerTitle: true,
      ),
      body: SafeArea(
        // Menggunakan SafeArea untuk menghindari overflow dan area terpotong
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: JuzListView(), // Menyematkan JuzListView dengan padding
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
          elevation: 4, // Memberikan bayangan pada card
          margin: const EdgeInsets.symmetric(
              vertical: 8.0), // Memberikan jarak vertikal antar card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut tumpul pada card
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            title: Text(
              "Juz $juzNumber",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              // Navigasi ke halaman Opsi berdasarkan Juz yang dipilih
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Opsi(
                    number: juzNumber, // Pass juzNumber
                    type: 'juz', // Tipe 'juz' yang dikirimkan
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
