import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:app_medidores_inteligentes/src/components/button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Megamente Energia'),
          backgroundColor: secondary,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Image(
                image: AssetImage('assets/logo-transparent.png'), height: 200),
            const Text(
                'Esse é um aplicativo de teste para simular a utilização inteligente de medidores de energia.',
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Button(
              text: "Começar",
              onPressed: () => Navigator.popAndPushNamed(context, '/main'),
            )
          ]),
        ));
  }
}
