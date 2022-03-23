class StudentModel {
  String? uid;
  String? username;
  String? first;
  String? last;
  String? mobile;
  String? sem;
  String? gender;
  String? year;
  String? div;
  String? imageUrl;
  String? email;
  String? userType;

  StudentModel({
    this.uid,
    this.username,
    this.first,
    this.last,
    this.mobile,
    this.sem,
    this.gender,
    this.year,
    this.div,
    this.imageUrl,
    this.email,
    this.userType,
  });

  // recieving data from the server

  factory StudentModel.fromMap(map) {
    return StudentModel(
        uid: map['uid'],
        username: map['username'],
        first: map['first'],
        last: map['last'],
        mobile: map['mobile'],
        sem: map['sem'],
        gender: map['gender'],
        year: map['year'],
        div: map['div'],
        imageUrl: map['imageUrl'],
        email: map['email'],
        userType: map['userType']);
  }

  //sending data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'first': first,
      'last': last,
      'mobile': mobile,
      'sem': sem,
      'gender': gender,
      'year': year,
      'div': div,
      'imageUrl': imageUrl,
      'email': email,
      'userType': userType,
    };
  }
}
