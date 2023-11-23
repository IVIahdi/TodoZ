import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login/WB.dart';
import 'Providers/Theme_Provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDQPWAPr-S8yHLtIRN6AryveH5ln9hZMcE",
          appId: "1:562891858605:web:30946af5214569d119dc24",
          messagingSenderId: "562891858605",
          projectId: "todoz-d4cf7"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      home: const WelcomeBack(),
    );
  }
}
