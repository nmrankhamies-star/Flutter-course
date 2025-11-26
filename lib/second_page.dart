import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String data; // المتغير القادم من الصفحة الأولى

  SecondPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الصفحة الثانية")),
      body: Center(
        child: Text(
          "النص الذي تم استقباله: $data",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
