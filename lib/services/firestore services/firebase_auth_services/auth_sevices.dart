
import 'package:app/Static/static.dart';
import 'package:app/consolePrintWithColor.dart';
import 'package:app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../../screens/Admin/admin_homescreen.dart';
import '../../../screens/main_screen.dart';

class FirebaseAuthServices{


  signUp(UserModel user,BuildContext context)async{

    try{

      var result=await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.userEmail, password: user.userPassword);

      if(result.user!=null){
        user.userId=result.user!.uid;
        FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(user.userId).set(user.toJson()).then((value){
          Navigator.pushNamed(context, "/");
          Fluttertoast.showToast(msg: "Account Created Successfully");
          // EasyLoading.showToast("Account Created Successfully",toastPosition: EasyLoadingToastPosition.bottom,duration: const Duration(seconds: 2));
        });
      }
    }catch (e){
      Fluttertoast.showToast(msg: e.toString(),backgroundColor: Colors.red);
    }


  }

  signIn(String email,String password,BuildContext context)async{

    try{
      var result=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      if(result.user!=null){
        var user=await FirebaseFirestore.instance.collection(StaticInfo.userCollection).doc(result.user!.uid).get();
        if(user.exists){
          UserModel userData=UserModel.fromJson(user);
          if(userData.userId=="UWWEUjkeQrUWeG3keifPjQZTrjH2" || userData.userEmail.toLowerCase().contains("admin")) {

           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AdminHomeScreen()), (route) => false);
          }else{

            Navigator.pushNamed(context, "/");

          }

        }

        }
    }catch (e){


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      print(e);
    }


  }


  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          Fluttertoast.showToast(msg: 'The account already exists with a different credential');
          // Fluttertoast
        }
        else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(msg: 'Error occurred while accessing credentials');
          // handle the error here
        }
      } catch (e) {
        // handle the error here 'Error occurred using Google Sign In. Try again.'
        Fluttertoast.showToast(msg: 'Error occurred using Google Sign In. Try again.');
      }
    }

    return user;
  }

  signInWithGoogleWeb() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // Initialize Firebase
    // await Firebase.initializeApp();
    User? user;

    // The `GoogleAuthProvider` can only be used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();


    try {
      final UserCredential userCredential =
      await _auth.signInWithPopup(authProvider);
      user = userCredential.user;
      printLog("user: ${user?.toString()} name: ${user?.displayName}");

      UserModel? userData;
      if (user != null) {
        String? userName;
        String? email;
        for (UserInfo userInfo in user.providerData) {
          email = userInfo.email;
          userName = userInfo.displayName;
        }

    userData=UserModel(
            userId: user.uid,
            userName: userName!,
            userEmail: email??"Unknown",
            userPassword: "",
            signinType: "Google Sign in"
        );
        // uid = user.uid;
        // name = user.displayName;
        // userEmail = user.email;
        // password = "Not Applicable";
        // signinType="Google Sign in";

      }

      if(userData!=null){
        return userData;
      }
      return user;



    } catch (e) {
      print(e);
    }
  }
}