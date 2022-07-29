import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;
  const Button({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(secondary)),
      child: Text(text),
    );
  }
}
