import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '', _password = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/"); // or your main page route
      }
    });
  }

  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, "/signup");
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  void login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError(e.toString());
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
                  'Login',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (input) {
                    if (input?.isEmpty == null) {
                      return 'Enter Email';
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
                      return 'Provide Minimum 6 Character';
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
                onPressed: login,
                child: Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: navigateToSignUpScreen,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
