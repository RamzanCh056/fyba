



import 'package:cloud_firestore/cloud_firestore.dart';

class userModelFields{
  static const String userId='User Id';
  static const String userName = 'User Name';
  static const String userEmail = 'User Email';
  static const String userPassword = 'User Password';
  static const String signinType="Signin Type";
}

class UserModel{
  String userId;
  String userName;
  String userEmail;
  String userPassword;
  String signinType;

  UserModel({
    required this.userId,
  required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.signinType
  });

  Map<String, dynamic> toJson() {
    return {
      userModelFields.userId:userId,
    userModelFields.userName: userName,
    userModelFields.userEmail: userEmail,
    userModelFields.userPassword: userPassword,
      userModelFields.signinType:signinType
    };
  }

  factory UserModel.fromJson(DocumentSnapshot json)=>UserModel(
    userId: json[userModelFields.userId],
      userName: json[userModelFields.userName],
      userEmail: json[userModelFields.userEmail],
      userPassword: json[userModelFields.userPassword],
    signinType: json[userModelFields.signinType]
  );
}