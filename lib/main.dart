import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: FirstPage());
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TextField Task")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: text1,
              decoration: InputDecoration(labelText: "الحقل الأول"),
            ),

            SizedBox(height: 20),

            TextField(
              controller: text2,
              decoration: InputDecoration(labelText: "الحقل الثاني"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                text2.text = text1.text; // نسخ النص
              },
              child: Text("ضع النص في الحقل الثاني"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(data: text1.text),
                  ),
                );
              },
              child: Text("انتقال إلى صفحة أخرى"),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String data;

  SecondPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الصفحة الثانية")),
      body: Center(
        child: Text("النص المستلم: $data", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
