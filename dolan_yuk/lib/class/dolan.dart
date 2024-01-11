class Dolan {
  int id;
  String nama;
  int jumlah_minimal;
  String photo;
  Dolan({required this.id, required this.nama, required this.jumlah_minimal, required this.photo});

  factory Dolan.fromJSON(Map<String, dynamic> json) {
    return Dolan(
      id: json['id'] as int,
      nama: json["nama"],
      jumlah_minimal: json["jumlah_minimal"],
      photo: json["photo"],
    );
  }
}
