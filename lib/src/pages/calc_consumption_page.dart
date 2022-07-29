import 'dart:async';

import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:app_medidores_inteligentes/src/components/button.dart';
import 'package:app_medidores_inteligentes/src/data/get_consumption.dart';
import 'package:flutter/material.dart';

class CalcConsumptionPage extends StatefulWidget {
  final double normalConsumption;
  const CalcConsumptionPage({super.key, required this.normalConsumption});

  @override
  State<CalcConsumptionPage> createState() => _CalcConsumptionPageState();
}

class _CalcConsumptionPageState extends State<CalcConsumptionPage> {
  final initialDate = DateTime.now();
  List<double> consumptionPerMinuteList = [];
  double consumptionPerMinute = 0;
  double consumptionTotal = 0;
  double eletronicConsumptionLastMinute = 0;
  double eletronicConsumptionTotal = 0;
  double priceConsumptionTotal = 0;
  double priceEletronicConsumption = 0;

  final Stream<Future<double>> _myStream =
      Stream.periodic(const Duration(seconds: 5), (int count) async {
    final consumption = await getConsumption();
    return consumption['last_minute_consumption'];
  });
  late StreamSubscription _sub;

  void _calcValues(double value) {
    List<double> temp = consumptionPerMinuteList;
    if (temp.isEmpty || temp.last != value) {
      temp.add(value);
    }
    setState(() {
      consumptionPerMinuteList = temp;
      consumptionPerMinute = value * 1000;
      consumptionTotal = consumptionPerMinuteList.reduce((a, b) => a + b);
      eletronicConsumptionLastMinute =
          (value - widget.normalConsumption) * 1000;
      eletronicConsumptionTotal =
          consumptionTotal - (widget.normalConsumption * temp.length);
      priceConsumptionTotal = consumptionTotal * 0.636639;
      priceEletronicConsumption = eletronicConsumptionTotal * 0.636639;
    });
  }

  @override
  void initState() {
    consumptionPerMinute = widget.normalConsumption * 1000;
    _sub = _myStream.listen((event) async {
      final res = await event;
      _calcValues(res);
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculando consumo'),
        backgroundColor: secondary,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Consumo por mês em kWh',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Seu consumo no último minuto foi de: ${consumptionPerMinute.toStringAsFixed(2)} Wh'),
                        const SizedBox(height: 20),
                        Text(
                            'Seu consumo total foi de: ${consumptionTotal.toStringAsFixed(2)} kWh'),
                        const SizedBox(height: 20),
                        Text(
                            'Seu consumo total foi de: R\$ ${priceConsumptionTotal.toStringAsFixed(2)}'),
                        const SizedBox(height: 20),
                        Text(
                            'O consumo do eletrônico no último minuto foi de: ${eletronicConsumptionLastMinute.toStringAsFixed(2)} Wh'),
                        const SizedBox(height: 20),
                        Text(
                            'O consumo do eletrônico no total foi de: ${eletronicConsumptionTotal.toStringAsFixed(2)} kWh'),
                        const SizedBox(height: 20),
                        Text(
                            'O consumo do eletrônico no total foi de: R\$ ${priceEletronicConsumption.toStringAsFixed(2)}'),
                        const SizedBox(height: 20),
                      ]),
                ),
                Button(
                    onPressed: () async {
                      await _sub.cancel();
                    },
                    text: "Finalzar cálculo"),
                Text('${consumptionPerMinuteList.length.toString()} minutos'),
              ],
            )),
      ),
    );
  }
}
