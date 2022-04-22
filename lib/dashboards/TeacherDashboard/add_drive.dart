import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studybooth_application/dashboards/TeacherDashboard/TeacherDashboard.dart';
import 'package:studybooth_application/models/teacher_model.dart';
import 'package:studybooth_application/utils/theme_helper.dart';
import 'package:studybooth_application/utils/themes.dart';
import 'package:studybooth_application/utils/timer_header_widget.dart';
import 'package:studybooth_application/widgets/custom_button.dart';

enum SingingCharacter { lafayette, jefferson }
int _groupValue = -1;

String? Check(String? value) {
  if (value!.isEmpty) {
    return ("Please Enter the value");
  }
  return null;
}

String pattern =
    r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
RegExp regExp = new RegExp(pattern);

String? hasValidUrl(String value) {
  if (value.isEmpty) {
    return ("Please Enter the value");
  }
  if (!regExp.hasMatch(value)) {
    return 'Please enter valid url';
  }
  return null;
}

String? CheckLink(String? value) {
  bool validURL = Uri.parse(value!).host == '' ? false : true;
  if (value.isEmpty) {
    return ("Please Enter the value");
  }
  if (validURL != true) {
    return ("Please Enter the valid link");
  }
  return null;
}

String? CheckDate(String? value) {
  if (value == "Please select Date") {
    return ("Please select Date");
  }

  return null;
}

class AddDrive extends StatefulWidget {
  const AddDrive({Key? key}) : super(key: key);

  @override
  State<AddDrive> createState() => _AddDriveState();
}

String name = "";
String subject = "";
String link = "";
String date = "";
TimeOfDay selectedStartTime = TimeOfDay.now();
TimeOfDay selectedEndTime = TimeOfDay.now();
bool isstart = false;
bool isend = false;
bool isdate = false;

TimeOfDay now = TimeOfDay.now();

DateTime selectedDate = DateTime.now();

class _AddDriveState extends State<AddDrive> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  TextEditingController _datecontroller = TextEditingController();

  TeacherModel loggedInUser = TeacherModel();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    loggedInUser = args['model'];
    String? id = loggedInUser.uid;
    name = loggedInUser.first.toString() + " " + loggedInUser.last.toString();

    _datecontroller.text = isdate
        ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
        : "Please select Date";
    _nameController.text = name;

    print(id);

    // All Controllers related to form

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StudyBooth Teacher Panel",
          style: TextStyle(fontSize: 22.0, color: MyThemes.white),
        ),
        backgroundColor: MyThemes.navbar,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left_sharp,
            color: MyThemes.white,
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TeacherDashboard())),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: TimerHeaderWidget(100, false, "Add Gmeet"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                        ),
                        Container(
                          child: TextFormField(
                            controller: _nameController,
                            //validator: CheckUsername,
                            textInputAction: TextInputAction.next,

                            readOnly: true,
                            decoration: ThemeHelper()
                                .textInputDecoration('Name', 'Teacher Name'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Subject", "Enter Subject Name"),
                            keyboardType: TextInputType.name,
                            validator: Check,
                            controller: _subjectController,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: ThemeHelper().textInputDecoration(
                              'Select Date', 'Click here to select date'),
                          readOnly: true,
                          controller: _datecontroller,
                          validator: CheckDate,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Link", "Enter link of Gmeet"),
                            keyboardType: TextInputType.name,
                            validator: CheckLink,
                            controller: _linkController,
                            autofocus: false,
                            textInputAction: TextInputAction.next,
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AuthButton(
                          onTap: () {
                            _firestore.collection('Drive_Links').add({
                              'teacher_name': _nameController.text,
                              'subject': _subjectController.text,
                              'date': _datecontroller.text,
                              'link': _linkController.text,
                            });
                            Fluttertoast.showToast(msg: "Added !!!!!!! ");
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

  _selectDate(BuildContext context) async {
    isdate = true;
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  _selectStartTime(BuildContext context) async {
    isstart = true;
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedStartTime) {
      setState(() {
        selectedStartTime = timeOfDay;
      });
    }
  }

  _selectEndTime(BuildContext context) async {
    isend = true;
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedEndTime) {
      setState(() {
        selectedEndTime = timeOfDay;
      });
    }
  }
}
