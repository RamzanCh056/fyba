

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/subscription_model.dart';

class SubscriptionProvider extends ChangeNotifier{
 PremiumSubscriptionModel? subscription;

 addSubscription(PremiumSubscriptionModel sub)async{
  await FirebaseFirestore.instance.collection("Users").
  doc(FirebaseAuth.instance.currentUser!.uid).
  collection("subscriptions").doc(sub.subscriptionId).set(
     sub.toMap()
  );
 }

}