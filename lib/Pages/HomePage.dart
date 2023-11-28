// ignore_for_file: prefer_const_constructors
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_4),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
            expandedHeight: 250,
            stretch: true,
            onStretchTrigger: () async {},
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  'https://faculty.kfupm.edu.sa/CE/nratrout/Images/Title.jpg',
                  fit: BoxFit.fill),
              title: Text(
                  'Welcome, ${widget.userData?['username'] ?? user?.uid}!'),
              centerTitle: true,
              stretchModes: [
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
                StretchMode.blurBackground
              ],
            ),
          ),
          //
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collectionGroup('users')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final todos = snapshot.data!.docs
                            .map((doc) => doc['todos'])
                            .toList();
                        return Column(
                          children: [
                            for (var todo in todos)
                              for (var item in todo)
                                ListTile(
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.circle_outlined),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {},
                                    color: Colors.red,
                                  ),
                                  title: Text('$item'),
                                  subtitle: Text(
                                      'By: ${snapshot.data!.docs[todos.indexOf(todo)]['username']}'),
                                )
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                },
                childCount: 1,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: const SizedBox(height: 10),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
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
      ),
    );
  }
}
