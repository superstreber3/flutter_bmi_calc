import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helloworld/common_app_bar.dart';
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

  const ResultsPage({super.key, required this.bmi});

  BMICategory getBMICategory(double bmi) {
    if (bmi < 16.0) {
      return BMICategory.severeUnderweight;
    } else if (bmi < 17.0) {
      return BMICategory.moderateUnderweight;
    } else if (bmi < 18.5) {
      return BMICategory.slightUnderweight;
    } else if (bmi < 25.0) {
      return BMICategory.normal;
    } else if (bmi < 30.0) {
      return BMICategory.overweight;
    } else if (bmi < 35.0) {
      return BMICategory.obesityClassI;
    } else if (bmi < 40.0) {
      return BMICategory.obesityClassII;
    } else {
      return BMICategory.obesityClassIII;
    }
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
      appBar: CommonAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your BMI is:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              bmi.toString(),
              style: const TextStyle(fontSize: 48),
            ),
            Text(
              categoryText,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                FirebaseAuth auth = FirebaseAuth.instance;
                if (auth.currentUser == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  // Retrieve the logged-in user's ID
                  String userId = auth.currentUser!.uid;

                  // Create a new data entry with the BMI result and inputs
                  DocumentReference bmiDocRef =
                      firestore.collection('bmiResults').doc();

                  await bmiDocRef.set({
                    'userId': userId,
                    'bmi': bmi,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  // Show a success message to the user
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Success'),
                        content: Text('BMI result saved successfully.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Save'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
