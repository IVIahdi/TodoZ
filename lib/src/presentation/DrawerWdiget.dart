import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDrawerWidget extends StatefulWidget {
  final userData;
  final Function onProjectSelected;
  final String currentProjectName;

  MyDrawerWidget(
      {required this.userData,
      required this.onProjectSelected,
      required this.currentProjectName});

  @override
  _MyDrawerWidgetState createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  final TextEditingController _newProjectController = TextEditingController();

  Future<void> _addProject() async {
    try {
      final CollectionReference projectsCollection =
          FirebaseFirestore.instance.collection('projects');

      // Get the project name from the text controller
      String projectName = _newProjectController.text.trim();

      // Check if the project name is not empty
      if (projectName.isNotEmpty) {
        // Create a new project map
        Map<String, dynamic> newProject = {
          'projectName': projectName,
          'tasksList': [],
        };

        // Add the new project to the Firebase collection
        await projectsCollection.add(newProject);

        widget.onProjectSelected(_newProjectController.text.trim());
        Navigator.pop(context);
      } else {
        // Show an error message or handle the case where the project name is empty
        print('Error: Project name cannot be empty');
      }
    } catch (e) {
      print("Error adding project: $e");
      // Handle the error as needed
    }
  }

  List<Map<String, dynamic>> projects = [];

  Future<List<Map<String, dynamic>>> getAllProjects() async {
    final CollectionReference projectsCollection =
        FirebaseFirestore.instance.collection('projects');
    try {
      QuerySnapshot<Object?> querySnapshot = await projectsCollection.get();

      List<Map<String, dynamic>> projects = [];

      for (QueryDocumentSnapshot<Object?> document in querySnapshot.docs) {
        projects.add(document.data() as Map<String, dynamic>? ?? {});
      }

      return projects;
    } catch (e) {
      print("Error fetching projects: $e");
      return [];
    }
  }

  Future<void> _deleteProject(String projectName) async {
    try {
      final CollectionReference projectsCollection =
          FirebaseFirestore.instance.collection('projects');
      QuerySnapshot<Object?> querySnapshot = await projectsCollection
          .where('projectName', isEqualTo: projectName)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await projectsCollection.doc(querySnapshot.docs.first.id).delete();
      } else {
        print('Error: Project not found');
      }
    } catch (e) {
      print("Error deleting project: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllProjects().then((value) {
      setState(() {
        projects = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${widget.userData['username']}'),
            accountEmail: Text('${widget.userData['email']}'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://www.shareicon.net/data/128x128/2017/01/06/868320_people_512x512.png"),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://st4.depositphotos.com/18186852/40791/i/450/depositphotos_407914094-stock-photo-bright-colored-sticky-notes-blue.jpg",
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            leading: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_task,
                color: Colors.white,
              ),
            ),
            title: Text(
              "New Project",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Add a new Project'),
                  content: TextField(
                    controller: _newProjectController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Project Name',
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
                        _addProject();
                        getAllProjects().then((value) {
                          setState(() {
                            projects = value;
                          });
                        });
                        Navigator.pop(context);
                      },
                      child: Text('create New Project'),
                    ),
                  ],
                ),
              );
            },
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(projects[index]['projectName'] ?? 'No Name'),
                  onTap: () {
                    widget.onProjectSelected(projects[index]['projectName']);
                    Navigator.pop(context);
                  },
                  trailing: (projects[index]['projectName'] == 'Main Project' ||
                          projects[index]['projectName'] ==
                              widget.currentProjectName)
                      ? null
                      : IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProject(projects[index]['projectName']);
                            setState(() {
                              projects.removeAt(index);
                            });
                          },
                        ));
            },
          ),
        ],
      ),
    );
  }
}
