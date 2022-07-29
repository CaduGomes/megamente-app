import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:app_medidores_inteligentes/src/components/button.dart';
import 'package:app_medidores_inteligentes/src/components/horizontal_bar_chart.dart';
import 'package:app_medidores_inteligentes/src/data/get_consumption.dart';
import 'package:app_medidores_inteligentes/src/pages/calc_consumption_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<double> lastConsumptionList = [];
  bool fetch = true;

  List<Value> mapValues(List<dynamic> data) {
    List<Value> values = [];

    for (var i = 0; i < data.length; i++) {
      values.add(Value((data[i]['value'] as int).toDouble(), data[i]['month']));
    }
    return values;
  }

  void checkEletronics(double consumption) {
    if (lastConsumptionList.length > 2 &&
        (consumption / lastConsumptionList[lastConsumptionList.length - 2]) >
            10 &&
        fetch) {
      setState(() {
        fetch = false;
      });
      final consumption = lastConsumptionList[lastConsumptionList.length - 2];
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Deseja iniciar o cálculo de consumo?'),
                content: const Text(
                    'Detectamos que você ligou algum eletrônico, clique em iniciar para calcular consumo.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancelar');
                      setState(() {
                        fetch = true;
                      });
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalcConsumptionPage(
                                  normalConsumption: consumption)));
                    },
                    child: const Text('Iniciar'),
                  ),
                ],
              ));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Parabéns! Você reduziu o consumo em 8%'),
                  content: const Text(
                      'Analisando os seus dados notamos que do mês de Maio para o mês de Junho você reduziu o consumo em 8%'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Ok'),
                      child: const Text('Show!'),
                    ),
                  ],
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Megamente Energia'),
          backgroundColor: secondary,
        ),
        body: Center(
          child: Column(
            children: [
              const Image(
                  image: AssetImage('assets/logo-transparent.png'),
                  height: 130),
              const SizedBox(height: 20),
              const Text(
                'Bem vindo ao seu painel de consumo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Button(
                  text: 'Calcular consumo de um eletrônico',
                  onPressed: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text(
                                  'Deseja iniciar o cálculo de consumo?'),
                              content: const Text(
                                  'Você deve ligar o eletrônico e após isso clicar em iniciar.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancelar'),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalcConsumptionPage(
                                                    normalConsumption:
                                                        lastConsumptionList
                                                            .last)));
                                  },
                                  child: const Text('Iniciar'),
                                ),
                              ],
                            ));
                  }),
              const SizedBox(height: 20),
              StreamBuilder(
                  stream: Stream.periodic(const Duration(seconds: 3))
                      .asyncMap((i) async {
                    final value = await getConsumption();
                    checkEletronics(value['last_minute_consumption']);
                    List<double> temp = lastConsumptionList;
                    if (temp.isEmpty ||
                        temp.last != value['last_minute_consumption']) {
                      temp.add(value['last_minute_consumption']);
                      setState(() {
                        lastConsumptionList = temp;
                      });
                    }
                    return value;
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Seu consumo atual do mês é de: ${(snapshot.data?['current_month_consumption'] as double).toStringAsFixed(2)} kWh'),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Seu consumo no último mínuto foi de: ${((snapshot.data?['last_minute_consumption'] as double) * 1000).toStringAsFixed(2)} Wh'),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Seu consumo total é de: ${(snapshot.data?['total_consumption'] as double).toStringAsFixed(2)} kWh'),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Dia da última leitura de dados: ${snapshot.data?['last_read_day']}'),
                                  const SizedBox(height: 20),
                                  Text(
                                      'Dia da próxima leitura de dados: ${snapshot.data?['next_read_day']}'),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Consumo por mês em kWh',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 20),
                                  DefaultBarChart(
                                      values: mapValues(snapshot
                                          .data?['last_months_consumption']))
                                ]),
                          ),
                        ]),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ));
  }
}
