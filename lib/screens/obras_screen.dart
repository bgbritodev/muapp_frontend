import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:just_audio/just_audio.dart';
import 'package:animated_icon/animated_icon.dart'; // Importa o pacote animated_icon

class ObrasScreen extends StatelessWidget {
  final String salaId;
  final String salaTitulo; // Novo parâmetro para o título da sala
  final String salaDescricao; // Novo parâmetro para a descrição da sala

  const ObrasScreen({
    Key? key,
    required this.salaId,
    required this.salaTitulo, // Adiciona os parâmetros no construtor
    required this.salaDescricao, // Adiciona os parâmetros no construtor
  }) : super(key: key);

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              salaTitulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              salaDescricao,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
              height: 16.0), // Espaçamento entre a descrição e a lista de obras
          Expanded(
            child: FutureBuilder<List<Obra>>(
              future: fetchObras(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Obra> obras = snapshot.data!;
                  return ListView(
                    children:
                        obras.map((obra) => ObraCard(obra: obra)).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
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

class ObraCard extends StatefulWidget {
  final Obra obra;

  const ObraCard({Key? key, required this.obra}) : super(key: key);

  @override
  _ObraCardState createState() => _ObraCardState();
}

class _ObraCardState extends State<ObraCard> {
  bool _isExpanded = false;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    final double cardHeight = MediaQuery.of(context).size.height * 0.6;

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 5,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              widget.obra.image,
              width: double.infinity,
              height: cardHeight,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.obra.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.obra.autor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    _isExpanded
                        ? widget.obra.description
                        : widget.obra.description.length > 100
                            ? '${widget.obra.description.substring(0, 100)}...'
                            : widget.obra.description,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: _isExpanded ? null : 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Read More' : 'Read Less',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                          if (_isPlaying) {
                            try {
                              await audioPlayer.setUrl(widget.obra.audio);
                              audioPlayer.play();
                            } catch (e) {
                              print('Error loading audio: $e');
                            }
                          } else {
                            audioPlayer.stop();
                          }
                        },
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _isPlaying
                              ? AlwaysStoppedAnimation(1.0)
                              : AlwaysStoppedAnimation(0.0),
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Tocar áudio descrição',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 18),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
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
