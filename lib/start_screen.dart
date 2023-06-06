import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'input_page.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Handle profile icon press
              // Navigate to login or profile screen
            },
          ),
        ],
      ),
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
            SizedBox(height: 50),
            Text(
              'This is a simple BMI Calculator. '
              'Please press the start button to begin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0), // Adds some spacing between text and button
            ElevatedButton(
              child: Text("Let's Go"),
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
