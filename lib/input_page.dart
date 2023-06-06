// input_page.dart
import 'package:flutter/material.dart';
import 'results_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int height = 0;
  int weight = 0;
  int age = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: "Height (cm)"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                height = int.parse(value);
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Weight (kg)"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                weight = int.parse(value);
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: "Age"),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                age = int.parse(value);
              });
            },
          ),
          ElevatedButton(
            child: Text('Calculate BMI'),
            onPressed: () {
              // Calculate BMI and navigate to results page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                    bmi: calculateBMI(height, weight),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  double calculateBMI(int height, int weight) {
    return weight / ((height / 100) * (height / 100));
  }
}
