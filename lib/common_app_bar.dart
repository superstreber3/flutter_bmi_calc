import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'past_results_page.dart'; // Import the PastResultsPage

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('BMI Calculator'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'logout') {
              FirebaseAuth auth = FirebaseAuth.instance;
              if (auth.currentUser != null) {
                auth.signOut();
                // Handle logout or navigate to the logout screen
              }
            } else if (value == 'login') {
              Navigator.pushNamed(context, '/login');
            } else if (value == 'bmiCategories') {
              showDialog(
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
              );
            } else if (value == 'pastResults') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PastResultsPage(),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            final FirebaseAuth auth = FirebaseAuth.instance;
            return [
              if (auth.currentUser == null)
                PopupMenuItem<String>(
                  value: 'login',
                  child: Text('Login'),
                ),
              if (auth.currentUser != null)
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              PopupMenuItem<String>(
                value: 'bmiCategories',
                child: Text('BMI Categories'),
              ),
              if (auth.currentUser != null)
                PopupMenuItem<String>(
                  value: 'pastResults',
                  child: Text('Past Results'),
                ),
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

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
}
