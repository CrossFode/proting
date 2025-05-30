import 'package:flutter/material.dart';
import 'package:tubes/Home/Historypage.dart';
import 'package:tubes/Home/Homepage.dart';
import 'package:tubes/Home/Profilepage.dart';
import 'package:tubes/sreens/login.dart';
import 'package:tubes/sreens/registrasi.dart';
import 'package:tubes/sreens/opening.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
// ignore: prefer_const_constructors
    return MaterialApp(
      title: 'Pangan Nusantara',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: Opening(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const Navbar(),
      },
    );
  }
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Homepage(),
    const HistoryPage(),
    const Profilepage(), // Profile page placeholder
  ];

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        onTap: _onItemClick,
        selectedLabelStyle: const TextStyle(
          fontSize: 12, // Ukuran font saat item dipilih
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10, // Ukuran font saat item tidak dipilih
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'HISTORY',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}
