import 'package:dolan_yuk/class/jadwalDolan.dart';
import 'package:dolan_yuk/class/dolan.dart';
import 'package:dolan_yuk/main.dart';
import 'package:dolan_yuk/screen/jadwal.dart';
import 'package:flutter/material.dart';
import 'package:dolan_yuk/screen/addjadwal.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddJadwal extends StatefulWidget {
  @override
  _AddJadwalState createState() => _AddJadwalState();
}

class _AddJadwalState extends State<AddJadwal> {
  // Controller untuk mengelola input dari pengguna
  TextEditingController tanggalController = TextEditingController();
  TextEditingController jamController = TextEditingController();
  TextEditingController lokasiController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  late DateTime dtPicker;
  late TimeOfDay tPicker;

  // Variabel untuk menyimpan pilihan dolan utama
  String selectedDolan = '';
  int minimalMember = 0; // Jumlah minimal member dari dolan utama

  // Data dummy untuk dropdown (anda dapat menggantinya dengan data dari API)
  List<Dolan> dolanList = [];

  // Initialize minimalMemberList
  List<int> minimalMemberList = [];

  //Ambil userId user saat ini.
  String userId = "";

  Future<String> checkUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  Future<List> daftarDolan() async {
    Map json;
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/dolan.php"),
    );
    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception('Failed to read API');
    }
  }

  void addJadwal() async {
    DateTime combinedDateTime = DateTime(
      dtPicker.year,
      dtPicker.month,
      dtPicker.day,
      tPicker.hour,
      tPicker.minute,
    );

    dateTimeController.text = combinedDateTime.toLocal().toString();

    // Temukan indeks objek Dolan yang sesuai dengan nama yang dipilih
    int selectedDolanIndex =
        dolanList.indexWhere((dolan) => dolan.nama == selectedDolan);

    // Gunakan objek Dolan yang sesuai atau objek default jika tidak ditemukan
    Dolan selectedDolanObj = selectedDolanIndex != -1
        ? dolanList[selectedDolanIndex]
        : Dolan(id: 0, nama: '', jumlah_minimal: 0, photo: '');
    print(selectedDolanObj.id);

    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/addjadwal.php"),
        body: {
          // 'tanggal': tanggal.toUtc().toString().split('.')[0],
          'tanggal': dateTimeController.text,
          'lokasi': lokasiController.text,
          'alamat': alamatController.text,
          'users_id': userId,
          'dolans_id': selectedDolanObj.id.toString(),
          'jadwals_id': selectedDolanIndex.toString(),
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
        // Navigator.of(context).pop();
        // Navigator.pushNamed(context, 'jadwal');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JadwalScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  Future<void> loadDolanList() async {
    try {
      List<dynamic> data = await daftarDolan();
      if (data.isNotEmpty) {
        setState(() {
          dolanList = data.map<Dolan>((item) => Dolan.fromJSON(item)).toList();
          minimalMemberList =
              dolanList.map<int>((dolan) => dolan.jumlah_minimal).toList();
          minimalMember = dolanList.first.jumlah_minimal;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Dolan data available')),
        );
      }
    } catch (e) {
      print('Error loading dolan list: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future<String> userOnly = checkUser();
    userOnly.then((value) {
      userId = value;
      loadDolanList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Jadwal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: tanggalController,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((value) {
                    if (value != null) {
                      dtPicker = value;
                      tanggalController.text =
                          value.toLocal().toString().split(' ')[0];
                    }
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tanggal Dolan',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: jamController,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      tPicker = value;
                      jamController.text = value.format(context);
                    }
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Jam Dolan',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: lokasiController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Lokasi Dolan',
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alamat Dolan',
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButton<Dolan>(
                value: dolanList.firstWhere(
                    (dolan) => dolan.nama == selectedDolan,
                    orElse: () => dolanList.first),
                onChanged: (Dolan? newValue) {
                  setState(() {
                    selectedDolan = newValue!.nama;
                    int selectedDolanIndex = dolanList.indexOf(newValue);
                    minimalMember = (selectedDolanIndex >= 0)
                        ? minimalMemberList[selectedDolanIndex]
                        : 0;
                  });
                },
                items: dolanList.isNotEmpty
                    ? dolanList.map<DropdownMenuItem<Dolan>>((Dolan dolan) {
                        return DropdownMenuItem<Dolan>(
                          value: dolan,
                          child: Text(dolan.nama),
                        );
                      }).toList()
                    : [],
              ),
              SizedBox(height: 16.0),
              Text('Minimal Member: $minimalMember'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addJadwal();
                },
                child: Text('Buat Jadwal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
