import 'package:flutter/material.dart';
import 'museums_screen.dart'; // Importa a tela de listagem de museus

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.network(
              'https://www.aen.pr.gov.br/sites/default/arquivos_restritos/files/imagem/2022-07/credito_-_lucas_pontes.jpg', // Substitua pela URL da imagem de fundo
              fit: BoxFit.cover,
            ),
          ),
          // Texto sobre a imagem
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Center(
              child: Text(
                'Descubra sua próxima viagem cultural',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.7),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Caixa com a tela de listagem de museus
          Positioned(
            bottom: 0,
            left: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16.0), // Arredondar as bordas
              ),
              clipBehavior:
                  Clip.hardEdge, // Adiciona o comportamento de recorte
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.6, // Ajuste o tamanho da caixa
                child: const MuseumsScreen(), // Tela de listagem de museus
              ),
            ),
          ),
        ],
      ),
    );
  }
}
