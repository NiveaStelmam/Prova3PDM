import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';

class TelaDetalhesPokemon extends StatefulWidget {
  final int id;
  final PokemonDao dao;

  TelaDetalhesPokemon({Key? key, required this.id, required this.dao})
      : super(key: key);

  @override
  State<TelaDetalhesPokemon> createState() => _TelaDetalhesPokemonState();
}

class _TelaDetalhesPokemonState extends State<TelaDetalhesPokemon> {
  @override
  Widget build(BuildContext context) {
    Stream<Pokemon?> pokemon = widget.dao.findPokemonById(widget.id);

    return StreamBuilder<Pokemon?>(
      stream: pokemon,
      builder: (context, AsyncSnapshot<Pokemon?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          double height_cm = snapshot.data!.altura / 10;
          double weight_kg = snapshot.data!.peso / 10;
          return Scaffold(
            appBar: AppBar(
              title: Text("Detalhes do Pokemon"),
              backgroundColor: Colors.deepOrange.shade800,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    snapshot.data!.imageUrl, // Adicione a URL da imagem aqui
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nome:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 1),
                      Text("${snapshot.data!.nome}"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Altura:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${height_cm}cm"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Peso:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${weight_kg}kg"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tipo:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${snapshot.data!.tipo}"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Habilidades:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${snapshot.data!.habilidades}"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Experiência Base:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${snapshot.data!.experiencia}"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Forma:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${snapshot.data!.forma}"),
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Text("Erro ao carregar seu Pokémon");
        }
      },
    );
  }
}
