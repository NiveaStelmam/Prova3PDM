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
    _verificarConexao(); // aqui chama o metodo pra verificar a conexão assim que a tela é iniciada
    pokemonListAPI = _sortearPokemons();
    // pokemonCapturados = widget.pokemonDao.findAllPokemons();
  }

  Future<void> _verificarConexao() async {
    // vai verificar a conexão com a internet e caso
    var connectivityResult = await Connectivity()
        .checkConnectivity(); // usa a classe Connectivity para verificar o estado da conexao e armazena o resultado na  variavel isConnected, se tiver internet a variavel pokemonListApi é atualizada e chama o metodo pra sortear os 6 pokemons
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
                // adição do listView - questão 3
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
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.deepOrange.shade800))),
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
    List<Pokemon> pokemonSorteio =
        []; // inicia vazia e armazenara os pokemnos sorteados aleatoriamente
    sorteios = List.generate(6, (index) => Random().nextInt(1018));

    for (int id in sorteios) {
      // iterar sobre os id para buscar dados dos pokemnos na api
      final response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> pokemonData = json.decode(response
            .body); // decodifica o corpo da resposta do json no map pokemonData
        final int id = pokemonData['id'];
        final String nome = pokemonData['name'];
        final String imageUrl = pokemonData['sprites']['front_default'];
        final int peso = pokemonData['weight'];
        final int altura = pokemonData['height'];
        final String tipo = pokemonData['types'][0]['type']['name'];
        //print('TESTEEEEEEEEEEE');
        print(pokemonData['abilities'][0]);
        String habilidades = "";

        for (var element in pokemonData['abilities']) {
          habilidades += element["ability"]["name"] + ", ";
        }

        final int experiencia = pokemonData['base_experience'] ?? 0;

        String forma = "";
        for (var element in pokemonData['forms']) {
          forma += element['name'];
        }

        Pokemon pokemon = Pokemon(
            id: id,
            nome: nome,
            imageUrl: imageUrl,
            peso: peso,
            altura: altura,
            tipo: tipo,
            habilidades: habilidades,
            experiencia: experiencia,
            forma: forma);
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
  Color _colorButton = Colors.deepOrange.shade800;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
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
            SizedBox(height: 8),
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
            widget.dao.insertPokemon(
                widget.pokemon); // insere o pokemon no banco de dados
            setState(() {
              _colorButton = Colors.grey; // altera a cor do botao pra cinza
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
