import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studybooth_application/widgets/custom_button.dart';

import '../../utils/themes.dart';

class Test_Firebase extends StatefulWidget {
  const Test_Firebase({Key? key}) : super(key: key);

  @override
  State<Test_Firebase> createState() => _Test_FirebaseState();
}

class _Test_FirebaseState extends State<Test_Firebase> {
  final _firestore = FirebaseFirestore.instance;
  TimeOfDay selectedTime = TimeOfDay.now();
  String date = "";
  DateTime selectedDate = DateTime.now();
  TextEditingController _controller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = "${selectedTime.hour}:${selectedTime.minute}";
    _datecontroller.text =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter TimePicker"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'click here to select time',
                labelText: 'Select time *',
              ),
              readOnly: true,
              controller: _controller,
              onTap: () {
                _selectTime(context);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'click here to select date',
                labelText: 'Select Date *',
              ),
              readOnly: true,
              controller: _datecontroller,
              onTap: () {
                _selectDate(context);
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            AuthButton(
              onTap: () {
                _firestore.collection('timers').add({
                  'selectedTime': _controller.text,
                  'selectedDate': _datecontroller.text,
                });
                Fluttertoast.showToast(msg: "Uploaded !!!!!!! ");
              },
              text: 'Upload',
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
