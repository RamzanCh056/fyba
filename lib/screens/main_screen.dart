import 'dart:convert';

import 'package:app/ad_services/ad_widget.dart';
import 'package:app/consolePrintWithColor.dart';
import 'package:app/model/subscription_model.dart';
import 'package:app/model/user_model.dart';
import 'package:app/providers/basic_provider.dart';
import 'package:app/providers/user_provider.dart';
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

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  ///      ================> 28-May-2023 <===================
  ///      ================> Changes Begin <=================
  ///      Changes has been created for composite search
  ///      at left side widget and middle area widget

  ///       ===========> Data of Left Side widget <===========

  ///      ================> Changes Begin <=================

  String currentSetValue="";
  fetchSetValue()async{
    await FirebaseFirestore.instance.collection("Sets Value").doc("1").get().then((data){
      if(data.exists){
        currentSetValue=data["current set value"];
        Provider.of<UserProvider>(context,listen: false).updateSetValue(currentSetValue);
      }
    });
  }

  fetchPinnedComps()async{
    Provider.of<BasicProvider>(context,listen:false).fetchCurrentPinnedComp();
    var snap=await FirebaseFirestore.instance.collection(pinnedCompCollection).doc("0123").get();
    var pinnedCompData=jsonDecode(snap["compId"]);
    if(snap.exists && pinnedCompData.isNotEmpty){
      for(int i=0; i<pinnedCompData.length;i++){
        ChampModel champ=ChampModel.fromJson(pinnedCompData[i]);
        pinnedChamp.add(champ);
      }

      setState(() {
        pinnedChampFetched=true;
      });
      Future.delayed(const Duration(seconds: 5),(){
        pinnedChampFetched=false;
        setState(() {

        });
      });
    }else{
      setState(() {
        pinnedChampFetched=true;
      });
      Future.delayed(const Duration(seconds: 5),(){
        pinnedChampFetched=false;
        setState(() {

        });
      });
    }

  }

  bool pinnedChampFetched=false;
  List<ChampModel> pinnedChamp=[];

  bool isExpanded=false;


  bool showPremium=false;
  bool isSubscribed=false;

  showPremiumDialogue({required bool isInit})async{
    if(FirebaseAuth.instance.currentUser!=null){
      var userSubscription=await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("subscriptions").get();
      if(userSubscription.docs.isNotEmpty ) {
        printLog(">>>>>>>>>>>> Subscription exists");
        userSubscription.docs.any((element) {
          if (element["subscriptionStatus"]=="success" && DateTime.parse(
              element[PremiumSubscriptionModelFields.subscriptionExpiryDate])
              .isAfter(DateTime.now())) {
            showPremium = false;

            Fluttertoast.showToast(
                msg: "Already Subscribed", timeInSecForIosWeb: 3);
            isSubscribed = true;
            setState(() {

            });
            return true;
          }else if(isInit==false){
            showPremium=true;
            isSubscribed=false;
            setState(() {

            });
            return false;
          }else{
            return false;
          }
        });
      }
      else if(isInit==false){
        showPremium=true;
        isSubscribed=false;
        setState(() {

        });
        return false;
      }else{
        return false;
      }
    }else if(isInit==false){
      Fluttertoast.showToast(msg: "Signin or Register first to get subscription",timeInSecForIosWeb: 3);
      Navigator.pushNamed(context, "/signin");
      // showPremium=true;
      // printLog(">>>>>>>>>>>> Subscription Not exists");
      // setState(() {
      //
      // });
    }
  }
  

  @override
  void initState() {

    getCurrentUser();
    showPremiumDialogue(isInit: true);
    fetchPinnedComps();
    fetchSetValue();
    Provider.of<UserProvider>(context,listen: false).getUser();

    


    
    // TODO: implement initState
    super.initState();
  }

  UserModel? user;
  getCurrentUser()async{
    if(FirebaseAuth.instance.currentUser!=null) {
      var data=await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).get();
      if(data.exists){
        user=UserModel.fromJson(data);
        setState(() {

        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser!=null){

    }
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SafeArea(
        child: Stack(
          children: [
            const BackImageWidget(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// appbar
                AppBarWidget(
                  onPremiumButtonPressed: () {

                    showPremiumDialogue(isInit: false);

                  },
                isSubscribed: isSubscribed,
                isAdmin: user!=null && user!.userEmail.toLowerCase().contains("admin"),),

                /// Whole area container
                Expanded(
                  child: Container(
                    margin: ResponsiveWidget.isMobileScreen(context)?null:const EdgeInsets.symmetric(vertical: 20),
                    padding: ResponsiveWidget.isWebScreen(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 25)
                        : ResponsiveWidget.isTabletScreen(context)
                            ? const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 25)
                            : const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 5),
                    child: ResponsiveWidget.isWebScreen(context)
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              /// left side widget
                              ///
                              ///
                              ///
                              /// Requirement # 3
                              ///
                              /// All Changes done for requirement # 3
                              /// in the Left side Widget
                              /// All data stored on firebase was shown
                              /// in the below field
                              const Expanded(
                                flex: 3,
                                child: LeftSideWidget(),
                              ),

                              const SizedBox(width: 20),

                              /// Middle Area Widget
                              ///
                              /// Requirement # 4
                              ///
                              /// All Changes done for requirement # 4 is
                              /// in the Middle Widget
                              /// All data stored in comp collection in
                              /// firebase was shown here in popular field
                              ///
                              const Expanded(
                                flex: 11,
                                child: MiddleAreaWidget(),
                              ),

                              sizedBoxW20,

                              /// right side widget
                              isSubscribed?const SizedBox.shrink():const Expanded(
                                flex: 2,
                                child: RightSideWidget(),
                              ),
                            ],
                          )
                        : ResponsiveWidget.isTabletScreen(context)
                            ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// left side widget
                                  Expanded(
                                    flex: 3,
                                    child: LeftSideWidget(),
                                  ),

                                  sizedBoxW20,

                                  /// middle area widget
                                  const Expanded(
                                    flex: 9,
                                    child: MiddleAreaWidget(),
                                  ),

                                  sizedBoxW20,
                                ],
                              )
                    /// Mobile screen ui
                            : ListView(

                      physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  /// left side widget
                                  SizedBox(
                                    // height: height(context) * 0.4,
                                    child: LeftSideWidget(),
                                  ),

                                  sizedBoxH20,

                                  /// middle area widget
                                  MiddleAreaWidget(),

                                  sizedBoxH20,
                                ],
                              ),
                  ),
                ),
                // const SizedBox(height: 30,)
              ],
            ),
            pinnedChampFetched?
            ResponsiveWidget.isMobileScreen(context) ||ResponsiveWidget.isTabletScreen(context) ?
            const SizedBox.shrink():
            Padding(
              padding: const EdgeInsets.only(top: 25,left: 20),
              child: Container(
                height: ResponsiveWidget.isExtraWebScreen(context)?(
                    isExpanded?MediaQuery.of(context).size.height*.8:
                MediaQuery.of(context).size.height*.08):
                (
                    isExpanded?MediaQuery.of(context).size.height*.8:
                    MediaQuery.of(context).size.height*.2),
                width: isExpanded?MediaQuery.of(context).size.width*.6:
                MediaQuery.of(context).size.width*.4,
                decoration: BoxDecoration(
                    // color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.yellow,width: 1),
                    image: const DecorationImage(image: AssetImage('assets/images/login_bg.png'),fit: BoxFit.fill)
                ),
                child: InkWell(
                    onTap: (){
                      setState(() {
                        isExpanded=!isExpanded;
                      });
                    },
                    child: PinnedCompScreen(isExpanded:isExpanded,champList: pinnedChamp,compId: 'xx',)),
              ),
            )
                :const SizedBox.shrink(),

            showPremium?
                (ResponsiveWidget.isExtraWebScreen(context) ||
                ResponsiveWidget.isWebScreen(context))?
            Center(child: PremiumDesktopScreen(dismiss: (){setState(() {
              showPremium=false;
            });})):
                Center(child: PremiumMobile(dismiss: (){setState(() {
                  showPremium=false;
                });}),):
                const SizedBox.shrink(),

          ],
        ),
      ),
    );
  }
}
