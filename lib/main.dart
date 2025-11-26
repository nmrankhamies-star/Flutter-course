import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Amiri',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const HomePage(),
    );
  }
}

// صفحة رئيسية تحتوي على BottomNavigationBar
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = [
    const Center(
      child: Text('الصفحة الرئيسية', style: TextStyle(fontSize: 24)),
    ),
    const Center(child: Text('صفحة البحث', style: TextStyle(fontSize: 24))),
    const Center(child: Text('صفحة الاعدادات', style: TextStyle(fontSize: 24))),
    const Center(child: Text('صفحة الحساب', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'بحث'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }
}