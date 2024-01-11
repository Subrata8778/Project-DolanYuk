import 'package:dolan_yuk/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:dolan_yuk/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String active_user = "";

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Register(),
      routes: {
        'login': (context) => MyLogin(),
      },
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<Register> {
  String _nama = '';
  String _email = '';
  String _password = '';
  String _re_password = '';
  String error_login = '';

  void doRegister() async {
    if (_nama != "" && _email != "" && _password != "" && _re_password != "") {
      if (_password == _re_password) {
        final response = await http.post(
            Uri.parse(
                "https://ubaya.me/flutter/160420002/DolanYuk/register.php"),
            body: {
              'nama': _nama,
              'email': _email,
              'photo':
                  "https://static.wikia.nocookie.net/larva-animation/images/6/6a/BrownPose.png/revision/latest?cb=20210418181805",
              'user_password': _password
            });
        if (response.statusCode == 200) {
          Map json = jsonDecode(response.body);
          if (json['result'] == 'success') {
            showDialogMsg(
                "Yeay, Berhasil Signup!", "Silahkan login dengan akun Anda..");
            Navigator.pushReplacementNamed(context, "login");
          } else {
            showDialogMsg(
                "Gagal Signup!", "Pastikan semua isian terisi dengan benar!");
            setState(() {
              error_login = "Gagal register";
            });
          }
        } else {
          throw Exception('Failed to read API');
        }
      } else {
        showDialogMsg("Gagal Signup!",
            "Pastikan password dan ulangi password berisi sama!");
      }
    } else {
      showDialogMsg(
          "Gagal Signup!", "Pastikan semua isian terisi dengan benar!");
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
          height: 500,
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
                  _nama = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap anda disini'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  _email = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Masukkan email anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                  _password = v;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Masukkan Password'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                  _re_password = v;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ulangi Password',
                    hintText: 'Ulangi Password Anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: Colors.deepPurple, width: 2),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "login");
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text(
                        'Kembali',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        doRegister();
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepPurple),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text(
                        'Sign Up',
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
