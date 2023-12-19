import 'package:flutter/material.dart';
import 'package:terceira_prova/dao/pokemon_dao.dart';
import 'package:terceira_prova/pages/tela_home.dart';
import 'package:terceira_prova/pages/tela_pokemon_capturado.dart';
import 'package:terceira_prova/pages/tela_sobre.dart';
import 'package:terceira_prova/pages/tela_captura.dart';

import 'dao/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db').build();
  final pokemonDao = database.pokemonDao;

  runApp(MyApp(
    pokemonDao: pokemonDao,
  ));
}

class MyApp extends StatelessWidget {
  final PokemonDao pokemonDao;

  const MyApp({Key? key, required this.pokemonDao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.orange[50],
      ),
      home: MaterialAppHome(
        pokemonDao: pokemonDao,
      ),
    );
  }
}

class MaterialAppHome extends StatelessWidget {
  MaterialAppHome({Key? key, required this.pokemonDao}) : super(key: key);
  final PokemonDao pokemonDao;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pokémon App"),
          backgroundColor: Colors.deepOrange.shade800,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TelaSobre(),
                  ),
                );
              },
              icon: Icon(Icons.info),
            )
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
                text: "Meus Pokemon",
                icon: Icon(Icons.list),
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
    );
  }
}
