// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Theme_Provider.dart';

class WelcomeBack extends StatefulWidget {
  const WelcomeBack({super.key});

  @override
  State<WelcomeBack> createState() => _WelcomeBackState();
}

class _WelcomeBackState extends State<WelcomeBack> {
  final _auth = FirebaseAuth.instance;

  bool loginMode = true;

  bool _hidePassword = true;

  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _validateForm() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  // Function to show an error Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      if (!loginMode && _validateForm()) {
        var _user = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Registration successful, you can navigate to another screen or perform other actions
      } else if (loginMode && _validateForm()) {
        var _user = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Login successful, you can navigate to another screen or perform other actions
      } else {
        throw Exception('Invalid form data');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorSnackbar('The email address is already registered.');
      } else {
        _showErrorSnackbar(
            'Authentication failed. Please check your credentials.');
      }
    } catch (e) {
      // Handle other exceptions
      _showErrorSnackbar(
          'Authentication failed. Please check your credentials.');
    }
  }

  void toggleEye() {
    setState(
      () {
        _hidePassword = !_hidePassword;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context, listen: true).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text('IVI'),
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
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: const Key('Email'),
                controller: emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email),
                  labelText: 'Email Address',
                ),
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: const Key('Password'),
                controller: passwordController,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password',
                    suffixIcon: GestureDetector(
                      onTap: toggleEye,
                      child: _hidePassword
                          ? Icon(Icons.visibility_off_rounded)
                          : Icon(Icons.visibility_rounded),
                    ),
                    suffixIconColor: Colors.grey),
                obscureText: _hidePassword,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: loginMode,
                child: TextButton(
                  key: const Key('Forgot'),
                  style: ButtonStyle(alignment: Alignment.centerRight),
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style:
                        TextStyle(color: isDark ? Colors.white : Colors.black),
                  ),
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
                child: Text(loginMode ? 'Log In' : 'Sing Up',
                    style: TextStyle(color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        loginMode = !loginMode;
                      });
                    },
                    child: Text(loginMode
                        ? 'Don\'t have an account? Register here'
                        : 'Already registered? Login here'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
