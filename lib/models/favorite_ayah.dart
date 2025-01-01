class Ayah {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: int.tryParse(json['number'].toString()) ?? 0,
      text: json['text'] ?? '', // Berikan nilai default jika null
      numberInSurah: int.tryParse(json['numberInSurah'].toString()) ?? 0,
      juz: int.tryParse(json['juz'].toString()) ?? 0,
      manzil: int.tryParse(json['manzil'].toString()) ?? 0,
      page: int.tryParse(json['page'].toString()) ?? 0,
      ruku: int.tryParse(json['ruku'].toString()) ?? 0,
      hizbQuarter: int.tryParse(json['hizbQuarter'].toString()) ?? 0,
      sajda: json['sajda'] ?? false, // Nilai default untuk bool
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
    };
  }
}
