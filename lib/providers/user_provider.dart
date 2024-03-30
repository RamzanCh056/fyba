



import 'package:app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{

  UserModel? user;
  String setValue="";

  updateSetValue(String value){
    setValue=value;
    notifyListeners();
  }


  updateUser(UserModel userData){
    user=userData;
    notifyListeners();
  }

  getUser()async{
    if(FirebaseAuth.instance.currentUser!=null) {
      await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((snapshot){
      if(snapshot.exists){
        user=UserModel.fromJson(snapshot);
        notifyListeners();
      }
    });
    }
  }


}