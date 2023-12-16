import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TelaCaptura extends StatefulWidget {
  @override
  _TelaCapturaState createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  late List<int> sorteios = [];
  late List<Map<String, dynamic>> pokemons = [];
  late List<int> pokemonsCapturados = [];
  late bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _verificarConexao();
  }

  Future<void> _verificarConexao() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });

    if (isConnected) {
      _sortearPokemons();
    }
  }

  Future<void> _sortearPokemons() async {
    // Sorteia os 6 números de 0 a 1017
    sorteios = List.generate(6, (index) => Random().nextInt(1018));

    // Obtem os dados dos Pokémons sorteados que vieram da API
    for (int id in sorteios) {
      final response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> pokemonData = json.decode(response.body);
        // Extrai os dados desejados da resposta da API
        final String imageUrl = pokemonData['sprites']['front_default'];
        final int peso = pokemonData['weight'];
        final int altura = pokemonData['height'];

        // pega o primeiro "tipo" já que "tipo" é uma lista
        final String tipo = pokemonData['types'][0]['type']['name'];
        setState(() {
          pokemonData['imageUrl'] = imageUrl;
          pokemonData['peso'] = peso;
          pokemonData['altura'] = altura;
          pokemonData['tipo'] = tipo;

          pokemons.add(pokemonData);
        });
      } else {
        // se der algum erro para encontrar os dados do pokemon exibe uma msg
        print('Erro ao obter dados do Pokémon $id');
      }
    }
  }

  bool _isPokemonCapturado(int id) {
    return pokemonsCapturados.contains(id);
  }

  void _capturarPokemon(int id) {
    setState(() {
      pokemonsCapturados.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isConnected
          ? ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                return _buildPokemonItem(pokemons[index]);
              },
            )
          : Center(
              child: Text(
                  'Sem conexão com a internet. Conecte-se para visualizar os Pokémons.'),
            ),
    );
  }

  Widget _buildPokemonItem(Map<String, dynamic> pokemon) {
    int pokemonId = pokemon['id'];

    // adicionei os pokemons a cards
    return Card(
      elevation: 4, // sombra do card
      margin: EdgeInsets.all(8), // margem ao redor do card
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // preenchimento interno ao ListTile
        title: Text(
          pokemon['name'],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8), // espaço entre o título e os detalhes
            Text('ID: $pokemonId'),
            Text('Peso: ${pokemon['peso']}'),
            Text('Altura: ${pokemon['altura']}'),
            Text('Tipo: ${pokemon['tipo']}'),
          ],
        ),
        leading: Image.network(
          pokemon['imageUrl'],
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        trailing: ElevatedButton(
          onPressed: _isPokemonCapturado(pokemonId)
              ? null
              : () => _capturarPokemon(pokemonId),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8), //  preenchimento ao botão
            backgroundColor:
                _isPokemonCapturado(pokemonId) ? Colors.grey : Colors.purple,
          ),
          child: Icon(Icons.catching_pokemon_outlined, color: Colors.white),
        ),
      ),
    );
  }
}
