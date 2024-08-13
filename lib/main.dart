import 'package:flutter/material.dart';
import 'screens/home_page.dart'; // Importa a nova tela

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(), // Define HomePage como a tela inicial
    );
  }
}
