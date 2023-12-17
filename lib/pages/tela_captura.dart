import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';

class TelaCaptura extends StatefulWidget {
  final PokemonDao pokemonDao;
  const TelaCaptura({Key? key, required this.pokemonDao}) : super(key: key);

  @override
  State<TelaCaptura> createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  late List<int> sorteios;
  late Future<List<Pokemon>> pokemonListAPI;
  late Future<List<Pokemon>> pokemonCapturados;

  late bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _verificarConexao();
    pokemonListAPI = _sortearPokemons();
    pokemonCapturados = widget.pokemonDao.findAllPokemons();
  }

  Future<void> _verificarConexao() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
      pokemonListAPI = _sortearPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pokemonListAPI,
      builder: (context, snapshot) {
        return snapshot.hasData && isConnected
            ? Scaffold(
                body: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return PokemonItem(
                    pokemon: snapshot.data![index],
                    dao: widget.pokemonDao,
                  );
                },
              ))
            : !isConnected
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Sem conexão com a internet. Conecte-se para visualizar os Pokémons.'),
                        SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () => _verificarConexao(),
                            child: Text("Atualize a conexão"),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.purple))),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
      },
    );
  }

  Future<List<Pokemon>> _sortearPokemons() async {
    List<Pokemon> pokemonSorteio = [];
    sorteios = List.generate(6, (index) => Random().nextInt(1018));

    for (int id in sorteios) {
      final response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> pokemonData = json.decode(response.body);
        final int id = pokemonData['id'];
        final String nome = pokemonData['name'];
        final String imageUrl = pokemonData['sprites']['front_default'];
        final int peso = pokemonData['weight'];
        final int altura = pokemonData['height'];
        final String tipo = pokemonData['types'][0]['type']['name'];

        Pokemon pokemon = Pokemon(
            id: id,
            nome: nome,
            imageUrl: imageUrl,
            peso: peso,
            altura: altura,
            tipo: tipo);
        pokemonSorteio.add(pokemon);
      } else {
        print('Erro ao obter dados do Pokémon $id');
      }
    }

    return pokemonSorteio;
  }
}

class PokemonItem extends StatefulWidget {
  final Pokemon pokemon;
  final PokemonDao dao;

  PokemonItem({Key? key, required this.pokemon, required this.dao})
      : super(key: key);

  @override
  State<PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<PokemonItem> {
  Color _colorButton = Colors.purple;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // sombra do card
      margin: EdgeInsets.all(8), // margem ao redor do card
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // preenchimento interno ao ListTile
        title: Text(
          widget.pokemon.nome,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8), // espaço entre o título e os detalhes
            Text('ID: ${widget.pokemon.id}'),
          ],
        ),
        leading: Image.network(
          widget.pokemon.imageUrl,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        trailing: ElevatedButton(
          onPressed: () {
            widget.dao.insertPokemon(widget.pokemon);
            setState(() {
              _colorButton = Colors.grey;
            });
          },
          child: Icon(Icons.catching_pokemon),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(_colorButton),
          ),
        ),
      ),
    );
  }
}
