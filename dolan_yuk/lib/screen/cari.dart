import 'package:dolan_yuk/class/jadwalDolan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Cari extends StatefulWidget {
  @override
  _CariState createState() => _CariState();
}

class _CariState extends State<Cari> {
  List<JadwalDolan> _jadwalList = [];
  String userId = "";
  TextEditingController searchController = TextEditingController();

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  Future<List> cariJadwal() async {
    Map json;
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/carijadwal.php"),
        body: {'users_id': userId});
    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> loadJadwalList() async {
    try {
      List<dynamic> data = await cariJadwal();
      print(data);
      setState(() {
        _jadwalList = data
            .map<JadwalDolan>((item) => JadwalDolan.fromJson(item))
            .toList();
      });
    } catch (e) {
      print('Error loading jadwal list: $e');
    }
  }

  void Join(String jadwalsId) async {
    // Pastikan bahwa objek JadwalDolan yang ditemukan memiliki data yang valid
    if (jadwalsId != null) {
      try {
        final response = await http.post(
          Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/join.php"),
          body: {
            'users_id': userId,
            'jadwals_id': jadwalsId,
          },
        );

        if (response.statusCode == 200) {
          Map json = jsonDecode(response.body);
          if (json['result'] == 'success') {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Berhasil Bergabung pada Jadwal')),
            );
            // Refresh list setelah berhasil join
            setState(() {
              loadJadwalList();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Gagal Bergabung pada Jadwal')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.reasonPhrase}')),
          );
          print('HTTP Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan')),
        );
        print('Error: $e');
      }
    } else {
      print('JadwalDolan not found for id: $jadwalsId');
    }
  }

  void searchJadwal(String keyword) async {
    // Melakukan pencarian berdasarkan nama dolan
    try {
      final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/carijadwal.php"),
        body: {
          'users_id': userId,
          'keyword': keyword,
        },
      );

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        setState(() {
          _jadwalList = json['data']
              .map<JadwalDolan>((item) => JadwalDolan.fromJson(item))
              .toList();
        });
      } else {
        throw Exception('Failed to read API');
      }
    } catch (e) {
      print('Error searching jadwal: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future<String> userOnly = checkUser();
    userOnly.then((value) {
      userId = value;
      loadJadwalList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                // Memanggil metode pencarian ketika nilai berubah
                searchJadwal(value);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _jadwalList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(children: [
                    // Foto
                    Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_jadwalList[index].photo),
                            fit: BoxFit.cover,
                          ),
                          // shape: BoxShape.circle,
                        )),
                    // Informasi Dolanan
                    ListTile(
                      title: Text(
                        _jadwalList[index].nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Tanggal dan Jam
                    ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text("${_jadwalList[index].timestamp.toString()}"),
                    ),
                    // Jumlah Pemain
                    ElevatedButton(
                      onPressed: () {
                        // _tampilkanAnggotaBergabung(_jadwalList[index]);
                      },
                      child: Text('Daftar Anggota'),
                    ),
                    ListTile(
                      leading: Icon(Icons.group),
                      title:
                          Text("1 / ${_jadwalList[index].jumlahPemain} orang"),
                    ),
                    // Nama Tempat
                    ListTile(
                      leading: Icon(Icons.house),
                      title: Text(_jadwalList[index].lokasi),
                    ),
                    // Alamat
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text(_jadwalList[index].alamat),
                    ),
                    SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        Join(_jadwalList[index].id.toString());
                        print(_jadwalList[index].id.toString());
                      },
                      child: Text('Join'),
                    ),
                  ]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _tampilkanAnggotaBergabung(JadwalDolan jadwal) {
    // Implementasi untuk menampilkan anggota yang telah bergabung
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Anggota yang Telah Bergabung'),
          content: Column(
            children: [
              Text(
                  '1 member bergabung dari total {jadwal.minimalMember} minimal member'),
              // Tampilkan daftar anggota yang telah bergabung di sini
              // ...
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
