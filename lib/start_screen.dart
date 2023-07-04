import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:helloworld/common_app_bar.dart';
import 'input_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              height: 150,
              width: 150,
              'assets/sport.svg',
              semanticsLabel: 'Sport Illustration', // optional
            ),
            const SizedBox(height: 50),
            const Text(
              'This is a simple BMI Calculator. '
              'Please press the start button to begin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(
                height: 20.0), // Adds some spacing between text and button
            ElevatedButton(
              child: const Text("Let's Go"),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                    const Size(200, 50)), // Ändert die Größe des Buttons
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
