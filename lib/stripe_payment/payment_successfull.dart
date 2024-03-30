
import 'package:app/model/subscription_model.dart';
import 'package:app/providers/subscription_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentSuccessful extends StatefulWidget {
  const PaymentSuccessful({super.key});

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {

  @override
  void initState() {
    // TODO: implement initState
    addSubscription();
    super.initState();
  }

  addSubscription()async{

    String docId='';
    bool paymentStatus;
    print("Add subscription is called");

    await FirebaseFirestore.instance.collection("Users").
    doc(FirebaseAuth.instance.currentUser!.uid).
  collection("subscriptions").get().then((query)async{
    print("subscription documents is not empty");
      if(query.docs.isNotEmpty){
        print("subscription documents is not empty");
        paymentStatus=query.docs.any((element){
          print(element);
          if(DateTime.parse(element[PremiumSubscriptionModelFields.subscriptionDate]).day==DateTime.now().day){
            docId=element.id;
            print("docId : ${docId}");
            return true;
          }else{
            return false;
          }
        });
        print("Payment status:${paymentStatus}");
        if(paymentStatus){
          await FirebaseFirestore.instance.collection("Users").
          doc(FirebaseAuth.instance.currentUser!.uid).
          collection("subscriptions").doc(docId).update({
            PremiumSubscriptionModelFields.subscriptionStatus:'success'
          }).then((value){
            Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
          });
        }


      }
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          color: Colors.white,
          // alignment: Alignment.center,
          child: const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator())

          // const Text("Subscription activated successfully, please wait we are setting you up...",style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}
