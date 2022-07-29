import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:app_medidores_inteligentes/src/pages/home_page.dart';
import 'package:app_medidores_inteligentes/src/pages/main_page/main_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primary,
      ),
      initialRoute: "/",
      routes: {
        "/": (_) => const HomePage(),
        "/main": (_) => const MainPage(),
      },
    );
  }
}
