import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre Nós"),
        backgroundColor: Colors.deepOrange.shade800,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Desenvolvido por:'),
            SizedBox(height: 10),
            Text('Priscilla Melo'),
            Text('Nivea Stelmam'),
          ],
        ),
      ),
    );
  }
}
