import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';
import 'package:terceira_prova/pages/tela_solta_pokemon.dart';

import 'tela_detalhes_pokemon.dart';

class TelaPokemonCapturado extends StatefulWidget {
  final PokemonDao pokemonDao;

  const TelaPokemonCapturado({Key? key, required this.pokemonDao})
      : super(key: key);

  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late Future<List<Pokemon>> _capturedPokemonList;

  @override
  void initState() {
    super.initState();
    _capturedPokemonList = widget.pokemonDao.findAllPokemons();
    /* _capturedPokemonList.then((pokemons) {
      print('Total de pokemons capturados: ${pokemons.length}');
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _capturedPokemonList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar os Pokémons capturados'),
          );
        } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          return Scaffold(
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return PokemonCapturadoItem(
                  pokemon: snapshot.data![index],
                  dao: widget.pokemonDao,
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text('Nenhum Pokémon capturado'),
          );
        }
      },
    );
  }
}

class PokemonCapturadoItem extends StatelessWidget {
  final Pokemon pokemon;
  final PokemonDao dao;

  PokemonCapturadoItem({Key? key, required this.pokemon, required this.dao})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Text(
            pokemon.nome,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text('ID: ${pokemon.id.toString()}'),
              Text('Peso: ${pokemon.peso.toString()}'),
              Text('Altura: ${pokemon.altura.toString()}'),
              Text('Tipo: ${pokemon.tipo.toString()}'),
            ],
          ),
          leading: Image.network(
            pokemon.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
      ),
      onTap: () {
        print(pokemon.nome);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TelaDetalhesPokemon(id: pokemon.id, dao: dao),
          ),
        );
      },
      onLongPress: () {
        print(pokemon.tipo);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TelaSoltarPokemon(id: pokemon.id, dao: dao),
          ),
        );
      },
    );
  }
}
