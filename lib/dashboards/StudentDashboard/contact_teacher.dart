import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/StudentDashboard.dart';
import 'package:studybooth_application/utils/themes.dart';

class Contact_Teacher extends StatefulWidget {
  @override
  State<Contact_Teacher> createState() => _Contact_TeacherState();
}

class _Contact_TeacherState extends State<Contact_Teacher> {
  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance.collection("teachers").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StudyBooth Student Panel",
          style: TextStyle(fontSize: 22.0, color: MyThemes.darkerText),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_sharp,
            color: MyThemes.darkerText,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => StudentDashboard())),
        ),
      ),
      backgroundColor: MyThemes.whiteshade,
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return Material(
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(data['imageUrl'].toString()),
                  ),
                  title: Text(
                    data['first'] + " " + data['last'],
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['email']),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    print("Click on " + data['uid']);
                    Navigator.pushNamed(context, '/chatter', arguments: {
                      'name': data['first'] + " " + data['last'],
                      'email': data['email'],
                    });
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
