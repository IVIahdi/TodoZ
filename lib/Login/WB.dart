// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/Pages/HomePage.dart';
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
  final usernameController = TextEditingController();

  bool _validateForm() {
    if (formkey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  // Function to show an error Snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
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
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.user!.uid)
            .set(
          {
            'email': emailController.text,
            'username': usernameController.text,
          },
        );
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.user!.uid)
            .get();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: _user,
              userData: userData.data(),
            ),
          ),
        );
      } else if (loginMode && _validateForm()) {
        var _user = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Fetch the user data from Firestore
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user.user!.uid)
            .get();

        // Navigate to HomePage with the UserCredential and additional user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              user: _user,
              userData: userData.data(),
            ),
          ),
        );
      } else {
        throw Exception('Invalid form data');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorSnackbar('The email address is already registered.');
      } else {
        _showErrorSnackbar(
            'Failed (User Side). Please check your credentials.');
      }
    } catch (e) {
      _showErrorSnackbar('Failed (Server Side).');
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
          child: SingleChildScrollView(
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
                Visibility(
                  visible: !loginMode,
                  child: TextFormField(
                    key: const Key('Username'),
                    controller: usernameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Username',
                    ),
                  ),
                ),
                TextFormField(
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
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
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
      ),
    );
  }
}
