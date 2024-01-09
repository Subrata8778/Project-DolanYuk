import 'package:flutter/material.dart';
import 'package:dolan_yuk/class/jadwalDolan.dart';

class Jadwal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for testing
    List<jadwalDolan> jadwalList = [
      jadwalDolan(
        nama: "url_foto",
        tanggal: "01 Januari 2022",
        jam: "15:00 - 17:00",
        lokasi: "Nama Tempat 1",
        alamat: "Alamat Dolanan 1",
        photo: "Informasi Dolanan 1",
        jumlahPemain: 3,
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Jadwal DolanYuk"),
      // ),
      body: jadwalList.isEmpty
          ? Center(
              child: Text("Belum ada jadwal."),
            )
          : ListView.builder(
              itemCount: jadwalList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Foto
                      Image.network(
                        jadwalList[index].photo,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Informasi Dolanan
                      ListTile(
                        title: Text(jadwalList[index].nama),
                      ),
                      // Alamat
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(jadwalList[index].alamat),
                      ),
                      // Nama Tempat
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text(jadwalList[index].lokasi),
                      ),
                      // Tanggal dan Jam
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                            "${jadwalList[index].tanggal} | ${jadwalList[index].jam}"),
                      ),
                      // Jumlah Pemain
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text("Jumlah Pemain: ${jadwalList[index].jumlahPemain}"),
                      ),
                      // Tombol Group Chat
                      ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika untuk akses group chat
                          // Misalnya, pindahkan pengguna ke halaman obrolan
                          // atau tampilkan dialog obrolan di sini.
                          // ...
                        },
                        child: Text("Group Chat"),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
