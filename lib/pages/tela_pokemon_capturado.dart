import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/domain/pokemon.dart';

class TelaPokemonCapturado extends StatefulWidget {
  final PokemonDao pokemonDao;

  const TelaPokemonCapturado({Key? key, required this.pokemonDao})
      : super(key: key);

  @override
  _TelaPokemonCapturadoState createState() => _TelaPokemonCapturadoState();
}

class _TelaPokemonCapturadoState extends State<TelaPokemonCapturado> {
  late Future<List<Pokemon>> capturedPokemonList;

  @override
  void initState() {
    super.initState();
    capturedPokemonList = widget.pokemonDao.findAllPokemons();
    capturedPokemonList.then((pokemons) {
      print('Total de pokemons capturados: ${pokemons.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: capturedPokemonList,
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
    return Card(
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
        /*trailing: ElevatedButton(
          onPressed: () async {
            await dao.deletePokemon(pokemon);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(8),
            backgroundColor: Colors.red,
          ),
          child: Icon(Icons.delete, color: Colors.white),
        ),*/
      ),
    );
  }
}
