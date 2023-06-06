// start_screen.dart
import 'package:flutter/material.dart';
import 'input_page.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to BMI Calculator'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Start'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InputPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}
