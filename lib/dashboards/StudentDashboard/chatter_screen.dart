import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:studybooth_application/models/student_model.dart';

import '../../utils/themes.dart';

final _firestore = FirebaseFirestore.instance;
String username = 'User';
String email = 'user@example.com';
String messageText = "";
String toemail = "";
StudentModel loggedInUser = StudentModel();

class ChatAppStudent extends StatefulWidget {
  const ChatAppStudent({Key? key}) : super(key: key);

  @override
  State<ChatAppStudent> createState() => _ChatAppStudentState();
}

class _ChatAppStudentState extends State<ChatAppStudent> {
  final chatMsgTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // getMessages();
  }

  void getCurrentUser() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      final uid = user?.uid;
      if (user != null) {
        FirebaseFirestore.instance
            .collection("students")
            .doc(uid)
            .get()
            .then((value) {
          loggedInUser = StudentModel.fromMap(value.data());
          setState(() {
            username = loggedInUser.first!;
            email = loggedInUser.email!;
          });
        });
      }
    } catch (e) {
      EdgeAlert.show(context,
          title: 'Something Went Wrong',
          description: e.toString(),
          gravity: EdgeAlert.BOTTOM,
          icon: Icons.error,
          backgroundColor: Colors.deepPurple[900]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final name = args['name'];
    final sendtoemail = args['email'];
    toemail = sendtoemail;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurple),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(25, 10),
          child: Container(
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.blue[100],
            ),
            decoration: BoxDecoration(
                // color: Colors.blue,

                // borderRadius: BorderRadius.circular(20)
                ),
            constraints: BoxConstraints.expand(height: 1),
          ),
        ),
        backgroundColor: Colors.white10,
        // leading: Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
        // ),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      color: Colors.deepPurple),
                ),
                Text(sendtoemail,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {
                          messageText = value;
                        },
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                    shape: CircleBorder(),
                    color: Colors.blue,
                    onPressed: () {
                      chatMsgTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': username,
                        'text': messageText,
                        'sendto': name,
                        'sendtoemail': toemail,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'senderemail': email
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    )
                    // Text(
                    //   'Send',
                    //   style: kSendButtonTextStyle,
                    // ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore
          .collection('messages')
          .where(
            'sendtoemail',
            whereIn: [email, toemail],
          )
          .orderBy('timestamp')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data?.docs.reversed;
          print(snapshot.data?.docs);
          print(toemail);
          print(email);
          List<MessageBubble> messageWidgets = [];
          for (var message in messages!) {
            final msgText = message['text'];
            final msgSender = message['sender'];
            // final msgSenderEmail = message.data['senderemail'];
            final currentUser = loggedInUser.first;

            // print('MSG'+msgSender + '  CURR'+currentUser);
            final msgBubble = MessageBubble(
                msgText: msgText,
                msgSender: msgSender,
                user: currentUser == msgSender);
            messageWidgets.add(msgBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              children: messageWidgets,
            ),
          );
        } else {
          return Center(
            child:
                CircularProgressIndicator(backgroundColor: Colors.deepPurple),
          );
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  bool user;
  MessageBubble(
      {required this.msgText, required this.msgSender, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              msgSender,
              style: TextStyle(
                  fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
