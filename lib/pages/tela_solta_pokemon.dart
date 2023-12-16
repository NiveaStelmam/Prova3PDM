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
              title: Text("Detalhes do Pokemon"),
              backgroundColor: Colors.purple,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    _pokemon.imageUrl, // Adicione a URL da imagem aqui
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text("Nome: ${_pokemon.nome}"),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Altura: ${_height_cm}cm"),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Peso: ${_weight_kg}kg"),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Tipo: ${_pokemon.tipo}"),
                  SizedBox(
                    height: 36,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red.shade300),
                          minimumSize: MaterialStatePropertyAll(Size(54, 48)),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.green.shade200),
                          minimumSize: MaterialStatePropertyAll(Size(54, 48)),
                        ),
                        onPressed: () {
                          widget.dao.deletePokemon(_pokemon);
                          setState(() {
                            widget.capturedPokemonList =
                                widget.dao.findAllPokemons();
                          });
                          Navigator.pop(context);
                          SnackBar(
                            content: Text("Pokemon solto!"),
                          );
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
