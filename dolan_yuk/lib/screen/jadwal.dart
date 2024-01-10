import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dolan_yuk/class/jadwalDolan.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dolan_yuk/screen/addjadwal.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  List<JadwalDolan> _jadwalList = [];
  String userId = "1";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/jadwal.php"),
        body: {'users_id': userId.toString()});
    if (response.statusCode == 200) {
      // print(response.body);
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
      for (var jad in json['data']) {
        print(jad);
        JadwalDolan jd = JadwalDolan.fromJson(jad);
        _jadwalList.add(jd);
      }
      setState(() {});
      // print(_jadwalList);
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
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
                        title:
                            Text("${_jadwalList[index].timestamp.toString()}"),
                      ),
                      // Jumlah Pemain
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text(
                            "1 / ${_jadwalList[index].jumlahPemain} orang"),
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
                      // Tombol Group Chat
                      ElevatedButton(
                        onPressed: () {
                          // Tambahkan logika untuk akses group chat
                          // Misalnya, pindahkan pengguna ke halaman obrolan
                          // atau tampilkan dialog obrolan di sini.
                          // ...
                        },
                        child: Text("Party Chat"),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
