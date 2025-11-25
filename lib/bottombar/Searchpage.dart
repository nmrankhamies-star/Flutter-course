import 'package:flutter/material.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 30, color: Colors.grey),
          SizedBox(height: 20),
          Text('البحث', style: TextStyle(fontSize: 24, color: Colors.grey)),
        ],
      ),
    );
  }
}
