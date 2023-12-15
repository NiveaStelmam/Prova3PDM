import 'package:flutter/material.dart';
import 'package:terceira_prova/pages/tela_home.dart';
import 'package:terceira_prova/pages/tela_sobre.dart';
import 'package:terceira_prova/pages/tela_captura.dart';

import 'dao/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MaterialAppHome(db: db));
}

class MaterialAppHome extends StatelessWidget {
  MaterialAppHome({Key? key, required this.db}) : super(key: key);
  final AppDatabase db;

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
            backgroundColor: Colors.purple, // Escolhe uma cor Priscillaaa!!!
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
                  text: "Sobre Nós",
                  icon: Icon(Icons.info),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TelaHome(),
              TelaCaptura(),
              TelaSobre(),
            ],
          ),
        ),
      ),
    );
  }
}
