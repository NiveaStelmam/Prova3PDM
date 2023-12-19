import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';

class TelaSoltarPokemon extends StatefulWidget {
  final int id;
  final PokemonDao dao;

  TelaSoltarPokemon({Key? key, required this.id, required this.dao})
      : super(key: key);

  late Future<List<Pokemon>> capturedPokemonList;

  @override
  State<TelaSoltarPokemon> createState() => _TelaSoltarPokemonState();
}

class _TelaSoltarPokemonState extends State<TelaSoltarPokemon> {
  @override
  Widget build(BuildContext context) {
    Stream<Pokemon?> _pokemonStream = widget.dao.findPokemonById(widget.id);

    return StreamBuilder<Pokemon?>(
      stream: _pokemonStream,
      builder: (context, AsyncSnapshot<Pokemon?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          double _height_cm = snapshot.data!.altura / 10;
          double _weight_kg = snapshot.data!.peso / 10;
          Pokemon _pokemon = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text("Soltar Pokemon"),
              backgroundColor: Colors.deepOrange.shade800,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    _pokemon.imageUrl, // Adicione a URL da imagem aqui
                    width: 300,
                    height: 200,
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
                      SizedBox(width: 8),
                      Text("${snapshot.data!.nome}"),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Altura:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${_height_cm}cm"),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Peso:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text("${_weight_kg}kg"),
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
                    height: 8,
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
                    height: 8,
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
                    height: 8,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Colors.red), // cor antiga - Colors.red.shade300
                          minimumSize: MaterialStatePropertyAll(Size(54, 48)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors
                              .green), // cor antiga - Colors.green.shade200
                          minimumSize: MaterialStatePropertyAll(Size(54, 48)),
                        ),
                        onPressed: () {
                          widget.dao.deletePokemon(_pokemon).then((_) {
                            setState(() {
                              // Atualizar a lista de Pokémon capturados
                              widget.capturedPokemonList =
                                  widget.dao.findAllPokemons();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Pokemon solto!')),
                            );
                            Navigator.pop(context, widget.capturedPokemonList);
                          }).catchError((error) {
                            print('Erro ao deletar o Pokémon: $error');
                            // Lógica para tratar o erro, se necessário
                          });
                        },
                        child: Text("Confirmar"),
                      ),
                    ],
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
