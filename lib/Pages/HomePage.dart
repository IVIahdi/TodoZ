import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Login/WB.dart';
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
  final TextEditingController _newTodoController = TextEditingController();

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WelcomeBack()));
  }

  getAllUsersTodos() async {
    final _usersData = await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) => value.docs.map((e) => e.data()['todos']));
    return _usersData;
  }

  Future<void> _addTodo() async {
    final String newTodo = _newTodoController.text.trim();
    if (newTodo.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.user!.uid)
          .update({
        'todos': FieldValue.arrayUnion([newTodo]),
      });
      _newTodoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.userData?['username'] ?? user?.uid}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final todos =
                        snapshot.data!.docs.map((doc) => doc['todos']).toList();
                    return ListView.builder(
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text('${todos[index]}'),
                          subtitle: Text('By: ${doc['username']}'),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newTodoController,
                    decoration: InputDecoration(
                      hintText: 'Add a new todo',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: Text('Add Todo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
