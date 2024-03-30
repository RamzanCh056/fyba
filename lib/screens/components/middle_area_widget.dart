import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:app/ad_services/ad_widget.dart';
import 'package:app/model/comp_model.dart';
import 'package:app/model/item_model.dart';
import 'package:app/providers/comp_provider.dart';
import 'package:app/screens/auth%20screens/login_screen.dart';
import 'package:app/services/Preferences%20%20Services/comp_preferences.dart';
import 'package:app/services/Preferences%20%20Services/preferences_keys.dart';
import 'package:app/services/Preferences%20%20Services/rememberMePreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../consolePrintWithColor.dart';
import '../../providers/basic_provider.dart';
import '../pinned_comp_screen/pinned_comp_screen.dart';
import '/Static/static.dart';
import '/screens/Admin/Model/admin_model.dart';
import '/screens/components/expand_item_widget.dart';
import '/screens/components/small_buttons.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/comp_list_provider.dart';
import '../../services/firestore services/firestore_comp_services.dart';
import '../Admin/Model/api_data_model.dart';
import 'team_builder/team_builder_main_screen.dart';
import 'neon_tab_button.dart';

class MiddleAreaWidget extends StatefulWidget {
  const MiddleAreaWidget({Key? key}) : super(key: key);

  @override
  State<MiddleAreaWidget> createState() => _MiddleAreaWidgetState();
}

class _MiddleAreaWidgetState extends State<MiddleAreaWidget> {

  String champList="champList";
  String compId="compId";
  bool dataFetched=false;

  List<Map<String,dynamic>> popularCompList=[];
  List<String> popularCompIds=[];
  List<String> currentUserCompIds=[];


  List<Map<String,dynamic>> currentUserCompList=[];

  checkCompUpdates()async{
    printLog("Check comp updates called");
    var compUpdate=await AppPreferencesServices().getCompUpdateDatesPreferences();
    var champUpdate=await AppPreferencesServices().getChampUpdateDatesPreferences();
    FirebaseFirestore.instance.collection("dataUpdate").doc("A7PYFjiHuEqT2jKMivKP").snapshots().listen((event)async{
      if(event.exists){
        printLog("Event data exists");
        DateTime compsUpdate=DateTime.parse(event.data()!["compsUpdate"]);
        DateTime champsUpdate=DateTime.parse(event.data()!["champsUpdate"]);
        printLog("${compUpdate==null||
            DateTime.parse(compUpdate).day!=compsUpdate.day ||
            DateTime.parse(compUpdate).month!=compsUpdate.month}");
        if(compUpdate==null||
            DateTime.parse(compUpdate).day!=compsUpdate.day ||
            DateTime.parse(compUpdate).month!=compsUpdate.month){
      }{

          initialize();

        }
    }});
  }

  checkUpdates()async{

    DocumentSnapshot updateData=await FirebaseFirestore.instance.collection("dataUpdate").doc("A7PYFjiHuEqT2jKMivKP").get();

    if(updateData.exists){
      DateTime compsUpdate=DateTime.parse(updateData["compsUpdate"]);
      DateTime champsUpdate=DateTime.parse(updateData["champsUpdate"]);

      var compUpdate=await AppPreferencesServices().getCompUpdateDatesPreferences();
      var champUpdate=await AppPreferencesServices().getChampUpdateDatesPreferences();

      if(compUpdate==null||
          DateTime.parse(compUpdate).day!=compsUpdate.day ||
          DateTime.parse(compUpdate).month!=compsUpdate.month){
        await AppPreferencesServices().setCompUpdateDatesPreferences(updateData["compsUpdate"]);
        await AppPreferencesServices().setChampUpdateDatesPreferences(updateData["champsUpdate"]);

        printLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> I am here to fetch firestore data");
        await fetchFirestoreData();
        await fetchMyTeamsData();
      }else{
        printLog(">>>>>>>>>>>>>>>>>>>>>>>>>>>>> I am here to fetch Saved data from local");
        var compData=await AppPreferencesServices().getPopularCompPreferences();
        var userCompData=await AppPreferencesServices().getUserCompPreferences();
        if(compData!=null){
          extractPopularComps(jsonDecode(compData));
        }
        if(userCompData!=null){
          extractUserComps(jsonDecode(userCompData));
        }else{
          await fetchMyTeamsData();
        }
      }



    }

  }

  fetchFirestoreData()async{

    print("Fetch firestore data is called");
    FirebaseFirestore instance=FirebaseFirestore.instance;
    QuerySnapshot compQuery=await instance.collection(compCollection).get();
    if(compQuery.docs.isNotEmpty){


      printLog("${compQuery}");
      List<Map<String, dynamic>> jsonData = [];
      for(int i=0;i<compQuery.docs.length;i++){
        jsonData.add(compQuery.docs[i].data() as Map<String,dynamic>);

      }
      printLog("Comp query= ${jsonData}");


      AppPreferencesServices().setPopularCompPreferences(jsonEncode(jsonData));
      extractPopularComps(compQuery.docs);



    }
    else if(compQuery.docs.isEmpty){
      // dataFetched=true;
      //
      setState(() {

      });
    }


  }

  fetchMyTeamsData()async{
    printLog("Fetch my teams data called==========<<<<<>>>> ");
    printLog("Fetch my teams data called==========<<<<<>>>>${FirebaseAuth.instance.currentUser!=null} ");
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore instance=FirebaseFirestore.instance;
      QuerySnapshot compQuery=await instance.collection(StaticInfo.userCollection).
      doc(FirebaseAuth.instance.currentUser!.uid).collection(compCollection).get();
      if(compQuery.docs.isNotEmpty){
        printLog("${compQuery}");
        List<Map<String, dynamic>> jsonData = [];
        for(int i=0;i<compQuery.docs.length;i++){
          jsonData.add(compQuery.docs[i].data() as Map<String,dynamic>);

        }
        printLog("Comp query= ${jsonData}");


        AppPreferencesServices().setUserCompPreferences(jsonEncode(jsonData));
        extractUserComps(compQuery.docs);
      }
      else if(compQuery.docs.isEmpty){
        dataFetched=true;

        setState(() {

        });
      }
    }else{
      dataFetched=true;

      setState(() {

      });
    }

  }

  extractUserComps(compQuery){



      for(int i=0;i<compQuery.length;i++){
        List<ChampModel> championsList=[];
        for(int j=0;j<compQuery[i]["champList"].length;j++){
          ChampModel champ=ChampModel.fromJson(compQuery[i]["champList"][j]);
          printLog(champ.champName);
          championsList.add(champ);
          printLog("ChampList : ${champList.length}");
        }
        currentUserCompIds.add(compQuery[i]["docId"]);

        Map<String,dynamic> comp={
          "compId":compQuery[i]["docId"],
          "champList":championsList
        };
        // printLog(compQuery.docs[i]["champList"][""]);
        currentUserCompList.add(comp);

        printLog("=============<<>>>> Current User complist Length:${currentUserCompList.length}");

      }
      Provider.of<BasicProvider>(context,listen: false).currentUserCompList=currentUserCompList;

      // champList.clear();



    setState(() {
      dataFetched=true;
    });
  }

  extractPopularComps(compQuery){



    for(int i=0;i<compQuery.length;i++){
      List<ChampModel> championsList=[];
      for(int j=0;j<compQuery[i]["champList"].length;j++){
        ChampModel champ=ChampModel.fromJson(compQuery[i]["champList"][j]);
        printLog(champ.champName);
        championsList.add(champ);
        printLog("ChampList : ${champList.length}");
      }
      popularCompIds.add(compQuery[i]["docId"]);

      Map<String,dynamic> comp={
        "compId":compQuery[i]["docId"],
        "champList":championsList
      };
      // printLog(compQuery.docs[i]["champList"][""]);
      popularCompList.add(comp);
      Provider.of<BasicProvider>(context,listen: false).popularCompList=popularCompList;

      printLog("=============<<>>>> Current User complist Length:${currentUserCompList.length}");

    }





    // champList.clear();



    setState(() {
      dataFetched=true;
    });
  }

  bool isPopular=true;

  initialize()async{
    popularCompList.clear();
    popularCompIds.clear();
    currentUserCompIds.clear();

    currentUserCompList.clear();
    await checkUpdates();
    // checkCompUpdates();

    // await fetchFirestoreData();
    // await fetchMyTeamsData();

  }


  bool parentScrolling=true;
  ScrollController _childScrollController=ScrollController();
  @override
  void initState() {

    initialize();
    super.initState();
  }

  bool one = false;
  @override
  Widget build(BuildContext context) {
    return


      ResponsiveWidget.isExtraWebScreen(context)
          ? Stack(
        children: [
          /// top tab and buttons
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: width(context) * 0.04),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                /// popular btn
                NeonTabButtonWidget(
                  onTap: () async{
                    if(!isPopular){
                      // await fetchFirestoreData();
                      setState(() {
                        isPopular=true;
                      });
                    }

                  },
                  gradient: isPopular?LinearGradient(
                    colors: [
                      AppColors.skyBorderColor,
                      AppColors.skyBorderColor.withOpacity(0.2),
                      AppColors.skyBorderColor.withOpacity(0.0),
                      AppColors.skyBorderColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ):const LinearGradient(
                    colors: [
                      AppColors.mainDarkColor,
                      AppColors.mainDarkColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  btnHeight: 55,
                  btnWidth: width(context) * 0.1,
                  btnText: 'Popular',
                ),
                const SizedBox(width: 17),

                /// my team btn
                NeonTabButtonWidget(
                  onTap: () {
                    if(isPopular){
                      // fetchFirestoreMyTeamsData();
                      setState(() {
                        isPopular=false;
                      });
                    }

                  },
                  gradient: isPopular?const LinearGradient(
                    colors: [
                      AppColors.mainDarkColor,
                      AppColors.mainDarkColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ):LinearGradient(
                    colors: [
                      AppColors.skyBorderColor,
                      AppColors.skyBorderColor.withOpacity(0.2),
                      AppColors.skyBorderColor.withOpacity(0.0),
                      AppColors.skyBorderColor.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  btnHeight: 55,
                  btnWidth: width(context) * 0.1,
                  btnText: 'My Teams',
                  btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                ),

                const Spacer(),

                ///
                /// 16-May-2023
                /// Requirement #4
                /// Tier up, Tier down,New Tier buttons are removed
                /// Team builder button is added
                ///
                SmallButtons(
                  onTap: () async{
                    if(FirebaseAuth.instance.currentUser!=null){

                      Provider.of<BasicProvider>(context,listen: false).updateVisibleFromFirebase();

                      // Provider.of<BasicProvider>(context,listen: false).foundData.clear();
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamBuilderScreen()));

                    }else{
                      showDialog(context: context,
                          builder: (context){
                        return AlertDialog(
                          content: const Text("You are not logged in, please login to create team"),
                          actions: [
                            TextButton(
                                onPressed: (){
                                  Navigator.pushNamed(context, "/signin");
                                },
                                child: const Text("Login")),
                            TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                  },
                                child: const Text("Cancel"))
                          ],
                        );
                          });


                    }

                  },
                  iconPath: AppIcons.tierUp,
                  btnText: 'Team Builder',
                  btnColor: AppColors.orangeDarkColor,

                ),
                // const SizedBox(width: 10),
                // SmallButtons(
                //   onTap: () {},
                //   iconPath: AppIcons.tierDown,
                //   btnText: 'Tier Down',
                //   btnColor: AppColors.redDarkColor,
                // ),
                // const SizedBox(width: 10),
                // SmallButtons(
                //   onTap: () {},
                //   iconPath: AppIcons.addIcon,
                //   btnText: 'New Tier',
                //   btnColor: AppColors.skyDarkColor,
                // ),
              ],
            ),
          ),

          ///
          Container(
              height: height(context),
              width: width(context),
              margin: const EdgeInsets.only(top: 36),
              decoration: middleBoxDecoration(context),
              ///
              ///
              /// Here we are showing the data fetched from firebase
              ///

              // child: compCollectionList.isNotEmpty?
              child:
              isPopular && dataFetched?SizedBox(
                child:  dataFetched==true && popularCompList.isNotEmpty ?
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: const Color(0x00ffffff),
                    shadowColor: const Color(0x00ffffff),
                  ),
                  child: ReorderableListView(
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    buildDefaultDragHandles: false,

                    onReorder: (int oldIndex, int newIndex) {

                      setState(() {
                        if (oldIndex < newIndex) {

                          newIndex -= 1;
                        }

                        Map<String,dynamic> comp=popularCompList.removeAt(oldIndex);
                        popularCompList.insert(newIndex, comp);

                      });
                    },
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    children: [
                      if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                        for(int i=0; i<popularCompList.length;i++)
                          Stack(
                            // key: Key(popularCompList[i][compId]),
                            key: UniqueKey(),
                            children: [
                              ExpandItemWidget(

                                  compId: popularCompList[i][compId],
                                  champList: popularCompList[i][champList]),
                              Padding(
                                padding: EdgeInsets.only(top:35,right: 100),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ReorderableDragStartListener(

                                      index: i,
                                      child: const Icon(Icons.drag_handle,color:Colors.white)),
                                ),
                              )
                            ],
                          )
                      ]
                      else...[
                        for(int i=0; i<popularCompList.length;i++)...[
                          if(popularCompList[i]["champList"].any((element) =>

                              Provider.of<BasicProvider>(context).foundData.any((foundElement){

                                return element.champName==foundElement.champName;
                              })))...[
                            Stack(
                              // key: Key(popularCompList[i][compId]),
                              key: UniqueKey(),
                              children: [
                                ExpandItemWidget(

                                    compId: popularCompList[i][compId],
                                    champList: popularCompList[i][champList]),
                                Padding(
                                  padding: EdgeInsets.only(top:35,right: 100),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ReorderableDragStartListener(

                                        index: i,
                                        child: const Icon(Icons.drag_handle,color:Colors.white)),
                                  ),
                                )
                              ],
                            )
                          ]


                        ]

                      ]



                    ],
                    // children: [
                    //
                    //
                    //   ExpandItemW\idget(),
                    // ],
                  ),
                ):dataFetched==true && popularCompList.isEmpty ?
                const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                const Center(child: CircularProgressIndicator(color: Colors.white,)),
              ):
              !isPopular && dataFetched?SizedBox(
                child:  dataFetched==true && currentUserCompList.isNotEmpty ?
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: const Color(0x00ffffff),
                    shadowColor: const Color(0x00ffffff),
                  ),
                  child: ReorderableListView(
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    buildDefaultDragHandles: false,

                    onReorder: (int oldIndex, int newIndex) {

                      setState(() {
                        if (oldIndex < newIndex) {

                          newIndex -= 1;
                        }
                        Map<String,dynamic> comp=currentUserCompList.removeAt(oldIndex);
                        currentUserCompList.insert(newIndex, comp);
                      });
                    },
                    // itemCount: docIds.length,
                    // itemBuilder: (context,index){
                    //   return
                    children: [
                      if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                        for(int i=0; i<currentUserCompList.length;i++)
                          Stack(
                            key: UniqueKey(),
                            children: [
                              ExpandItemWidget(

                                  compId: currentUserCompList[i][compId],
                                  champList: currentUserCompList[i][champList]),
                              Padding(
                                padding: const EdgeInsets.only(top:35,right: 100),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ReorderableDragStartListener(
                                      index: i,
                                      child: const Icon(Icons.drag_handle,color:Colors.white)),
                                ),
                              )
                            ],
                          )
                      ]
                      else...[
                        for(int i=0; i<currentUserCompList.length;i++)...[
                          if(currentUserCompList[i]["champList"].any((element) =>

                              Provider.of<BasicProvider>(context).foundData.any((foundElement){

                                return element.champName==foundElement.champName;
                              })))...[
                            Stack(
                              key: UniqueKey(),
                              children: [
                                ExpandItemWidget(
                                  // champItems: popularCompList[i]["champList"],
                                    compId:currentUserCompList[i]["compId"],
                                    champList: currentUserCompList[i]["champList"]),
                                Padding(
                                  padding: const EdgeInsets.only(top:40,right: 100),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ReorderableDragStartListener(
                                        key: UniqueKey(),index: i,
                                        child: const Icon(Icons.drag_handle,color:Colors.white)),
                                  ),
                                )
                              ],
                            )
                          ]


                        ]

                      ]

                    ],
                    // children: [
                    //
                    //
                    //   ExpandItemW\idget(),
                    // ],
                  ),
                ):dataFetched==true && currentUserCompList.isEmpty ?
                const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                const Center(child: CircularProgressIndicator(color: Colors.white,)),
              ):
              const Center(child: SizedBox(height:30,width:30,child: CircularProgressIndicator()))


          ),


        ],
      ):
      ResponsiveWidget.isWebScreen(context)
        ? Stack(
            children: [
              /// top tab and buttons
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: width(context) * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// popular btn
                    NeonTabButtonWidget(
                      onTap: () async{
                        if(!isPopular){
                          // await fetchFirestoreData();
                          setState(() {
                            isPopular=true;
                          });
                        }

                      },
                      gradient: isPopular?LinearGradient(
                        colors: [
                          AppColors.skyBorderColor,
                          AppColors.skyBorderColor.withOpacity(0.2),
                          AppColors.skyBorderColor.withOpacity(0.0),
                          AppColors.skyBorderColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ):const LinearGradient(
                        colors: [
                          AppColors.mainDarkColor,
                          AppColors.mainDarkColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      btnHeight: 55,
                      btnWidth: width(context) * 0.1,
                      btnText: 'Popular',
                    ),
                    const SizedBox(width: 17),

                    /// my team btn
                    NeonTabButtonWidget(
                      onTap: () {
                        if(isPopular){
                          // fetchFirestoreMyTeamsData();
                          setState(() {
                            isPopular=false;
                          });
                        }

                      },
                      gradient: isPopular?const LinearGradient(
                        colors: [
                          AppColors.mainDarkColor,
                          AppColors.mainDarkColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ):LinearGradient(
                        colors: [
                          AppColors.skyBorderColor,
                          AppColors.skyBorderColor.withOpacity(0.2),
                          AppColors.skyBorderColor.withOpacity(0.0),
                          AppColors.skyBorderColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      btnHeight: 55,
                      btnWidth: width(context) * 0.1,
                      btnText: 'My Teams',
                      btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                    ),

                    const Spacer(),

                    ///
                    /// 16-May-2023
                    /// Requirement #4
                    /// Tier up, Tier down,New Tier buttons are removed
                    /// Team builder button is added
                    ///
                    SmallButtons(
                      onTap: () async{
                        if(FirebaseAuth.instance.currentUser!=null){

                          Provider.of<BasicProvider>(context,listen: false).updateVisibleFromFirebase();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamBuilderScreen()));

                        }else{
                          showDialog(context: context,
                              builder: (context){
                                return AlertDialog(
                                  content: const Text("You are not logged in, please login to create team"),
                                  actions: [
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pushNamed(context, "/signin");
                                        },
                                        child: const Text("Login")),
                                    TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                );
                              });
                        }

                      },
                      iconPath: AppIcons.tierUp,

                      btnText: 'Team Builder',
                      btnColor: AppColors.orangeDarkColor,

                    ),
                    // const SizedBox(width: 10),
                    // SmallButtons(
                    //   onTap: () {},
                    //   iconPath: AppIcons.tierDown,
                    //   btnText: 'Tier Down',
                    //   btnColor: AppColors.redDarkColor,
                    // ),
                    // const SizedBox(width: 10),
                    // SmallButtons(
                    //   onTap: () {},
                    //   iconPath: AppIcons.addIcon,
                    //   btnText: 'New Tier',
                    //   btnColor: AppColors.skyDarkColor,
                    // ),
                  ],
                ),
              ),

              ///
              Container(
                height: height(context),
                width: width(context),
                margin: const EdgeInsets.only(top: 36),
                decoration: middleBoxDecoration(context),
                ///
                ///
                /// Here we are showing the data fetched from firebase
                ///

                // child: compCollectionList.isNotEmpty?
                child:
                    isPopular && dataFetched?SizedBox(
                    child:  dataFetched==true && popularCompList.isNotEmpty ?
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0x00ffffff),
                        shadowColor: const Color(0x00ffffff),
                      ),
                      child: ReorderableListView(

                        // itemCount: docIds.length,
                        // itemBuilder: (context,index){
                        //   return
                        buildDefaultDragHandles: false,
                        shrinkWrap: true,

                        onReorder: (int oldIndex, int newIndex) {

                          setState(() {
                            if (oldIndex < newIndex) {

                              newIndex -= 1;
                            }

                            Map<String,dynamic> newComp=popularCompList.removeAt(oldIndex);
                            popularCompList.insert(newIndex, newComp);

                          });
                        },

                        children: [
                          if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                            for(int i=0; i<popularCompList.length;i++)
                              Stack(
                                key: UniqueKey(),
                                children: [
                                  ExpandItemWidget(
                                      compId:  popularCompIds[i],
                                      champList: popularCompList[i]["champList"]),
                                  Padding(
                                    padding: const EdgeInsets.only(top:40,right: 100),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: ReorderableDragStartListener(

                                          index: i,
                                          child: const Icon(Icons.drag_handle,color:Colors.white)),
                                    ),
                                  )
                                ],
                              )
                          ]
                          else...[
                            for(int i=0; i<popularCompList.length;i++)...[
                              if(popularCompList[i]["champList"].any((element) =>

                                  Provider.of<BasicProvider>(context).foundData.any((foundElement){
                                    printLog("$popularCompList");
                                    print("${element} == ${foundElement.champName}");
                                    print(element.champName==foundElement.champName);
                                    print(i);
                                    return element.champName==foundElement.champName;
                                  })))...[
                                Stack(
                                  key: UniqueKey(),
                                  children: [
                                    ExpandItemWidget(
                                        // champItems: popularCompList[i]["champList"],
                                        compId:popularCompList[i]["compId"],
                                        champList: popularCompList[i]["champList"]),
                                    Padding(
                                      padding: const EdgeInsets.only(top:40,right: 100),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: ReorderableDragStartListener(
                                            key: UniqueKey(),index: i,
                                            child: const Icon(Icons.drag_handle,color:Colors.white)),
                                      ),
                                    )
                                  ],
                                )
                              ]


                            ]

                          ]

                        ],
                        // children: [
                        //
                        //
                        //   ExpandItemW\idget(),
                        // ],
                      ),
                    ):dataFetched==true && popularCompList.isEmpty ?
                    const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                    const Center(child: CircularProgressIndicator(color: Colors.white,)),
                    ):
                    !isPopular && dataFetched?SizedBox(
                      child:  dataFetched==true && currentUserCompList.isNotEmpty ?
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: const Color(0x00ffffff),
                          shadowColor: const Color(0x00ffffff),
                        ),
                        child: ReorderableListView(


                          buildDefaultDragHandles: false,

                          onReorder: (int oldIndex, int newIndex) {

                            setState(() {
                              if (oldIndex < newIndex) {
                                print(newIndex);
                                newIndex -= 1;
                              }

                              Map<String,dynamic> newComp=currentUserCompList.removeAt(oldIndex);

                              currentUserCompList.insert(newIndex, newComp);

                            });
                          },

                          children: [

                            if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                              for(int i=0; i<currentUserCompList.length;i++)
                                Stack(
                                  key: UniqueKey(),
                                  children: [
                                    ExpandItemWidget(
                                        compId: currentUserCompIds[i],
                                        champList: currentUserCompList[i]["champList"]),
                                    Padding(
                                      padding: const EdgeInsets.only(top:40,right: 100),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: ReorderableDragStartListener(
                                            index: i,
                                            child: const Icon(Icons.drag_handle,color:Colors.white)),
                                      ),
                                    )
                                  ],
                                )
                            ]
                            else...[
                              for(int i=0; i<currentUserCompList.length;i++)...[
                                if(currentUserCompList[i]["champList"].any((element) =>

                                    Provider.of<BasicProvider>(context).foundData.any((foundElement){

                                      return element.champName==foundElement.champName;
                                    })))...[
                                  Stack(
                                    key: UniqueKey(),
                                    children: [
                                      ExpandItemWidget(
                                          compId: currentUserCompIds[i],
                                          champList: currentUserCompList[i]["champList"]),
                                      Padding(
                                        padding: const EdgeInsets.only(top:40,right: 100),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: ReorderableDragStartListener(
                                              index: i,
                                              child: const Icon(Icons.drag_handle,color:Colors.white)),
                                        ),
                                      )
                                    ],
                                  )
                                ]
                              ]
                            ]

                          ]
                          // children: [
                          //
                          //
                          //   ExpandItemW\idget(),
                          // ],
                        ),
                      ):dataFetched==true && currentUserCompList.isEmpty ?
                      const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                      const Center(child: CircularProgressIndicator(color: Colors.white,)),
                    ):
                        const Center(child: SizedBox(height:30,width:30,child: CircularProgressIndicator()))


              ),

              ],
          )
        : ResponsiveWidget.isTabletScreen(context) || height(context)>1400
            ?

      ListView(
        physics: const NeverScrollableScrollPhysics(),
                children: [
                  /// top tab and buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// popular btn
                      NeonTabButtonWidget(
                        onTap: () async{
                          if(!isPopular){
                            // await fetchFirestoreData();
                            setState(() {
                              isPopular=true;
                            });
                          }

                        },
                        gradient: isPopular?LinearGradient(
                          colors: [
                            AppColors.skyBorderColor,
                            AppColors.skyBorderColor.withOpacity(0.2),
                            AppColors.skyBorderColor.withOpacity(0.0),
                            AppColors.skyBorderColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ):const LinearGradient(
                          colors: [
                            AppColors.mainDarkColor,
                            AppColors.mainDarkColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        btnHeight: 55,
                        btnWidth: width(context) * 0.1,
                        btnText: 'Popular',
                      ),
                      const SizedBox(width: 17),

                      /// my team btn
                      NeonTabButtonWidget(
                        onTap: () {
                          if(isPopular){
                            // fetchFirestoreMyTeamsData();
                            setState(() {
                              isPopular=false;
                            });
                          }

                        },
                        gradient: isPopular?const LinearGradient(
                          colors: [
                            AppColors.mainDarkColor,
                            AppColors.mainDarkColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ):LinearGradient(
                          colors: [
                            AppColors.skyBorderColor,
                            AppColors.skyBorderColor.withOpacity(0.2),
                            AppColors.skyBorderColor.withOpacity(0.0),
                            AppColors.skyBorderColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        btnHeight: 55,
                        btnWidth: width(context) * 0.1,
                        btnText: 'My Teams',
                        btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                      ),
                      // SizedBox(width: width(context)*.22),
                      // const Spacer(),
                      Spacer(),
                      ///
                      /// 16-May-2023
                      /// Requirement #4
                      /// Tier up, Tier down,New Tier buttons are removed
                      /// Team builder button is added
                      ///
                      SmallButtons(
                        onTap: () async{
                          if(FirebaseAuth.instance.currentUser!=null){
                            String email=await PreferencesServices().getEmailPreferences();
                            Provider.of<BasicProvider>(context,listen: false).updateVisibleFromFirebase();

                            // Provider.of<BasicProvider>(context,listen: false).foundData.clear();
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamBuilderScreen()));
                          }else{
                            showDialog(context: context,
                                builder: (context){
                                  return AlertDialog(
                                    content: const Text("You are not logged in, please login to create team"),
                                    actions: [
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pushNamed(context, "/signin");
                                          },
                                          child: const Text("Login")),
                                      TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"))
                                    ],
                                  );
                                });}

                        },
                        isTablet: true,
                        // isMobile: true,
                        iconPath: AppIcons.tierUp,
                        btnText: 'Team Builder',
                        btnColor: AppColors.orangeDarkColor,

                      ),
                      // const SizedBox(width: 10),
                      // SmallButtons(
                      //   onTap: () {},
                      //   iconPath: AppIcons.tierDown,
                      //   btnText: 'Tier Down',
                      //   btnColor: AppColors.redDarkColor,
                      // ),
                      // const SizedBox(width: 10),
                      // SmallButtons(
                      //   onTap: () {},
                      //   iconPath: AppIcons.addIcon,
                      //   btnText: 'New Tier',
                      //   btnColor: AppColors.skyDarkColor,
                      // ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  // SmallButtons(
                  //   onTap: () async{
                  //     String email=await PreferencesServices().getEmailPreferences();
                  //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                  //     if(email.contains('admin')) {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen(isAdmin: true,)));
                  //     }else{
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen(isAdmin: false,)));
                  //     }
                  //   },
                  //   iconPath: AppIcons.tierUp,
                  //   btnText: 'Team Builder',
                  //   btnColor: AppColors.orangeDarkColor,
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     /// btns
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.tierUp,
                  //         btnText: 'Tier Up',
                  //         btnColor: AppColors.orangeDarkColor,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.tierDown,
                  //         btnText: 'Tier Down',
                  //         btnColor: AppColors.redDarkColor,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: SmallButtons(
                  //         onTap: () {},
                  //         iconPath: AppIcons.addIcon,
                  //         btnText: 'New Tier',
                  //         btnColor: AppColors.skyDarkColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  ///
                  ///

                  Container(
                      height: ResponsiveWidget.isTabletScreen(context) && height(context)<1400?
                      height(context)*.54:height(context)*.86,
                      width: width(context),
                      margin: const EdgeInsets.only(top: 36),
                      decoration: middleBoxDecoration(context),
                      ///
                      ///
                      /// Here we are showing the data fetched from firebase
                      ///

                      // child: compCollectionList.isNotEmpty?
                      child:
                      isPopular && dataFetched?SizedBox(
                        child:  dataFetched==true && popularCompList.isNotEmpty ?
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color(0x00ffffff),
                            shadowColor: const Color(0x00ffffff),
                          ),
                          child: ReorderableListView(

                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            buildDefaultDragHandles: false,

                            onReorder: (int oldIndex, int newIndex) {

                              setState(() {
                                if (oldIndex < newIndex) {
                                  print(newIndex);
                                  newIndex -= 1;
                                }

                                // CompCollectionModel compDrag=compCollectionList.removeAt(oldIndex);


                                Map<String,dynamic> newComp=popularCompList.removeAt(oldIndex);
                                popularCompList.insert(newIndex, newComp);


                                // final String newDocId = docIds.removeAt(oldIndex);
                                // docIds.insert(newIndex, newDocId);
                              });
                            },
                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            children: [
                              if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                                for(int i=0; i<popularCompList.length;i++)
                                  Stack(
                                    key: UniqueKey(),
                                    children: [
                                      ExpandItemWidget(

                                          compId: popularCompList[i]["compId"],
                                          champList: popularCompList[i]["champList"]),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top:height(context)>1200?height(context)*.022:
                                            height(context)<=1200 &&height(context)>=700?height(context)*.1:
                                            height(context)*.048,

                                            right:
                                            width(context)>=700&&width(context)<=800?width(context)*.12:
                                            width(context)>800&&width(context)<=1000?width(context)*.107:
                                            width(context)>1000?width(context)*.09:width(context)*.1
                                        ),
                                        child: Align(
                                          heightFactor: 1.9,
                                          alignment: Alignment.centerRight,
                                          child: ReorderableDragStartListener(

                                              index: i,
                                              child: const Icon(Icons.drag_handle,color:Colors.white)),
                                        ),
                                      )
                                    ],
                                  )
                              ]
                              else...[
                                for(int i=0; i<popularCompList.length;i++)...[
                                  if(popularCompList[i]["champList"].any((element) =>

                                      Provider.of<BasicProvider>(context).foundData.any((foundElement){
                                        printLog("$popularCompList");
                                        print("${element} == ${foundElement.champName}");
                                        print(element.champName==foundElement.champName);
                                        print(i);
                                        return element.champName==foundElement.champName;
                                      })))...[
                                    Stack(
                                      key: UniqueKey(),
                                      children: [
                                        ExpandItemWidget(

                                            compId: popularCompList[i]["compId"],
                                            champList: popularCompList[i]["champList"]),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top:height(context)>1200?height(context)*.022:
                                              height(context)<=1200 &&height(context)>=700?height(context)*.1:
                                              height(context)*.048,

                                              right:
                                              width(context)>=700&&width(context)<=800?width(context)*.12:
                                              width(context)>800&&width(context)<=1000?width(context)*.107:
                                              width(context)>1000?width(context)*.09:width(context)*.1
                                          ),
                                          child: Align(
                                            heightFactor: 1.9,
                                            alignment: Alignment.centerRight,
                                            child: ReorderableDragStartListener(

                                                index: i,
                                                child: const Icon(Icons.drag_handle,color:Colors.white)),
                                          ),
                                        )
                                      ],
                                    )
                                  ]
                                ]
                              ]



                            ],

                          ),
                        ):dataFetched==true && popularCompList.isEmpty ?
                        const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                        const Center(child: CircularProgressIndicator(color: Colors.white,)),
                      ):
                      !isPopular && dataFetched?SizedBox(
                        child:  dataFetched==true && currentUserCompList.isNotEmpty ?
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color(0x00ffffff),
                            shadowColor: const Color(0x00ffffff),
                          ),
                          child: ReorderableListView(


                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            buildDefaultDragHandles: false,

                            onReorder: (int oldIndex, int newIndex) {

                              setState(() {
                                if (oldIndex < newIndex) {
                                  print(newIndex);
                                  newIndex -= 1;
                                }
                                Map<String,dynamic> newComp=currentUserCompList.removeAt(oldIndex);
                                currentUserCompList.insert(newIndex, newComp);
                              });
                            },
                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            children: [
                              if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                                for(int i=0; i<currentUserCompList.length;i++)
                                  Stack(
                        key: UniqueKey(),
                        children: [
                          ExpandItemWidget(

                              compId: currentUserCompList[i]["compId"],
                              champList: currentUserCompList[i]["champList"]),
                          Padding(
                            padding:EdgeInsets.only(top:height(context)>1400?height(context)*.022:height(context)*.048,
                                right:
                                width(context)>=700&&width(context)<=800?width(context)*.12:
                                width(context)>800&&width(context)<=1000?width(context)*.107:
                                width(context)>1000?width(context)*.09:width(context)*.1
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ReorderableDragStartListener(
                                  index: i,
                                  child: const Icon(Icons.drag_handle,color:Colors.white)),
                            ),
                          )
                        ],
                      )
                              ]
                              else...[
                                for(int i=0; i<currentUserCompList.length;i++)...[
                                  if(currentUserCompList[i]["champList"].any((element) =>

                                      Provider.of<BasicProvider>(context).foundData.any((foundElement){

                                        return element.champName==foundElement.champName;
                                      })))...[
                                    Stack(
                                      key: UniqueKey(),
                                      children: [
                                        ExpandItemWidget(

                                            compId: currentUserCompList[i]["compId"],
                                            champList: currentUserCompList[i]["champList"]),
                                        Padding(
                                          padding:EdgeInsets.only(top:height(context)>1400?height(context)*.022:height(context)*.048,
                                              right:
                                              width(context)>=700&&width(context)<=800?width(context)*.12:
                                              width(context)>800&&width(context)<=1000?width(context)*.107:
                                              width(context)>1000?width(context)*.09:width(context)*.1
                                          ),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ReorderableDragStartListener(
                                                index: i,
                                                child: const Icon(Icons.drag_handle,color:Colors.white)),
                                          ),
                                        )
                                      ],
                                    )
                                  ]
                                ]
                            ],
                            ]
                          ),
                        ):dataFetched==true && currentUserCompList.isEmpty ?
                        const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                        const Center(child: CircularProgressIndicator(color: Colors.white,)),
                      ):
                      const Center(child: SizedBox(height:30,width:30,child: CircularProgressIndicator()))


                  ),



                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  /// top tab and buttons
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      /// popular btn
                      Spacer(),
                      NeonTabButtonWidget(
                        onTap: () {
                          setState(() {
                            isPopular=true;
                          });
                        },
                        gradient: isPopular?LinearGradient(
                          colors: [
                            AppColors.skyBorderColor,
                            AppColors.skyBorderColor.withOpacity(0.2),
                            AppColors.skyBorderColor.withOpacity(0.0),
                            AppColors.skyBorderColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ):const LinearGradient(
                            colors: [
                            AppColors.mainDarkColor,
                            AppColors.mainDarkColor,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            ),
                        btnHeight: 40,
                        btnWidth: 100,
                        btnText: 'Popular',
                      ),
                      const SizedBox(width: 20),
                      /// my team btn
                      NeonTabButtonWidget(
                        onTap: () {
                          if(!isPopular){

                          }else{
                            setState(() {
                              isPopular=false;
                            });
                          }
                        },
                        gradient: !isPopular?LinearGradient(
                          colors: [
                            AppColors.skyBorderColor,
                            AppColors.skyBorderColor.withOpacity(0.2),
                            AppColors.skyBorderColor.withOpacity(0.0),
                            AppColors.skyBorderColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,):
                        const LinearGradient(
                          colors: [
                            AppColors.mainDarkColor,
                            AppColors.mainDarkColor,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        btnHeight: 40,
                        btnWidth: 100,
                        btnText: 'My Teams',
                        btnTextColor: AppColors.whiteColor.withOpacity(0.4),
                      ),
                      Spacer()
                    ],
                  ),
                  const SizedBox(height: 10),
                  SmallButtons(
                    onTap: () async{
                      if(FirebaseAuth.instance.currentUser!=null){
                        String email=await PreferencesServices().getEmailPreferences();
                        Provider.of<BasicProvider>(context,listen: false).updateVisibleFromFirebase();

                        // Provider.of<BasicProvider>(context,listen: false).foundData.clear();
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>const TeamBuilderScreen()));
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TeamBuilderScreen()));
                      }else{
                        showDialog(context: context,
                            builder: (context){
                              return AlertDialog(
                                content: const Text("You are not logged in, please login to create team"),
                                actions: [
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context, "/signin");
                                      },
                                      child: const Text("Login")),
                                  TextButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"))
                                ],
                              );
                            });}

                    },
                    iconPath: AppIcons.tierUp,
                    isMobile: true,
                    btnText: 'Team Builder',
                    btnColor: AppColors.orangeDarkColor,

                  ),

                  Container(
                      // height: height(context)*.6,
                      width: width(context),
                      margin: const EdgeInsets.only(top: 36),
                      decoration: middleBoxDecoration(context),
                      ///
                      ///
                      /// Here we are showing the data fetched from firebase
                      ///

                      // child: compCollectionList.isNotEmpty?
                      child:
                      isPopular && dataFetched?SizedBox(
                        child:  dataFetched==true && popularCompList.isNotEmpty ?
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color(0x00ffffff),
                            shadowColor: const Color(0x00ffffff),
                          ),
                          child: ReorderableListView(

                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            shrinkWrap: true,
                            buildDefaultDragHandles: false,
                            physics: NeverScrollableScrollPhysics(),

                            onReorder: (int oldIndex, int newIndex) {

                              setState(() {
                                if (oldIndex < newIndex) {
                                  print(newIndex);
                                  newIndex -= 1;
                                }

                                Map<String,dynamic> newComp=popularCompList.removeAt(oldIndex);
                                popularCompList.insert(newIndex, newComp);

                              });
                            },
                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            children: [
                              if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                                for(int i=0; i<popularCompList.length;i++)
                                  Stack(
                                    key: UniqueKey(),
                                    children: [
                                      ExpandItemWidget(

                                          compId: popularCompList[i]["compId"],

                                          champList: popularCompList[i]["champList"]),
                                      Padding(
                                        padding: EdgeInsets.only(top:30,right: width(context)<=600?width(context)*.12:width(context)*.12,),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: ReorderableDragStartListener(

                                              index: i,
                                              child: const Icon(Icons.drag_handle,color:Colors.white)),
                                        ),
                                      )
                                    ],
                                  )
                              ]
                              else...[
                                for(int i=0; i<popularCompList.length;i++)...[
                                  if(popularCompList[i]["champList"].any((element) =>

                                      Provider.of<BasicProvider>(context).foundData.any((foundElement){

                                        return element.champName==foundElement.champName;
                                      })))...[
                                    Stack(
                                      key: UniqueKey(),
                                      children: [
                                        ExpandItemWidget(

                                            compId: popularCompList[i]["compId"],

                                            champList: popularCompList[i]["champList"]),
                                        Padding(
                                          padding: EdgeInsets.only(top:30,right: width(context)<=600?width(context)*.12:width(context)*.12,),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: ReorderableDragStartListener(

                                                index: i,
                                                child: const Icon(Icons.drag_handle,color:Colors.white)),
                                          ),
                                        )
                                      ],
                                    )
                                  ]
                                ]
                              ]




                            ],
                            // children: [
                            //
                            //
                            //   ExpandItemW\idget(),
                            // ],
                          ),
                        ):dataFetched==true && popularCompList.isEmpty ?
                        const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                        const Center(child: CircularProgressIndicator(color: Colors.white,)),
                      ):
                      !isPopular && dataFetched?SizedBox(
                        child:  dataFetched==true && currentUserCompList.isNotEmpty ?
                        Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: const Color(0x00ffffff),
                            shadowColor: const Color(0x00ffffff),
                          ),
                          child: ReorderableListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),

                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            buildDefaultDragHandles: false,

                            onReorder: (int oldIndex, int newIndex) {

                              setState(() {
                                if (oldIndex < newIndex) {

                                  newIndex -= 1;
                                }

                                Map<String,dynamic> newComp=currentUserCompList.removeAt(oldIndex);
                                currentUserCompList.insert(newIndex, newComp);


                                // final String newDocId = docIds.removeAt(oldIndex);
                                // docIds.insert(newIndex, newDocId);
                              });
                            },
                            // itemCount: docIds.length,
                            // itemBuilder: (context,index){
                            //   return
                            children: [
                              if(Provider.of<BasicProvider>(context).isVisibleDataFromFirebase)...[
                                for(int i=0; i<currentUserCompList.length;i++)
                                  Stack(
                                    key: UniqueKey(),
                                    children: [
                                      ExpandItemWidget(

                                          compId: currentUserCompList[i][compId],
                                          champList: currentUserCompList[i][champList]),
                                      Padding(
                                        padding: EdgeInsets.only(top:30,right: width(context)<=600?width(context)*.12:width(context)*.12,),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: ReorderableDragStartListener(
                                              index: i,
                                              child: const Icon(Icons.drag_handle,color:Colors.white)),
                                        ),
                                      )
                                    ],
                                  )
                              ]
                              else...[
                                for(int i=0; i<currentUserCompList.length;i++)...[
                                  if(currentUserCompList[i]["champList"].any((element) =>

                                      Provider.of<BasicProvider>(context).foundData.any((foundElement){
                                        printLog("$popularCompList");

                                        return element.champName==foundElement.champName;
                                      })))...[
                                    Stack(
                                      key: UniqueKey(),
                                      children: [
                                        ExpandItemWidget(
                                          // champItems: popularCompList[i]["champList"],
                                            compId:currentUserCompList[i]["compId"],
                                            champList: currentUserCompList[i]["champList"]),
                                        Padding(
                                          padding: const EdgeInsets.only(top:40,right: 100),
                                          child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: ReorderableDragStartListener(
                                                key: UniqueKey(),index: i,
                                                child: const Icon(Icons.drag_handle,color:Colors.white)),
                                          ),
                                        )
                                      ],
                                    )
                                  ]


                                ]

                              ]

                            ],
                            // children: [
                            //
                            //
                            //   ExpandItemW\idget(),
                            // ],
                          ),
                        ):dataFetched==true && currentUserCompList.isEmpty ?
                        const Center(child: Text("No Data found",style: TextStyle(color: Colors.white),)):
                        const Center(child: CircularProgressIndicator(color: Colors.white,)),
                      ):
                      const Center(child: SizedBox(height:30,width:30,child: CircularProgressIndicator()))


                  ),
                  // SizedBox(
                  //     height: height(context)*.3,
                  //     width: width(context),
                  //     child: bannerAdView()),
                  const SizedBox(height: 40,)
                ],
              );
  }
}
