import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studybooth_application/dashboards/StudentDashboard/StudentDashboard.dart';
import 'package:studybooth_application/models/student_model.dart';
import 'package:studybooth_application/utils/themes.dart';
import 'package:studybooth_application/widgets/custom_button.dart';
import 'package:studybooth_application/widgets/custom_formfield.dart';
import 'package:studybooth_application/widgets/custom_header.dart';
import 'package:fluttertoast/fluttertoast.dart';

class S_login extends StatefulWidget {
  const S_login({Key? key}) : super(key: key);

  @override
  _S_loginState createState() => _S_loginState();
}

class _S_loginState extends State<S_login> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = true;

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();

  final _formKey = new GlobalKey<FormState>();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StudentModel loggedInUser = StudentModel();
  String? CheckPass(String? fieldContent) {
    RegExp regex = new RegExp(r'^.{6,}$');

    if (fieldContent!.isEmpty) {
      return ("Password is required for login");
    }
    if (!regex.hasMatch(fieldContent)) {
      return ("Enter Valid Password(Min. 6 Character)");
    }
  }

  String? CheckEmail(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter your Email");
    }
    //reg expression for email
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return ("Please Enter the valid Email");
    }
    return null;
  }

  static Future<User?> loginusingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          Fluttertoast.showToast(
              msg: "Your email address appears to be malformed.");
          break;
        case "wrong-password":
          Fluttertoast.showToast(msg: "Your password is wrong.");
          break;
        case "user-not-found":
          Fluttertoast.showToast(msg: "User with this email doesn't exist.");
          break;
        case "user-disabled":
          Fluttertoast.showToast(
              msg: "User with this email has been disabled.");
          break;
        case "too-many-requests":
          Fluttertoast.showToast(msg: "Too many requests. Try again later.");
          break;
        case "operation-not-allowed":
          Fluttertoast.showToast(
              msg: "Signing in with Email and Password is not enabled.");
          break;
        default:
          Fluttertoast.showToast(msg: "An undefined Error happened.");
      }
    }
    return user;
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      User? user = await loginusingEmailPassword(
          email: email, password: password, context: context);
      print(user);
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection("students")
              .doc(user.uid)
              .get()
              .then((value) {
            this.loggedInUser = StudentModel.fromMap(value.data());

            if (loggedInUser.userType == "Student") {
              Fluttertoast.showToast(msg: "Login successfull");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => StudentDashboard()));
            }
          });
        } on NoSuchMethodError catch (e) {
          Fluttertoast.showToast(msg: "Entered id is not a student id.");
        }
      }
    }
  }

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
          child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: MyThemes.blue,
          ),
          CustomHeader(
            text: 'Student Log In.',
            onTap: () {},
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.08,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: MyThemes.whiteshade,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.09),
                          child: Image.asset("assets/images/login.png"),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomFormField(
                          headingText: "Email",
                          hintText: "Email",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _emailController,
                          maxLines: 1,
                          validator: CheckEmail,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "Password",
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          hintText: "At least 8 Character",
                          obsecureText: _passwordVisible,
                          validator: CheckPass,
                          suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }),
                          controller: _passwordController,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: MyThemes.blue.withOpacity(0.7),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AuthButton(
                          onTap: () {
                            signIn();
                          },
                          text: 'Sign In',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    ));
  }
}
