import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart'; // Para o player de áudio

class ObrasScreen extends StatelessWidget {
  final String salaId;

  const ObrasScreen({Key? key, required this.salaId}) : super(key: key);

  Future<List<Obra>> fetchObras() async {
    final apiUrl = 'http://10.0.2.2:8080/obras/sala/$salaId';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((obra) => Obra.fromJson(obra)).toList();
    } else {
      throw Exception('Failed to load obras');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
      ),
      body: FutureBuilder<List<Obra>>(
        future: fetchObras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Obra> obras = snapshot.data!;
            return ListView(
              children: obras.map((obra) => ObraCard(obra)).toList(),
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

class Obra {
  final String id;
  final String name;
  final String autor;
  final String description;
  final String image;
  final String audio;

  Obra({
    required this.id,
    required this.name,
    required this.autor,
    required this.description,
    required this.image,
    required this.audio,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      id: json['ID'],
      name: json['Name'],
      autor: json['Autor'],
      description: json['Description'],
      image: json['Image'],
      audio: json['Audio'],
    );
  }
}

class ObraCard extends StatelessWidget {
  final Obra obra;

  const ObraCard(this.obra, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(obra.image),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              obra.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              obra.autor,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(obra.description),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await audioPlayer.setUrl(obra.audio);
                        audioPlayer.play();
                      } catch (e) {
                        print('Error loading audio: $e');
                      }
                    },
                    child: const Text('Play Audio'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
