import 'package:flutter/material.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/add_student.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/add_teacher.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/drawer_user_controller.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/feedback_screen.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/help_screen.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/home_drawer.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/home_screen.dart';
import 'package:studybooth_application/utils/themes.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyThemes.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: MyThemes.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = const MyHomePage();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = HelpScreen();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = FeedbackScreen();
          });
          break;
        case DrawerIndex.AddTeacher:
          setState(() {
            screenView = AddTeacher();
          });
          break;
        case DrawerIndex.AddStudent:
          setState(() {
            screenView = AddStudent();
          });
          break;
        default:
          break;
      }
    }
  }
}
