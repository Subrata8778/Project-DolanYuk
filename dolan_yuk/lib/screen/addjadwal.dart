import 'package:flutter/material.dart';

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

  // Variabel untuk menyimpan pilihan dolan utama
  String selectedDolan = '';
  int minimalMember = 0; // Jumlah minimal member dari dolan utama

  // Data dummy untuk dropdown (anda dapat menggantinya dengan data dari API)
  List<String> dolanList = ['Dolan1', 'Dolan2', 'Dolan3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Jadwal Dolan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal Dolan'),
            TextFormField(
              controller: tanggalController,
              onTap: () {
                // Tampilkan date picker saat input tanggal di-tap
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((value) {
                  if (value != null) {
                    tanggalController.text =
                        value.toLocal().toString().split(' ')[0];
                  }
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Jam Dolan'),
            TextFormField(
              controller: jamController,
              onTap: () {
                // Tampilkan time picker saat input jam di-tap
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    jamController.text = value.format(context);
                  }
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Lokasi Dolan'),
            TextFormField(
              controller: lokasiController,
            ),
            SizedBox(height: 16.0),
            Text('Alamat Dolan'),
            TextFormField(
              controller: alamatController,
            ),
            SizedBox(height: 16.0),
            Text('Pilih Dolan Utama'),
            DropdownButton<String>(
              value: selectedDolan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDolan = newValue!;
                  // Anda dapat mengambil jumlah minimal member dari tabel dolanan berdasarkan selectedDolan
                  // minimalMember = fetchMinimalMember(selectedDolan);
                  // Secara sementara, set minimalMember ke 3 sebagai contoh
                  minimalMember = 3;
                });
              },
              items: dolanList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text('Minimal Member: $minimalMember'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan jadwal baru
                saveJadwal();
              },
              child: Text('Buat Jadwal'),
            ),
          ],
        ),
      ),
    );
  }

  // Implementasi fungsi untuk menyimpan jadwal baru
  void saveJadwal() {
    // Logika untuk menyimpan data jadwal ke database/API
    // ...

    // Secara otomatis pemain yang membuat jadwal ini menjadi anggota dari jadwal baru ini
    // ...

    // Kembali ke halaman sebelumnya setelah menyimpan jadwal
    Navigator.pop(context);
  }
}
