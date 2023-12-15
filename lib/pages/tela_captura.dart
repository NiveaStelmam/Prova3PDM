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
        setState(() {
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

    return ListTile(
      title: Text(pokemon['name']),
      subtitle: Text('ID: $pokemonId'),
      trailing: ElevatedButton(
        onPressed: _isPokemonCapturado(pokemonId)
            ? null // Desativa o botão se o Pokémon já estiver capturado
            : () => _capturarPokemon(pokemonId), // Chama a função de captura
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isPokemonCapturado(pokemonId) ? Colors.grey : Colors.purple,
        ),
        child: Icon(Icons.catching_pokemon_outlined, color: Colors.white),
      ),
    );
  }
}
