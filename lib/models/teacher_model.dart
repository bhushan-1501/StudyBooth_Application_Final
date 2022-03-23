class TeacherModel {
  String? uid;
  String? username;
  String? first;
  String? last;
  String? mobile;
  String? degree;
  String? gender;
  String? exp;
  String? special;
  String? imageUrl;
  String? email;
  String? userType;

  TeacherModel({
    this.uid,
    this.username,
    this.first,
    this.last,
    this.mobile,
    this.degree,
    this.gender,
    this.exp,
    this.special,
    this.imageUrl,
    this.email,
    this.userType,
  });

  // recieving data from the server

  factory TeacherModel.fromMap(map) {
    return TeacherModel(
      uid: map['uid'],
        username: map['username'],
        first: map['first'],
        last: map['last'],
        mobile: map['mobile'],
        degree: map['degree'],
        gender: map['gender'],
        exp: map['exp'],
        special: map['special'],
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
      'degree': degree,
      'gender': gender,
      'exp': exp,
      'special': special,
      'imageUrl': imageUrl,
      'email': email,
      'userType': userType,
    };
  }
}
