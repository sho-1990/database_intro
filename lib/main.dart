import 'package:database_intro/database_helper.dart';
import 'package:database_intro/user.dart';
import 'package:flutter/material.dart';


List _users;

void main() async {

  var db = DatabaseHelper();

  // add user
//   await db.saveUser(User("Johana", "Lifeisgood"));
  // Get all users;
  _users = await db.getAllUsers();
  runApp(MaterialApp(
    title: "Database",
    home: Home()
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (_, int position) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text("${User.fromMap(_users[position]).username.substring(0, 1)}"),
                ),
                title: Text("User: ${User.fromMap(_users[position]).username}"),
                subtitle: Text("Id: ${User.fromMap(_users[position]).id}"),
                onTap: () => debugPrint("${User.fromMap(_users[position]).password}"),
              ),
            );
          }),
    );
  }
}



