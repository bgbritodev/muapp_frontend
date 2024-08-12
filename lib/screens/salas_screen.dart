import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muapp_frontend/screens/obras_screen.dart';

class SalasScreen extends StatelessWidget {
  final String museumId;

  const SalasScreen({super.key, required this.museumId});

  Future<List<Sala>> fetchSalas() async {
    final apiUrl = "http://10.0.2.2:8080/salas/museu/$museumId";
    var result = await http.get(Uri.parse(apiUrl));

    if (result.statusCode == 200) {
      List jsonResponse = json.decode(result.body);
      print('Salas fetched successfully: $jsonResponse');
      return jsonResponse.map((sala) => Sala.fromJson(sala)).toList();
    } else {
      throw Exception('Failed to load salas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas'),
      ),
      body: FutureBuilder<List<Sala>>(
        future: fetchSalas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Sala> salas = snapshot.data!;
            return ListView(
              children: salas.map((sala) => SalaCard(sala)).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Sala {
  final String id;
  final String name;
  final String description;

  Sala({required this.id, required this.name, required this.description});

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      id: json['ID'] ?? '',
      name: json['Name'] ?? 'No name available',
      description: json['Description'] ?? 'No description available',
    );
  }
}

class SalaCard extends StatelessWidget {
  final Sala sala;

  const SalaCard(this.sala, {super.key});

  @override
  Widget build(BuildContext context) {
    print('SalaCard: ${sala.id}, ${sala.name}, ${sala.description}');

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              sala.name.isNotEmpty ? sala.name : 'No name available',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              sala.description.isNotEmpty
                  ? sala.description
                  : 'No description available',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObrasScreen(salaId: sala.id),
                  ),
                );
              },
              child: const Text('Ver Obras'),
            ),
          ),
        ],
      ),
    );
  }
}
