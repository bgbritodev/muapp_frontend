import 'package:flutter/material.dart';
//import 'screens/home_page.dart'; // Importa a tela HomePage
import 'screens/login_screen.dart'; // Importa a tela de LoginScreen

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
      home: LoginScreen(), // Define LoginScreen como a tela inicial
    );
  }
}
//testing the new branch