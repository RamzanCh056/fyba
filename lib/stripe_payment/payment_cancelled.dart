
import 'package:app/model/subscription_model.dart';
import 'package:app/providers/subscription_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentCancelled extends StatefulWidget {
  const PaymentCancelled({super.key});

  @override
  State<PaymentCancelled> createState() => _PaymentCancelledState();
}

class _PaymentCancelledState extends State<PaymentCancelled> {

  @override
  void initState() {
    // TODO: implement initState
   addSubscription();
    super.initState();
  }


  addSubscription()async{

    String docId='';
    bool paymentStatus;

    await FirebaseFirestore.instance.collection("Users").
    doc(FirebaseAuth.instance.currentUser!.uid).
    collection("subscriptions").get().then((query)async{
      if(query.docs.isNotEmpty){
        paymentStatus=query.docs.any((element){
          if(DateTime.parse(element[PremiumSubscriptionModelFields.subscriptionDate]).day==DateTime.now().day){
            docId=element.id;
            return true;
          }else{
            return false;
          }
        });
        if(paymentStatus){
          await FirebaseFirestore.instance.collection("Users").
          doc(FirebaseAuth.instance.currentUser!.uid).
          collection("subscriptions").doc(docId).update({
            PremiumSubscriptionModelFields.subscriptionStatus:'cancelled'
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator()),
            SizedBox(height: 10,),
            Text("Subscription Not Successful, Please Try Again..."),
          ],
        ),
      ),
    );
  }
}
