import 'package:dolan_yuk/screen/ngobrol.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dolan_yuk/class/jadwalDolan.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dolan_yuk/screen/addjadwal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  List<JadwalDolan> _jadwalList = [];
  String userId = "";

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/jadwal.php"),
        body: {'users_id': userId.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    _jadwalList.clear();
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      print(json['data']);
      for (var jad in json['data']) {
        JadwalDolan jd = JadwalDolan.fromJson(jad);
        _jadwalList.add(jd);
      }
      setState(() {});
    });
  }

  void tampilkanAnggotaBergabung(String jadwalsId) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160420002/DolanYuk/memberdolan.php"),
        body: {
          'jadwals_id': jadwalsId,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          List<Map<String, dynamic>> anggotaList = List.from(json['data']);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  children: [
                    Text('Konco Dolanan'),
                    Text(
                        'Member bergabung: ${anggotaList.length}/${anggotaList[0]['jumlah_minimal']}'),
                    ...anggotaList.map(
                      (anggota) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(anggota['photo']),
                        ),
                        title: Text(
                          anggota['users_id'] == userId
                              ? '${anggota['nama']} (You)'
                              : anggota['nama'],
                        ),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Keren!'),
                  ),
                ],
              );
            },
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mendapatkan data anggota bergabung'),
            ),
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
  }

  @override
  void initState() {
    super.initState();
    Future<String> userOnly = checkUser();
    userOnly.then((value) {
      userId = value;
      bacaData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _jadwalList.isEmpty
          ? Center(
              child: Text("Belum ada jadwal."),
            )
          : ListView.builder(
              itemCount: _jadwalList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(_jadwalList[index].photo),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                        title: Text(
                          "${DateFormat('dd-MM-yyyy').format(_jadwalList[index].timestamp)}",
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.punch_clock),
                        title: Text(
                          "${DateFormat('HH:mm').format(_jadwalList[index].timestamp)}",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                            // Jumlah Pemain
                            ElevatedButton(
                          onPressed: () {
                            tampilkanAnggotaBergabung(
                              _jadwalList[index].id.toString(),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.car_rental_outlined),
                              SizedBox(width: 8.0),
                              Text(
                                "${_jadwalList[index].banyakPemain} / ${_jadwalList[index].jumlahPemain} orang",
                              ),
                            ],
                          ),
                        ),
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
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child:
                            // Tombol Group Chat
                            Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Ngobrol(
                                      _jadwalList[index].id.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Party Chat"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
