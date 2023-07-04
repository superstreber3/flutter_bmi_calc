import 'dart:html';

import 'package:flutter/material.dart';
import 'package:helloworld/common_app_bar.dart';
import 'results_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int height = 0;
  int weight = 0;
  DateTime? birthDate;
  String? birthDateInString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Zentriert die Elemente in der Column
          children: <Widget>[
            Text("Input",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            SizedBox(height: 60), // Add a vertical gap
            TextField(
              decoration: const InputDecoration(labelText: "Height (cm)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  height = int.parse(value);
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Weight (kg)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  weight = int.parse(value);
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime(1999, 1, 1),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                ).then((date) {
                  setState(() {
                    birthDate = date;
                    birthDateInString =
                        "${birthDate?.day}/${birthDate?.month}/${birthDate?.year}";
                  });
                });
              },
              child: const Text('Pick your birth date'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    const Size(200, 50)), // Ändert die Größe des Buttons
              ),
            ),
            const SizedBox(height: 60), // Fügt einen Raum vor dem Button hinzu
            ElevatedButton(
              child: const Text('Calculate BMI'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    const Size(200, 50)), // Ändert die Größe des Buttons
              ),
              onPressed: () {
                // Calculate BMI and navigate to results page
                int age = DateTime.now().difference(birthDate!).inDays ~/ 365;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                      bmi: calculateBMI(height, weight, age),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  double calculateBMI(int height, int weight, int age) {
    // Modify the formula to use age if needed
    double bmi = weight / ((height / 100) * (height / 100));
    return double.parse(bmi.toStringAsFixed(2));
  }
}
