// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Login/WB.dart';
import '../Providers/Theme_Provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  Future<void> _deleteTodo(String userId, String todo) async {
    try {
      if (widget.user.user?.uid == userId) {
        // I am still Here (Not finished)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Text('Todo deleted successfully'),
            duration: Duration(seconds: 3),
          ),
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'todos': FieldValue.arrayRemove([todo]),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Text('You are not the owner'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      print('Error deleting todo: $error');
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
            expandedHeight: 150,
            stretch: true,
            centerTitle: true,
            onStretchTrigger: () async {},
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                    'https://faculty.kfupm.edu.sa/CE/nratrout/Images/Title.jpg',
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        _deleteTodo(
                                          user!.uid,
                                          item, // Use 'item' directly as the identifier
                                        );
                                      },
                                      icon: Icon(Icons.circle_outlined),
                                    ),
                                    title: Text('$item'),
                                    subtitle: Text(
                                      'By: ${snapshot.data!.docs[todos.indexOf(todo)]['username']}',
                                    ),
                                    // Optional: Set a background color for the ListTile
                                    contentPadding: EdgeInsets.all(
                                        8), // Optional: Add padding to the content
                                    shape: RoundedRectangleBorder(
                                      // Apply rounded rectangle border
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: Colors.grey,
                                          width: 1), // Border color and width
                                    ),
                                  ),
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
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add a new ToDo'),
              content: TextField(
                controller: _newTodoController,
                decoration: InputDecoration(
                  hintText: 'Enter your ToDo',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTodo();
                    Navigator.pop(context);
                  },
                  child: Text('Add ToDo'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
