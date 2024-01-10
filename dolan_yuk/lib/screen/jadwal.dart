import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dolan_yuk/class/jadwalDolan.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class JadwalScreen extends StatefulWidget {
  @override
  _JadwalScreenState createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  List<JadwalDolan> _jadwalList = [];
  String userId = "1";

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("http://ubaya.me/flutter/160420002/DolanYuk/jadwal.php"),
        body: {'users_id': userId});
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
      for (var jad in json['data']) {
        JadwalDolan jd = JadwalDolan.fromJson(jad);
        _jadwalList.add(jd);
      }
      setState(() {});
      print(_jadwalList);
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
                      Image.network(
                        _jadwalList[index].photo,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      // Informasi Dolanan
                      ListTile(
                        title: Text(_jadwalList[index].nama),
                      ),
                      // Alamat
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text(_jadwalList[index].alamat),
                      ),
                      // Nama Tempat
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text(_jadwalList[index].lokasi),
                      ),
                      // Tanggal dan Jam
                      ListTile(
                        leading: Icon(Icons.calendar_today),
                        title: Text(
                            "${DateFormat.yMd().format(_jadwalList[index].timestamp)} | ${DateFormat.Hm().format(_jadwalList[index].timestamp)}"),
                      ),
                      // Jumlah Pemain
                      ListTile(
                        leading: Icon(Icons.group),
                        title: Text(
                            "Jumlah Pemain: ${_jadwalList[index].jumlahPemain}"),
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
