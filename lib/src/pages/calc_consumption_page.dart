import 'dart:async';

import 'package:app_medidores_inteligentes/src/data/get_consumption.dart';
import 'package:flutter/material.dart';
import 'package:simple_timer/simple_timer.dart';

class CalcConsumptionPage extends StatefulWidget {
  final double normalConsumption;
  const CalcConsumptionPage({super.key, required this.normalConsumption});

  @override
  State<CalcConsumptionPage> createState() => _CalcConsumptionPageState();
}

class _CalcConsumptionPageState extends State<CalcConsumptionPage> {
  final initialDate = DateTime.now();
  List<double> consumptionPerMinuteList = [];
  late TimerController _timerController;

  final Stream<Future<double>> _myStream =
      Stream.periodic(const Duration(seconds: 6), (int count) async {
    final showerConsuption = await getShowerConsumption();
    final otherConsumptions = await getConsumption();
    return showerConsuption + otherConsumptions;
  });
  late StreamSubscription _sub;

  // finalize calc consumption per minute
  Future<void> _calcConsumptionPerMinuteList() async {
    _sub.cancel();
    double consumptionMedia = 0;
    for (var i = 0; i < consumptionPerMinuteList.length; i++) {
      consumptionMedia += consumptionPerMinuteList[i];
    }
    final consumptionPerMinute =
        consumptionMedia / consumptionPerMinuteList.length;

    final showerConsumption = consumptionPerMinute - widget.normalConsumption;

    final showerConsumptionTotal = consumptionMedia -
        (consumptionPerMinuteList.length * widget.normalConsumption);

    print("Consumo médio por minuto: $consumptionPerMinute");

    print(
        "Consumo total: $consumptionMedia no período de ${consumptionPerMinuteList.length} minutos");

    print(
        "Seu chuveiro está consumindo cerca de $showerConsumption por minuto");

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Cálculo finalizado!'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                      "Seu chuveiro está consumindo cerca de ${showerConsumption.toStringAsFixed(3)} kW por minuto \n"),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                      "Consumo médio total por minuto: ${consumptionPerMinute.toStringAsFixed(3)} kW \n"),
                  const SizedBox(height: 4),
                  Text(
                      "Custo do banho: (apenas chuveiro) R\$ ${(showerConsumptionTotal * 0.624351).toStringAsFixed(2)}  \n"),
                  const SizedBox(height: 4),
                  Text(
                      "Consumo total: ${consumptionMedia.toStringAsFixed(3)} kW no período de ${consumptionPerMinuteList.length} minutos"),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Beleza!'),
                ),
              ],
            ));
  }

  @override
  void initState() {
    _sub = _myStream.listen((event) async {
      final res = await event;
      var temp = consumptionPerMinuteList;
      temp.add(res);
      setState(() {
        consumptionPerMinuteList = temp;
      });
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
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _calcConsumptionPerMinuteList();
                    },
                    child: const Text("Finalzar cálculo")),
                Text('${consumptionPerMinuteList.length.toString()} min'),
              ],
            )),
      ),
    );
  }
}
