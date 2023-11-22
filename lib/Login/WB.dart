// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Theme_Provider.dart';

class WelcomeBack extends StatefulWidget {
  const WelcomeBack({super.key});

  @override
  State<WelcomeBack> createState() => _WelcomeBackState();
}

class _WelcomeBackState extends State<WelcomeBack> {
  // define variables for the login screen
  String emailAddress = '';
  String password = '';

  bool _hidePassword = true;

  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    bool isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text('H'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'WelcomeBack!',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                key: const Key('Email'),
                controller: emailController,
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey[800],
                  icon: Icon(Icons.alternate_email),
                  labelText: 'Email Address',
                  labelStyle: TextStyle(color: Colors.white54),
                ),
                onChanged: (value) {
                  emailAddress = value;
                },
              ),
              TextFormField(
                key: const Key('Password'),
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blueGrey[800],
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
              SizedBox(
                height: 10,
              ),
              TextButton(
                key: const Key('Forgot'),
                style: ButtonStyle(alignment: Alignment.centerRight),
                onPressed: () {},
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
              ElevatedButton(
                key: const Key('Login'),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffdbba5e),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.all(20.0),
                ),
                child: Text('Log In', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
