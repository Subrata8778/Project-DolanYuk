import 'package:dolan_yuk/screen/addjadwal.dart';
import 'package:dolan_yuk/screen/cari.dart';
import 'package:dolan_yuk/screen/gantipassword.dart';
import 'package:dolan_yuk/screen/jadwal.dart';
import 'package:dolan_yuk/screen/login.dart';
import 'package:dolan_yuk/screen/ngobrol.dart';
import 'package:dolan_yuk/screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  // prefs.setString("user_id", "");
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
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
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'addjadwal': (context) => AddJadwal(),
        'jadwal': (context) => JadwalScreen(),
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
  final List<Widget> _screens = [JadwalScreen(), Cari(), ProfileScreen()];

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
        title: Text("DolanYuk"),
      ),
      body: _screens[_currentIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Jadwal'),
              leading: Icon(Icons.calendar_month),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Cari'),
              leading: Icon(Icons.search_sharp),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              title: Text('Profil'),
              leading: Icon(Icons.person),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
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
