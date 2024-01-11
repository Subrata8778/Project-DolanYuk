import 'package:flutter/material.dart';
import 'package:dolan_yuk/main.dart';
import 'package:dolan_yuk/screen/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String active_user = "";

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Login(),
      routes: {
        'singup': (context) => SignUp(),
      },
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';
  String error_login = '';

  void doLogin() async {
    if (_email != "" && _password != "") {
      final response = await http.post(
          Uri.parse("https://ubaya.me/flutter/160420002/DolanYuk/login.php"),
          body: {'email': _email, 'user_password': _password});
      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (json['result'] == 'success') {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString("user_id", json['data']['id'].toString());
          main();
        } else {
          showDialogMsg("Gagal Login!", "Pastikan email dan password sesuai!");
          setState(() {
            error_login = "Incorrect user or password";
          });
        }
      } else {
        throw Exception('Failed to read API');
      }
    } else {
      showDialogMsg("Gagal Login!", "Pastikan email dan password terisi dengan benar!");
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
          height: 350,
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
                  _email = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Masukkan valid email seperti abc@gmail.com'),
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
                    hintText: 'Masukkan Password anda'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.deepPurple, fontSize: 18),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        doLogin();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        elevation: MaterialStateProperty.all<double>(0),
                      ),
                      child: Text(
                        'Sign In',
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
