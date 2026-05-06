import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 201, 65, 47),
          title: const Text('App Bar'),
        ),
        body: Container(child: const Text('Hi there')),
      ),
    );
  }
}
