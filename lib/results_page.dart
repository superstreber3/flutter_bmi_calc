import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';

enum BMICategory {
  severeUnderweight,
  moderateUnderweight,
  slightUnderweight,
  normal,
  overweight,
  obesityClassI,
  obesityClassII,
  obesityClassIII
}

class ResultsPage extends StatelessWidget {
  final double bmi;

  ResultsPage({required this.bmi});

  BMICategory getBMICategory(double bmi) {
    if (bmi < 16.0)
      return BMICategory.severeUnderweight;
    else if (bmi < 17.0)
      return BMICategory.moderateUnderweight;
    else if (bmi < 18.5)
      return BMICategory.slightUnderweight;
    else if (bmi < 25.0)
      return BMICategory.normal;
    else if (bmi < 30.0)
      return BMICategory.overweight;
    else if (bmi < 35.0)
      return BMICategory.obesityClassI;
    else if (bmi < 40.0)
      return BMICategory.obesityClassII;
    else
      return BMICategory.obesityClassIII;
  }

  Map<String, String> getBMICategories() {
    return {
      'Severely Underweight': '< 16.0',
      'Moderately Underweight': '16.0 - 16.9',
      'Slightly Underweight': '17.0 - 18.4',
      'Normal Weight': '18.5 - 24.9',
      'Overweight': '25.0 - 29.9',
      'Obesity Class I': '30.0 - 34.9',
      'Obesity Class II': '35.0 - 39.9',
      'Obesity Class III': '40.0 and above',
    };
  }

  @override
  Widget build(BuildContext context) {
    BMICategory category = getBMICategory(bmi);

    String categoryText;

    switch (category) {
      case BMICategory.severeUnderweight:
        categoryText = 'Severely Underweight';
        break;
      case BMICategory.moderateUnderweight:
        categoryText = 'Moderately Underweight';
        break;
      case BMICategory.slightUnderweight:
        categoryText = 'Slightly Underweight';
        break;
      case BMICategory.normal:
        categoryText = 'Normal Weight';
        break;
      case BMICategory.overweight:
        categoryText = 'Overweight';
        break;
      case BMICategory.obesityClassI:
        categoryText = 'Obesity Class I';
        break;
      case BMICategory.obesityClassII:
        categoryText = 'Obesity Class II';
        break;
      case BMICategory.obesityClassIII:
        categoryText = 'Obesity Class III';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI CALCULATOR RESULTS'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('BMI Categories'),
                content: ListView(
                  children: getBMICategories().entries.map((entry) {
                    return ListTile(
                      title: Text(entry.key),
                      subtitle: Text('BMI: ${entry.value}'),
                    );
                  }).toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) {
              return {'BMI Categories'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your BMI is:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 48),
            ),
            Text(
              categoryText,
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                if (auth.currentUser == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  // Save the BMI...
                }
              },
              child: Text('Save'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    const Size(200, 50)), // Ändert die Größe des Buttons
              ),
            ),
          ],
        ),
      ),
    );
  }
}
