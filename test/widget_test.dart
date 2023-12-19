import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listify/features/Login/WB.dart';
import 'package:listify/features/Pages/DrawerWdiget.dart';
import 'package:listify/features/Pages/HomePage.dart';
import 'package:listify/features/Pages/WaitScreen.dart';
import 'package:listify/features/Providers/Theme_Provider.dart';
import 'package:listify/features/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('WaitPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: WaitPage()));
    expect(find.byType(Placeholder), findsOneWidget);
  });

  testWidgets('HomePage Widget Test', (WidgetTester tester) async {
    final UserCredential mockUserCredential = MockUserCredential();
    final Map<String, dynamic> mockUserData = {
      'username': 'TestUser',
      'email': 'test@example.com',
    };
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
          child: HomePage(user: mockUserCredential, userData: mockUserData),
        ),
      ),
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget);
  });

  testWidgets('MyDrawerWidget Test', (WidgetTester tester) async {
    final Map<String, dynamic> mockUserData = {
      'username': 'TestUser',
      'email': 'test@example.com',
    };
    final Function mockOnProjectSelected = (String projectName) {};
    final String mockCurrentProjectName = 'Main Project';

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        drawer: MyDrawerWidget(
          userData: mockUserData,
          onProjectSelected: mockOnProjectSelected,
          currentProjectName: mockCurrentProjectName,
        ),
      ),
    ));

    // Open the drawer
    tester.fling(find.byType(AppBar), const Offset(-200.0, 0.0), 1000.0);
    await tester.pumpAndSettle();

    // Verify that certain widgets are present
    expect(find.text('TestUser'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.add_task), findsOneWidget);

    // Add more assertions to test for the presence of other key widgets or functionalities
  });
}

// Mock class for UserCredential
class MockUserCredential extends UserCredential {
  MockUserCredential() : _authResultMock;
}

// Mock class for AuthResult
final _authResultMock = UserMock();

// Mock class for User
class UserMock {
  @override
  String get uid => '111111111111';

  @override
  String? get email => 'test@example.com';

  @override
  String? get displayName => 'TestUser';
}