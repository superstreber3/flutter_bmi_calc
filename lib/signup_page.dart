import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, "/login");
  }

  void signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Registration successful, do something with the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Registration successful!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    navigateToLoginPage();
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (input) {
                    if (input?.isEmpty == true) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (input) => _email = input ?? '',
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (input) {
                    if (input == null || input.length < 6) {
                      return 'Please enter a password with at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  onSaved: (input) => _password = input ?? '',
                ),
              ),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Sign Up'),
              ),
              TextButton(
                onPressed: navigateToLoginPage,
                child: Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
