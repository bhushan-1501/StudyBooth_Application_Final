import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/StudentDashboard.dart';
import 'package:studybooth_application/utils/themes.dart';
import 'package:url_launcher/url_launcher.dart';

class Join_Gmeet extends StatefulWidget {
  const Join_Gmeet({Key? key}) : super(key: key);

  @override
  State<Join_Gmeet> createState() => _Join_GmeetState();
}

DateTime selectedDate = DateTime.now();
String checkdate =
    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

class _Join_GmeetState extends State<Join_Gmeet> {
  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream = FirebaseFirestore
      .instance
      .collection("Online_Lectures")
      .where("date", isEqualTo: checkdate)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StudyBooth GMeet Panel",
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
            print(checkdate);
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
                    backgroundImage: NetworkImage(
                        "https://image.pngaaa.com/489/1193489-middle.png"),
                  ),
                  title: Text(
                    data['subject'],
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Start : " +
                      data['start_time'] +
                      " | End : " +
                      data['end_time']),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
                    Fluttertoast.showToast(msg: "Opening " + data['link']);
                    _openLink(data['link']);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  _openLink(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: 'Could not launch $url');
    }
  }
}
