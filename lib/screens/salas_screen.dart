import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muapp_frontend/screens/obras_screen.dart';

class SalasScreen extends StatelessWidget {
  final String museumId;
  final String museumName; // Nome do museu
  final String museumDescription; // Descrição do museu
  final String museumImageUrl; // URL da imagem do museu

  const SalasScreen({
    super.key,
    required this.museumId,
    required this.museumName,
    required this.museumDescription,
    required this.museumImageUrl,
  });

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
      body: Stack(
        children: [
          // Imagem de fundo do museu
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    museumImageUrl), // Usando a URL da imagem do museu
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Retângulo branco com título, descrição e cards
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(0.9), // Cor branca com opacidade
                borderRadius:
                    BorderRadius.circular(15.0), // Cantos arredondados
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título do museu
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                    child: Text(
                      museumName,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Descrição do museu
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 8.0, right: 16.0),
                    child: Text(
                      museumDescription,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 16.0), // Espaço entre a descrição e os cards
                  // Listagem de salas
                  Expanded(
                    child: FutureBuilder<List<Sala>>(
                      future: fetchSalas(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Sala> salas = snapshot.data!;
                          return ListView(
                            padding: const EdgeInsets.only(
                                bottom: 0), // Sem padding inferior
                            children:
                                salas.map((sala) => SalaCard(sala)).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObrasScreen(salaId: sala.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        color: const Color.fromARGB(255, 0, 83, 151), // Fundo azul
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                sala.name.isNotEmpty ? sala.name : 'No name available',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
              subtitle: Text(
                sala.description.isNotEmpty
                    ? sala.description
                    : 'No description available',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white, // Texto branco
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
