import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:app_medidores_inteligentes/src/components/button.dart';
import 'package:app_medidores_inteligentes/src/data/get_consumption.dart';
import 'package:app_medidores_inteligentes/src/pages/main_page/main_page.dart';
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
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 6))
                    .asyncMap((i) => getConsumption()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(children: [
                      const Image(
                          image: AssetImage('assets/logo-transparent.png'),
                          height: 200),
                      const Text(
                          'Esse é um aplicativo de teste para simular a utilização inteligente de medidores de energia.',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      Button(
                        text: "Começar",
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage())),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          "Consumo por minuto: ${snapshot.data?.toStringAsFixed(5)} kW"),
                    ]);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                })),
      ),
    );
  }
}
