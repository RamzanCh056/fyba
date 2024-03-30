import 'dart:convert';

import 'package:app/ad_services/ad_widget.dart';
import 'package:app/consolePrintWithColor.dart';
import 'package:app/providers/basic_provider.dart';
import 'package:app/screens/auth%20screens/login_screen.dart';
import 'package:app/screens/pinned_comp_screen/pinned_comp_screen.dart';
import 'package:app/screens/premium_membership/premium_desktop.dart';
import 'package:app/screens/premium_membership/premium_mobile.dart';
import 'package:app/screens/premium_membership/premium_membership.dart';
import 'package:app/services/Preferences%20%20Services/comp_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../constants/exports.dart';
import '../screens/components/app_bar_widget.dart';
import '../screens/components/left_side_widget.dart';
import '../screens/components/middle_area_widget.dart';
import '../screens/components/right_side_widget.dart';
import '../widgets/back_image_widget.dart';
import '../widgets/responsive_widget.dart';
import 'Admin/Model/api_data_model.dart';

class RiotCallBackScreen extends StatefulWidget {
  const RiotCallBackScreen({Key? key}) : super(key: key);

  @override
  State<RiotCallBackScreen> createState() => _RiotCallBackScreenState();
}

class _RiotCallBackScreenState extends State<RiotCallBackScreen> {




  @override
  void initState() {

    Future.delayed(const Duration(milliseconds: 500),(){
      Navigator.pushNamed(context, "/home");
    });


    
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      )
    );
  }
}
