import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
