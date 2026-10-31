import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'views/calculator_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const CalculatorScreen(),
    );
  }
}
