import 'package:flutter/material.dart';
import 'package:terceira_prova/pages/tela_home.dart';
import 'package:terceira_prova/pages/tela_sobre.dart';

void main() {
  runApp(const MaterialAppHome());
}

class MaterialAppHome extends StatelessWidget {
  const MaterialAppHome({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:
            Colors.purple[50], // Escolhe uma cor Priscillaaa!!!
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Pokemon"),
            backgroundColor: Colors.purple, // Escolhe uma cor Priscillaaa!!!
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Home",
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: "Sobre Nós",
                  icon: Icon(Icons.accessibility_new),
                ),
                Tab(
                  text: "aba 3",
                  icon: Icon(Icons.access_alarm),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TelaHome(),
              TelaSobre(),
              Aba3(),
            ],
          ),
        ),
      ),
    );
  }
}

class Aba3 extends StatelessWidget {
  const Aba3({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
