// main.dart
import 'package:flutter/material.dart';
import 'start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BMICalculator());
}

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

class BMICalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: StartScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
