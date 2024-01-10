import 'package:dolan_yuk/screen/addjadwal.dart';
import 'package:dolan_yuk/screen/cari.dart';
import 'package:dolan_yuk/screen/jadwal.dart';
import 'package:dolan_yuk/screen/profil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'addjadwal': (context) => AddJadwal(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _currentIndex = 0;
  final List<Widget> _screens = [JadwalScreen(), Cari(), Profil()];
  final List<String> _title = ['DolanYuk', 'Cari', 'Profil'];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_title[_currentIndex]),
      ),
      body: _screens[_currentIndex],
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddJadwal()),
                );
              },
              tooltip: 'Tambah Jadwal',
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          fixedColor: Colors.teal,
          items: [
            BottomNavigationBarItem(
              label: "Jadwal",
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(
              label: "Cari",
              icon: Icon(Icons.search_sharp),
            ),
            BottomNavigationBarItem(
              label: "Profil",
              icon: Icon(Icons.person),
            ),
          ],
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
