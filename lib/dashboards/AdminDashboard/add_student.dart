import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studybooth_application/dashboards/AdminDashboard/header_widget.dart';
import 'package:studybooth_application/models/student_model.dart';
import 'package:studybooth_application/widgets/custom_button.dart';
import 'package:studybooth_application/widgets/custom_formfield.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
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
          return StudentForm();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class StudentForm extends StatefulWidget {
  const StudentForm({Key? key}) : super(key: key);

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool checkedValue = false;
  bool checkboxValue = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String get email => _emailController.text.trim();

  String get password => _passwordController.text.trim();
  // Image Picker
  ImagePicker image = ImagePicker();
  String url = "";

  final _uidController = TextEditingController();
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _mobno = TextEditingController();
  final _sem = TextEditingController();
  final _year = TextEditingController();
  final _gender = TextEditingController();
  final _div = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = true;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  StudentModel loggedInUser = StudentModel();
  // string for displaying the error Message
  String? errorMessage;

  // All Validators

  String? CheckPass(String? fieldContent) {
    RegExp regex = new RegExp(r'^.{6,}$');

    if (fieldContent!.isEmpty) {
      return ("Password is required for login");
    }
    if (!regex.hasMatch(fieldContent)) {
      return ("Enter Valid Password(Min. 6 Character)");
    }
    return null;
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

  String? CheckUsername(String? value) {
    RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty) {
      return ("Please Enter your Username");
    } else {
      if (!regex.hasMatch(value))
        return ("Enter Valid Password(Min. 6 Character)");
    }
    return null;
  }

  String? CheckFirst(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the First Name");
    }
    return null;
  }

  String? CheckLast(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the Last Name");
    }
    return null;
  }

  String? CheckMobno(String? value) {
    RegExp regex = new RegExp(r'^[6-9]\d{9}$');
    if (value!.isEmpty) {
      return ("Please Enter the Mobile No.");
    }
    if (!regex.hasMatch(value)) {
      return ("Enter Valid Mobile Number");
    }
    return null;
  }

  String? CheckDegree(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the sem");
    }
    return null;
  }

  String? CheckGender(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the Gender");
    }
    return null;
  }

  String? CheckSpecial(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the division");
    }
    return null;
  }

  String? CheckExp(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter the year");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        GestureDetector(
                          child: Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 0.5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      //blurRadius: 20,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet()),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 60.0,
                                        backgroundImage: _imageFile == null
                                            ? AssetImage(
                                                "assets/images/addimage.jpg")
                                            : FileImage(File(_imageFile!.path))
                                                as ImageProvider,
                                      ),
                                    ),
                                    Positioned(
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomSheet()),
                                          );
                                        },
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.teal,
                                          size: 28.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CustomFormField(
                          headingText: "UID :",
                          hintText: "Enter UID",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _uidController,
                          maxLines: 1,
                          validator: CheckUsername,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "First Name :",
                          hintText: "Enter First name",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _firstname,
                          maxLines: 1,
                          validator: CheckFirst,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "Last Name:",
                          hintText: "Enter Last Name",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _lastname,
                          maxLines: 1,
                          validator: CheckLast,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 16,
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
                        const SizedBox(
                          height: 30,
                        ),
                        CustomFormField(
                          headingText: "Mobile No:",
                          hintText: "Enter Mobile no",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _mobno,
                          maxLines: 1,
                          validator: CheckMobno,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.phone,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "Gender :",
                          hintText: "Enter Gender ",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _gender,
                          maxLines: 1,
                          validator: CheckGender,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "YEAR :",
                          hintText: "Enter Current year",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _year,
                          maxLines: 1,
                          validator: CheckExp,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "SEM:",
                          hintText: "Enter SEM",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _sem,
                          maxLines: 1,
                          validator: CheckDegree,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        CustomFormField(
                          headingText: "DIV :",
                          hintText: "Enter current division",
                          obsecureText: false,
                          suffixIcon: const SizedBox(),
                          controller: _div,
                          maxLines: 1,
                          validator: CheckSpecial,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        AuthButton(
                          onTap: () {
                            uploadFile();
                          },
                          text: 'Submit',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text("Choose Profile Image", style: TextStyle(fontSize: 20.0)),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  void uploadFile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirbase()})
            .catchError((e) {
          print(e);

          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (e) {
        if (e == 'firebase_auth/email-already-in-use') {
          errorMessage = "user already exists in system";
        } else {
          switch (e.code) {
            case "invalid-email":
              errorMessage = "Your email address appears to be malformed.";
              break;
            case "wrong-password":
              errorMessage = "Your password is wrong.";
              break;
            case "user-not-found":
              errorMessage = "User with this email doesn't exist.";
              break;
            case "user-disabled":
              errorMessage = "User with this email has been disabled.";
              break;
            case "too-many-requests":
              errorMessage = "Too many requests";
              break;
            case "operation-not-allowed":
              errorMessage =
                  "Signing in with Email and Password is not enabled.";
              break;
            case "email_already_in_use":
              errorMessage = "user already exists in system";
              break;
            default:
              errorMessage = "An undefined Error happened.";
          }
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(e.code);
      }
    }
  }

  postDetailsToFirbase() async {
    // calling firestore
    // calling doctor model
    // sending the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? student = _auth.currentUser;

    StudentModel studentModel = StudentModel();
    String imgId = DateTime.now().microsecondsSinceEpoch.toString();
    Reference imageFile =
        FirebaseStorage.instance.ref().child('images').child('users$imgId');
    UploadTask task = imageFile.putFile(_imageFile!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    studentModel.email = student!.email;
    studentModel.uid = student.uid;
    studentModel.username = _uidController.text;
    studentModel.first = _firstname.text;
    studentModel.last = _lastname.text;
    studentModel.gender = _gender.text;
    studentModel.mobile = _mobno.text;
    studentModel.sem = _sem.text;
    studentModel.year = _year.text;
    studentModel.div = _div.text;
    studentModel.imageUrl = url;
    studentModel.userType = "Student";

    await firebaseFirestore
        .collection("students")
        .doc(student.uid)
        .set(studentModel.toMap());
    print(url);
    Fluttertoast.showToast(msg: "Student Added Successfully!!!");
    _resetform();
  }

  void _resetform() {
    _formKey.currentState?.reset();
  }
}
