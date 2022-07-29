import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

  // onPressed: () {
  //                           showDialog<String>(
  //                               context: context,
  //                               builder: (BuildContext context) => AlertDialog(
  //                                     title: const Text(
  //                                         'Deseja iniciar o cálculo de consumo?'),
  //                                     content: const Text(
  //                                         'Você deve ligar o chuveiro e após isso clicar em iniciar.'),
  //                                     actions: <Widget>[
  //                                       TextButton(
  //                                         onPressed: () => Navigator.pop(
  //                                             context, 'Cancelar'),
  //                                         child: const Text('Cancelar'),
  //                                       ),
  //                                       TextButton(
  //                                         onPressed: () {
  //                                           Navigator.push(
  //                                               context,
  //                                               MaterialPageRoute(
  //                                                   builder: (context) =>
  //                                                       CalcConsumptionPage(
  //                                                           normalConsumption:
  //                                                               snapshot.data ??
  //                                                                   0)));
  //                                         },
  //                                         child: const Text('Iniciar'),
  //                                       ),
  //                                     ],
  //                                   ));
  //                         },