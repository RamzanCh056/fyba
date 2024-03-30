import 'package:app/consolePrintWithColor.dart';
import 'package:app/constants/app_sizes.dart';
import 'package:app/screens/privacy_policy/privacy.dart';
import 'package:app/stripe_payment/stripe_web.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../../constants/app_colors.dart';
import '../../stripe_payment/stripe_payment.dart';
import '../premium_membership/custom_list_tile.dart';


typedef _CheckoutSessionSnapshot = DocumentSnapshot<Map<String, dynamic>>;

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({

    super.key});


  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var list=terms.split(".");
    return Scaffold(
      body: Stack(
        children: [
          Container(

            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: responsiveWidth(60, context),vertical: 20),
            // padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: AppColors.mainDarkColor,
                border: Border.all(color: const Color(0xFFD4239B), width: 1)),
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context,index){
                  return Text("${list[index]}. ",style: const TextStyle(color: AppColors.whiteColor),);
                })

            // SingleChildScrollView(
            //   child: Text(terms,style: const TextStyle(color: AppColors.whiteColor),),
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.arrow_back,color: Colors.black,))),
          )
        ],
      ),
    );
  }

 
}
