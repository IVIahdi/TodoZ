import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listify/Login/WB.dart';
import 'package:provider/provider.dart';

import '../Providers/Theme_Provider.dart';

class HomePage extends StatefulWidget {
  final UserCredential user;
  final Map<String, dynamic>? userData;

  const HomePage({Key? key, required this.user, this.userData})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WelcomeBack()));
  }

  @override
  Widget build(BuildContext context) {
    final _user = widget.user.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userData?['username'] ?? _user?.uid}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
