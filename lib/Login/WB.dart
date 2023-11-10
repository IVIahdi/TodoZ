// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class WelcomeBack extends StatefulWidget {
  const WelcomeBack({super.key});

  @override
  _WelcomeBackState createState() => _WelcomeBackState();
}

class _WelcomeBackState extends State<WelcomeBack> {
  // define variables for the login screen
  String emailAddress = '';
  String password = '';
  bool _hidePassword = true;

  // validate the login form
  bool _validateForm() {
    if (emailAddress.isEmpty || password.isEmpty) {
      return false;
    }
    return true;
  }

  // submit the login form
  void _submitForm() {
    if (_validateForm()) {
      // TODO: Implement login logic
    } else {
      // Show error message
    }
  }

  void toggleEye() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff171b29),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Back text
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              // Email address field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[300],
                    icon: Icon(Icons.alternate_email),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.white54),
                  ),
                  onChanged: (value) {
                    emailAddress = value;
                  },
                ),
              ),

              // Password field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[300],
                      icon: Icon(Icons.lock),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                      suffixIcon: GestureDetector(
                        onTap: toggleEye,
                        child: _hidePassword
                            ? Icon(Icons.visibility_off_rounded)
                            : Icon(Icons.visibility_rounded),
                      ),
                      suffixIconColor: Colors.grey),
                  obscureText: _hidePassword,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),

              // Forgot password button
              TextButton(
                style: ButtonStyle(alignment: Alignment.centerRight),
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // Login button
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('Log In', style: TextStyle(color: Colors.black)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffdbba5e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
