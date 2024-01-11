class JadwalDolan {
  final int id;
  final String nama;
  final DateTime timestamp;
  final String lokasi;
  final String alamat;
  final String photo;
  final int jumlahPemain;
  final int banyakPemain;

  JadwalDolan({
    required this.id,
    required this.nama,
    required this.timestamp,
    required this.lokasi,
    required this.alamat,
    required this.photo,
    required this.jumlahPemain,
    required this.banyakPemain,
  });

  factory JadwalDolan.fromJson(Map<String, dynamic> json) {
    return JadwalDolan(
      id: json['id'] as int,
      nama: json['nama'],
      timestamp: DateTime.parse(json['tanggal']), // Ubah ke DateTime
      lokasi: json['lokasi'],
      alamat: json['alamat'],
      photo: json["photo"],
      jumlahPemain: json['jumlah_minimal'] as int,
      banyakPemain: json['banyak_member'] as int,
    );
  }
}
