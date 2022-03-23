import 'package:flutter/material.dart';
import 'package:studybooth_application/utils/routes.dart';

class Main_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Text(
                "Welcome to StudyBooth Application",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Image.asset(
                'assets/images/StudyBooth.gif',
                height: 200,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50.0),
              child: Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(280, 50),
                    primary: Colors.blue,
                    shape: StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.blue)),
                  ),
                  child: Text('Admin Login'),
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.aloginRoute);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(280, 50),
                    primary: Colors.blue,
                    shape: StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.blue)),
                  ),
                  child: Text('Teacher Login'),
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.tloginRoute);
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(280, 50),
                    primary: Colors.blue,
                    shape: StadiumBorder(
                        side: BorderSide(width: 1, color: Colors.blue)),
                  ),
                  child: Text('Stduent Login'),
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.sloginRoute);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
