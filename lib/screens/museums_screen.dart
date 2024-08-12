import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:muapp_frontend/screens/salas_screen.dart';

class MuseumsScreen extends StatelessWidget {
  final String apiUrl = "http://10.0.2.2:8080/allmuseus";

  const MuseumsScreen({Key? key}) : super(key: key);

  Future<List<Museum>> fetchMuseums() async {
    var result = await http.get(Uri.parse(apiUrl));
    if (result.statusCode == 200) {
      List jsonResponse = json.decode(result.body);
      return jsonResponse.map((museum) => Museum.fromJson(museum)).toList();
    } else {
      throw Exception('Failed to load museums');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Museus'),
      ),
      body: FutureBuilder<List<Museum>>(
        future: fetchMuseums(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Museum> museums = snapshot.data!;
            return ListView(
              children: museums.map((museum) => MuseumCard(museum)).toList(),
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

class Museum {
  final String id;
  final String name;
  final String location;
  final String description;
  final String image;

  Museum({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.image,
  });

  factory Museum.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();
    return Museum(
      id: json['ID'] ?? '',
      name: unescape.convert(json['Name'] ?? ''),
      location: unescape.convert(json['Location'] ?? ''),
      description: unescape.convert(json['Description'] ?? ''),
      image: json['Image'] ?? '',
    );
  }
}

class MuseumCard extends StatelessWidget {
  final Museum museum;

  const MuseumCard(this.museum, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(museum.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(museum.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(museum.location, style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(museum.description),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Logando o ID do museu antes de navegar
                print('Navigating to SalasScreen with museumId: ${museum.id}');
                // Navegar para a tela de Salas e passar o ID do museu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SalasScreen(museumId: museum.id),
                  ),
                );
              },
              child: const Text('Ver Salas'),
            ),
          ),
        ],
      ),
    );
  }
}
