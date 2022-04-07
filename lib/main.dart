import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/AdminDashboard.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/registration_page.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/chatter_screen.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/contact_teacher.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/test_firebase.dart';
import 'package:studybooth_application/dashboards/TeacherDashboard/chatter_screen.dart';
import 'package:studybooth_application/pages/Alogin_page.dart';
import 'package:studybooth_application/pages/Tlogin_page.dart';

import 'pages/Slogin_page.dart';
import 'pages/main_page.dart';
import 'utils/routes.dart';
import 'widgets/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: MyRoutes.tloginRoute,
        routes: {
          MyRoutes.splashRoute: (context) => SplashScreen(),
          MyRoutes.mainPageRoute: (context) => Main_Page(),
          MyRoutes.sloginRoute: (context) => S_login(),
          MyRoutes.aloginRoute: (context) => Alogin(),
          MyRoutes.tloginRoute: (context) => T_login(),
          MyRoutes.adashRoute: (context) => AdminDashboard(),
          MyRoutes.aregRoute: (context) => RegistrationPage(),
          MyRoutes.testRoute: (context) => Contact_Teacher(),
          MyRoutes.chatterRoute: (context) => ChatAppStudent(),
          MyRoutes.chatterStRoute: (context) => ChatAppTeacher(),
        });
  }
}
