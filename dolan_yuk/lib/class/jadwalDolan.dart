class JadwalDolan {
  final String id;
  final String nama;
  final DateTime timestamp; // Ubah ke DateTime
  final String lokasi;
  final String alamat;
  final String photo;
  final int jumlahPemain;

  JadwalDolan({
    required this.id,
    required this.nama,
    required this.timestamp,
    required this.lokasi,
    required this.alamat,
    required this.photo,
    required this.jumlahPemain,
  });

  factory JadwalDolan.fromJson(Map<String, dynamic> json) {
    return JadwalDolan(
      id: json['jadwals_id'],
      nama: json['nama'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000), // Ubah ke DateTime
      lokasi: json['lokasi'],
      alamat: json['alamat'],
      photo: json['photo'],
      jumlahPemain: json['jumlah_pemain'],
    );
  }
}
