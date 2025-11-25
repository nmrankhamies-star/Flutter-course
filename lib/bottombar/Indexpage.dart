import 'Accountpage.dart';
import 'Homepage.dart';
import 'Settingpage.dart';
import 'package:flutter/material.dart';

import 'Searchpage.dart';

class Indexpage extends StatefulWidget {
  const Indexpage({super.key});

  @override
  State<Indexpage> createState() => _IndexpageState();
}

class _IndexpageState extends State<Indexpage> {
  int _bottomNavbar = 0;
  List<Widget> _pages = [
    Homepage(),
    Searchpage(),
    Settingpage(),
    Accountpage(),
  ];
  String _gettitle(int index) {
    switch (index) {
      case 0:
        return 'الصفحة الرئيسية';
      case 1:
        return 'صفحة البحث';
      case 2:
        return 'صفحة الاعدادات';
      case 3:
        return 'صفحة الحساب';
      default:
        return 'data';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gettitle(_bottomNavbar)),
        backgroundColor: Colors.blueGrey,
      ),
      body: IndexedStack(index: _bottomNavbar, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavbar,
        onTap: (index) {
          setState(() {
            _bottomNavbar = index;
          });
        },
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.blue[800],
        items: [
          BottomNavigationBarItem(label: 'الرئيسية', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'البحث', icon: Icon(Icons.search)),
          BottomNavigationBarItem(
            label: 'الاعدادات',
            icon: Icon(Icons.settings),
          ),
          BottomNavigationBarItem(
            label: 'الحساب',
            icon: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }
}
