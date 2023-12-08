import 'package:flutter/material.dart';

class MyDrawerWidget extends StatefulWidget {
  final  userData;

  MyDrawerWidget({required this.userData});

  @override
  _MyDrawerWidgetState createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
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
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.grid_3x3_outlined),
              title: Text("Products"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text("Contact"),
              onTap: () {},
            )
          ],
        ),
      );
  }
}
