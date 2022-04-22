import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studybooth_application/dashboards/TeacherDashboard/add_gmeet.dart';
import 'package:studybooth_application/dashboards/TeacherDashboard/contact_student.dart';
import 'package:studybooth_application/models/homelist.dart';
import 'package:studybooth_application/models/teacher_model.dart';
import 'package:studybooth_application/utils/themes.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

TeacherModel loggedInUser = TeacherModel();

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  List<HomeList> homeList = HomeList.homeList;
  AnimationController? animationController;
  bool multiple = true;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
    FirebaseFirestore.instance
        .collection('teachers')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = TeacherModel.fromMap(value.data());

      setState(() {});
    });
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyThemes.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  appBar(),
                  Expanded(
                    child: FutureBuilder<bool>(
                      future: getData(),
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        } else {
                          return HomeListView();
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '  StudyBooth Teacher Panel',
                  style: TextStyle(
                    fontSize: 22,
                    color: MyThemes.darkText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView(
      {Key? key,
      this.listData,
      this.callBack,
      this.animationController,
      this.animation})
      : super(key: key);

  final HomeList? listData;
  final VoidCallback? callBack;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 3,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/addgmeet', arguments: {
                  'model': loggedInUser,
                });
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.account_balance,
                      size: 50.0,
                    ),
                    Text("Add Lecture",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/adddrive', arguments: {
                  'model': loggedInUser,
                });
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.collections_bookmark,
                      size: 50.0,
                    ),
                    Text("Add Drive Folder",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Academics Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.school,
                      size: 50.0,
                    ),
                    Text("Academics",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Contact_Student()));
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.contact_phone,
                      size: 50.0,
                    ),
                    Text("Contact Students",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Placement Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.card_travel,
                      size: 50.0,
                    ),
                    Text("Placement",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Exam Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.content_paste,
                      size: 50.0,
                    ),
                    Text("Exam Section",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Bus Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.departure_board,
                      size: 50.0,
                    ),
                    Text(
                      "Bus",
                      style: new TextStyle(fontSize: 17.0),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Notice Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.notification_important,
                      size: 50.0,
                    ),
                    Text("Notice",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Navigation Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add_location,
                      size: 50.0,
                    ),
                    Text("Navigation",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontSize: 17.0,
                        ))
                  ],
                ),
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 10,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "Food Section");
              },
              splashColor: Colors.lightBlueAccent,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.restaurant,
                      //color: Colors.amberAccent,
                      size: 50.0,
                    ),
                    Text("Food", style: new TextStyle(fontSize: 17.0))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
