import 'package:flutter/material.dart';
import 'screens/museums_screen.dart'; // Importando a tela MuseumsScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MuApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          const MuseumsScreen(), // Definindo MuseumsScreen como a tela inicial
    );
  }
}
