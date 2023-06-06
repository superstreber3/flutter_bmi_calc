// results_page.dart
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final double bmi;

  ResultsPage({required this.bmi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR RESULTS'),
      ),
      body: Center(
        child: Text(
          'Your BMI is ${bmi.toStringAsFixed(1)}',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
