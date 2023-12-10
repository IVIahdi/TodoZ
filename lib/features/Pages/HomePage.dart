// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Login/WB.dart';
import '../Providers/Theme_Provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../Providers/projects.dart';

import 'DrawerWdiget.dart';

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

// Future<void> addProject(String projectName, [List<Task> tasksList = const []]) async {
//   CollectionReference projects = FirebaseFirestore.instance.collection('projects');
//   await projects.add({
//     'projectName': projectName,
//     'tasksList': tasksList.map((task) => {
//       'creatorName': task.creatorName,
//       'taskName': task.taskName,
//     }).toList(),
//   });
// }

  var projectCurrentName = 'Main Project';

  helper(projects) {}

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WelcomeBack()));
  }

  Future<void> _addTodoToProject() async {
    final String newTodo = _newTodoController.text.trim();
    if (newTodo.isNotEmpty) {
      try {
        // Query for the project with the specified projectName
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('projects')
                .where('projectName', isEqualTo: projectCurrentName)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID of the project
          String projectId = querySnapshot.docs.first.id;

          // Update the project's taskList
          await FirebaseFirestore.instance
              .collection('projects')
              .doc(projectId)
              .update({
            'tasksList': FieldValue.arrayUnion([
              {'creatorName': widget.userData!['username'], 'taskName': newTodo}
            ]),
          });
          _newTodoController.clear();
        } else {
          // Handle the case when the project is not found
          print('Error: Project not found');
        }
      } catch (e) {
        print("Error adding todo to project: $e");
        // Handle the error as needed
      }
    }
  }

  Future<void> _deleteTodo(String creatorName, String taskName) async {
    try {
      if (widget.userData!['username'] == creatorName) {
        QuerySnapshot projects = await FirebaseFirestore.instance
            .collection('projects')
            .where('projectName', isEqualTo: projectCurrentName)
            .get();

        if (projects.docs.isNotEmpty) {
          // Get the first matching project
          DocumentSnapshot project = projects.docs.first;

          // Extract the tasksList
          List<Map<String, dynamic>> tasksList =
              List<Map<String, dynamic>>.from(project['tasksList']);

          // Find the task that matches the creatorName and taskName
          int taskIndex = tasksList.indexWhere((task) =>
              task['creatorName'] == creatorName &&
              task['taskName'] == taskName);

          if (taskIndex != -1) {
            // Remove the task from the tasksList
            tasksList.removeAt(taskIndex);

            // Update the project document with the new tasksList
            await project.reference.update({'tasksList': tasksList});

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.lightGreen,
                content: Text('Todo deleted successfully'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
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
      drawer: MyDrawerWidget(
        userData: widget.userData,
        onProjectSelected: (projectName) {
          setState(() {
            projectCurrentName = projectName;
          });
        },
        currentProjectName: projectCurrentName,
      ),
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
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
              title: Text(projectCurrentName),
              centerTitle: true,
              stretchModes: const [
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
                        .collection('projects')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final projects = snapshot.data!.docs;

                        var selectedProject;
                        for (var project in projects) {
                          if (project['projectName'] == projectCurrentName) {
                            selectedProject = project;
                            break; // Stop iterating once the project is found
                          }
                        }

                        return Column(
                          children: [
                            for (var item in selectedProject['tasksList'])
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: IconButton(
                                    onPressed: () {
                                      _deleteTodo(
                                        item['creatorName'],
                                        item['taskName'],
                                      );
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  title: Text('${item['taskName']}'),
                                  subtitle: Text(
                                    'By: ${item['creatorName']}',
                                  ),
                                  contentPadding: EdgeInsets.all(8),
                                  // Optional: Add padding to the content
                                  shape: RoundedRectangleBorder(
                                    // Apply rounded rectangle border
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: Colors.grey,
                                        width: 1), // Border color and width
                                  ),
                                ),
                              ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator(); // or any other loading indicator
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
              title: Text('Add a new Task'),
              content: TextField(
                controller: _newTodoController,
                decoration: InputDecoration(
                  hintText: 'Enter your Task',
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
                    _addTodoToProject();
                    Navigator.pop(context);
                  },
                  child: Text('Add a Task'),
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
