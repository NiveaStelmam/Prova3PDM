import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/pages/tela_home.dart';
import 'package:terceira_prova/pages/tela_pokemon_capturado.dart';
import 'package:terceira_prova/pages/tela_sobre.dart';
import 'package:terceira_prova/pages/tela_captura.dart';
import 'package:terceira_prova/pages/tela_soltar_pokemon.dart';

import 'dao/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  final pokemonDao = database.pokemonDao;

  runApp(MaterialAppHome(
    pokemonDao: pokemonDao,
  ));
}

class MaterialAppHome extends StatelessWidget {
  MaterialAppHome({Key? key, required this.pokemonDao}) : super(key: key);
  final PokemonDao pokemonDao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.purple[50], // Escolhe uma cor Priscillaaa!!!
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Pokemon App"),
            backgroundColor: Colors.purple,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TelaSobre(),
                      ),
                    );
                  },
                  icon: Icon(Icons.info))
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Home",
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: "Capturar",
                  icon: Icon(Icons.catching_pokemon_outlined),
                ),
                Tab(
                  text: "Meus Pokemons",
                  icon: Icon(Icons.my_library_books),
                ),
                Tab(
                  text: "Soltar Pokemons",
                  icon: Icon(Icons.my_library_books),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TelaHome(),
              TelaCaptura(pokemonDao: pokemonDao),
              TelaPokemonCapturado(pokemonDao: pokemonDao),
            ],
          ),
        ),
      ),
    );
  }
}
