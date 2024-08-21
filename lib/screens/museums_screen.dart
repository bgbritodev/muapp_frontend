import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:muapp_frontend/screens/salas_screen.dart';

class MuseumsScreen extends StatelessWidget {
  final String apiUrl = "http://10.0.2.2:8080/museus/all";

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
    //final unescape = HtmlUnescape();
    return Museum(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
      location: json['Location'] ?? '',
      description: json['Description'] ?? '',
      image: json['Image'] ?? '',
    );
  }
}

class MuseumCard extends StatelessWidget {
  final Museum museum;

  const MuseumCard(this.museum, {super.key});

  @override
  Widget build(BuildContext context) {
    // Função para tratar entidades HTML e valores nulos
    String decodeHtmlEntities(String? html) {
      if (html == null) return '';
      // Decodifica caracteres especiais HTML
      return html
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .replaceAll('&amp;', '&')
          .replaceAll('&quot;', '"')
          .replaceAll('&apos;', "'");
    }

    // Decodifica caracteres especiais no texto e fornece valores padrão para valores nulos
    final decodedName =
        decodeHtmlEntities(museum.name) ?? 'Nome não disponível';
    final decodedLocation =
        decodeHtmlEntities(museum.location) ?? 'Localização não disponível';
    final decodedDescription =
        decodeHtmlEntities(museum.description) ?? 'Descrição não disponível';

    // Adiciona logs para depuração
    print('API Response:');
    print('Name: ${museum.name}');
    print('Location: ${museum.location}');
    print('Description: ${museum.description}');
    print('Decoded Name: $decodedName');
    print('Decoded Location: $decodedLocation');
    print('Decoded Description: $decodedDescription');

    return GestureDetector(
      onTap: () {
        // Logando o ID do museu antes de navegar
        print('Navigating to SalasScreen with museumId: ${museum.id}');
        // Navegar para a tela de Salas e passar o ID do museu
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalasScreen(
                museumId: museum.id,
                museumName: museum.name, // Passando o nome do museu
                museumDescription:
                    museum.description, // Passando a descrição do museu
                museumImageUrl:
                    museum.image, // Passando a URL da imagem do museu),
              ),
            ));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        child: SizedBox(
          height: 300, // Defina uma altura fixa para teste
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      16.0), // Arredonda os cantos da imagem
                  child: Image.network(
                    museum.image ?? 'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // Adiciona um gradiente ao fundo do Container
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.7)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        decodedName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        decodedDescription,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white, width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              decodedLocation,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
