import 'package:dolan_yuk/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:dolan_yuk/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GantiPassword extends StatefulWidget {
  const GantiPassword({super.key});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  String _password = '';
  String _new_password = '';
  String _new_password_check = '';
  String error_login = '';
  String userId = "";

  Future<void> doLogOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", "");
    main();
  }

  @override
  void initState() {
    super.initState();
    Future<String> userOnly = checkUser();
    userOnly.then((value) {
      userId = value;
    });
  }

  void doUpdate() async {
    if (_new_password != "" && _password != "") {
      if (_new_password == _new_password_check) {
        final response = await http.post(
            Uri.parse(
                "https://ubaya.me/flutter/160420002/DolanYuk/updatePassword.php"),
            body: {
              'password': _password,
              'new_password': _new_password,
              'user_id': userId
            });
        if (response.statusCode == 200) {
          Map json = jsonDecode(response.body);
          if (json['result'] == 'success') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            showDialogMsg("Berhasil Update!", "Ganti password berhasil!");
          } else {
            showDialogMsg("Gagal Update!", "Pastikan password sesuai!");
            setState(() {
              error_login = "Incorrect user or password";
            });
          }
        } else {
          throw Exception('Failed to read API');
        }
      } else {
        showDialogMsg("Gagal Update!", "Password pengulangan salah!");
      }
    } else {
      showDialogMsg("Gagal Update!",
          "Pastikan password dan password baru Anda terisi dengan benar!");
    }
  }

  void showDialogMsg(String judul, String pesan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(judul),
          content: Text(pesan),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          height: 400,
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              border: Border.all(width: 1),
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 20)]),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  _password = v;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password Lama',
                    hintText: 'Masukkan password lama Anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                  _new_password = v;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password Baru',
                    hintText: 'Masukkan Password Baru Anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                  _new_password_check = v;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Re-Type Password Baru',
                    hintText: 'Ulangi Password Baru Anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        doUpdate();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text(
                        'Ganti Password',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}
