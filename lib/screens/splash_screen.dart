
import 'package:app/model/user_model.dart';
import 'package:app/screens/auth%20screens/login_screen.dart';





import 'package:app/services/Preferences%20%20Services/rememberMePreferences.dart';
import 'package:app/services/firestore%20services/firebase_auth_services/auth_sevices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Static/static.dart';
import 'Admin/admin_homescreen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  initializeApp()async{
    print("I am initialize");
    String? email=await PreferencesServices().getEmailPreferences();
    String? password=await PreferencesServices().getPasswordPreferences();
    String? userId= await PreferencesServices().getUserIdPreferences();
    print(email);
    print(password);
    print(userId);
    if(email!=null && password!=null && email.isNotEmpty && password.isNotEmpty){
      await FirebaseAuthServices().signIn(email, password, context);
    }else{
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
    }
  }
  @override
  void initState() {
    initializeApp();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 45,horizontal: 80),
        decoration:const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.fill,
          ),

        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("FYBA",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.white),),
            SizedBox(height: 10,),
            Center(child: CircularProgressIndicator())
          ],
        ),
      ),
    );
  }
}
