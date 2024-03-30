import 'dart:convert';

import 'package:app/Static/screen_utils.dart';
import 'package:app/consolePrintWithColor.dart';
import 'package:app/model/item_model.dart';
import 'package:app/services/Preferences%20%20Services/comp_preferences.dart';
import 'package:app/services/Preferences%20%20Services/preferences_keys.dart';
import 'package:app/services/Preferences%20%20Services/rememberMePreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/small_image_widget.dart';
import '/providers/basic_provider.dart';
import '/screens/components/search_bar.dart';
import '/widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/exports.dart';
import '../../providers/search_provider.dart';
import '../Admin/Model/api_data_model.dart';
import 'neon_tab_button.dart';

class LeftSideWidget extends StatefulWidget {
  const LeftSideWidget({Key? key}) : super(key: key);


  @override
  State<LeftSideWidget> createState() => _LeftSideWidgetState();
}

class _LeftSideWidgetState extends State<LeftSideWidget> {
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';

  List<ChampModel> champListFromFirebase =[];
  // List<String?> champNamesList = [];
  // List<String> docIds =[];

  /// Date 14-May-2023
  ///
  /// Requirement # 3
  /// Filter or Search champion in Main screen
  ///
  /// Search Functionality, Logic/Algorithm
  /// is written below
  ///
  TextEditingController searchController = TextEditingController();

  List<ChampModel> foundData=[];
  bool visibleSearchData = false;
  bool isVisibleDataFromFirebase=false;
  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      visibleSearchData=true;
      isVisibleDataFromFirebase=false;
    });
    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = champListFromFirebase;
      setState(() {
        isVisibleDataFromFirebase=true;
      });
    } else {
      isVisibleDataFromFirebase=false;
      // print(enteredKeyword);
      results = champListFromFirebase.where((user) =>
          user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      
      // print(results);
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      foundData = results;
    });
  }


  checkUpdate()async{

    var updateCheck=await FirebaseFirestore.instance.collection("dataUpdate").get();
    if(updateCheck.docs.isNotEmpty){
      var firebaseChampUpdateDate=DateTime.parse(updateCheck.docs.first["champsUpdate"]);
      var localChampUpdateDate= await AppPreferencesServices().getChampUpdateDatesPreferences();

      printLog("<<<<<<<<<<<<<<<<<<<Calling Update ${localChampUpdateDate}>>>>>>>>>>>>>>>>>>>");
      if(localChampUpdateDate!=null){
        if(DateTime.parse(localChampUpdateDate).day>=firebaseChampUpdateDate.day &&
            DateTime.parse(localChampUpdateDate).month>=firebaseChampUpdateDate.day
        ){
         await fetchLocalChampsData();
        }else{
          await fetchFirestoreData();
        }
      }


    }
    Map<String,dynamic> champData=await AppPreferencesServices().getChampsPreferences();
    if(champData[PreferencesKey.champs]!=null){

    }


  }

  // List<String> sortedChampList=[];
  fetchLocalChampsData()async{

    printLog("++++++++++++++++++++I am calling fetchLocalChamps");
    Map<String,dynamic> champCollectionFromLocal= await AppPreferencesServices().getChampsPreferences();


    // print(champCollectionFromLocal);
    print("I am fetch from firestore");
    if(
    champCollectionFromLocal[PreferencesKey.champs]!=null && champCollectionFromLocal[PreferencesKey.champs].isNotEmpty &&
        champCollectionFromLocal[PreferencesKey.items]!=null && champCollectionFromLocal[PreferencesKey.items].isNotEmpty
    ){

      var localChamps=jsonDecode(champCollectionFromLocal[PreferencesKey.champs]);
      champListFromFirebase.clear();
      // docIds.clear();

      // chosenTeam.clear();
      // chosenTeamIndexes.clear();

      for(int i=0;i<localChamps.length;i++){

        print("<><><>"+champCollectionFromLocal[PreferencesKey.champs][i]+"<><><>");
        ChampModel championFromLocal = ChampModel.fromJson(localChamps[i]);
        champListFromFirebase.add(championFromLocal);
      }

      champListFromFirebase.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      for(int i=0;i<champListFromFirebase.length;i++){
        print(champListFromFirebase[i].champCost);
      }

      // foundData = champListFromFirebase;
      Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);
      // Provider.of<SearchProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);

      // champListFromFirebase.sort((a,b)=>a.champCost!.compareTo(b.champCost!));
      isVisibleDataFromFirebase=true;
      setState((){});
    }

    setState(() {

    });
  }


  fetchFirestoreData()async{

    printLog("++++++++++++++++++++I am calling fetchFirebaseChamps");
    QuerySnapshot champCollectionFromFirestore = await FirebaseFirestore.instance.collection(champCollection).get();
    QuerySnapshot itemCollectionFromFirestore = await FirebaseFirestore.instance.collection(itemCollection).get();

    print("I am fetch from firestore");
    if(champCollectionFromFirestore.docs.isNotEmpty){
      print(champCollectionFromFirestore.size);
      champListFromFirebase.clear();
      // docIds.clear();

      // chosenTeam.clear();
      // chosenTeamIndexes.clear();
      List<ItemModel> items=[];
      for(int i=0;i<champCollectionFromFirestore.docs.first['champs'].length;i++){
        ChampModel championFromFirestore = ChampModel.fromJson(champCollectionFromFirestore.docs.first['champs'][i]);
        champListFromFirebase.add(championFromFirestore);
        // champNamesList.add(championFromFirestore.champName);
        // docIds.add(champCollectionFromFirestore.docs[i].id);
      }

      for(int i=0;i<itemCollectionFromFirestore.docs.first['items'].length;i++){
        ItemModel itemsFromFirestore =ItemModel.fromJson(itemCollectionFromFirestore.docs.first["items"][i]);
        items.add(itemsFromFirestore);
        // champNamesList.add(championFromFirestore.champName);
        // docIds.add(champCollectionFromFirestore.docs[i].id);
      }


      champListFromFirebase.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      for(int i=0;i<champListFromFirebase.length;i++){
        print(champListFromFirebase[i].champCost);
      }

      // foundData = champListFromFirebase;
      Provider.of<BasicProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);
      // Provider.of<SearchProvider>(context,listen: false).updateFirebaseDataFetchedLeftSideWidget(champListFromFirebase);

      Provider.of<BasicProvider>(context,listen: false).updateChampList(champListFromFirebase);

      Provider.of<BasicProvider>(context,listen: false).updateItemsList(items);


      await AppPreferencesServices().setChampsPreferences(jsonEncode(champCollectionFromFirestore.docs.first["champs"]));
      await AppPreferencesServices().setItemsPreferences(jsonEncode(itemCollectionFromFirestore.docs.first["items"]));


      // champListFromFirebase.sort((a,b)=>a.champCost!.compareTo(b.champCost!));
      isVisibleDataFromFirebase=true;
      setState((){});
    }

    setState(() {

    });

  }


  ScrollController _childScrollController=ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFirestoreData();
    // if(FirebaseAuth.instance.currentUser==null){
    //   fetchFirestoreData();
    // }else {
    //   checkUpdate();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        /// champoins and traits widget
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeonTabButtonWidget(
              onTap: null,
              gradient: const LinearGradient(
                colors: [
                  AppColors.pinkBorderColor,
                  AppColors.pinkBorderColor20,

                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              btnHeight: 55,
              btnWidth: ResponsiveWidget.isWebScreen(context)
                  ? width(context) * 0.15
                  : ResponsiveWidget.isTabletScreen(context)
                      ? width(context) * 0.2
                      : width(context) * 0.3,
              btnText: 'Champions',
            ),
          ],
        ),

        /// box
        Container(
          alignment: Alignment.topCenter,

          // height: ResponsiveWidget.isExtraWebScreen(context)?height(context)*.9:
          // ResponsiveWidget.isWebScreen(context)?height(context)*.9:height(context)*.6,
          height: height(context)>=1000?height(context)*.9:
          height(context)<1000&&ResponsiveWidget.isMobileScreen(context)?
          height(context)*.44:
          height(context)<1000 ?height(context)*.9:0,

          width: width(context),
          margin: const EdgeInsets.only(top: 36),

          padding: ResponsiveWidget.isWebScreen(context)
              ? const EdgeInsets.symmetric(horizontal: 3)
              :ResponsiveWidget.isTabletScreen(context)?
          const EdgeInsets.symmetric(horizontal: 2):
          const EdgeInsets.symmetric(horizontal: 3),
          decoration: leftSideBoxDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// search field and filter btn
              SizedBox(
                height: 70,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          // child: CustomSearchBar(champs: champListFromFirebase,),
                          child: TextFormField(
                            // onChanged: (value) => _runFilter(value),
                            // onChanged: (value) => Provider.of<BasicProvider>(context,listen: false).runFilter(value),
                            onChanged: (value) {
                              Provider.of<BasicProvider>(context,listen: false).runFilter(value,false,false);
                              setState(() {

                              });
                            } ,
                            controller: searchController,
                            keyboardType: TextInputType.text,
                            style: poppinsRegular.copyWith(
                              fontSize: 14,
                              color: AppColors.whiteColor,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Search',
                              hintStyle: poppinsRegular.copyWith(
                                fontSize: 14,
                                color: AppColors.whiteColor40,
                              ),
                              fillColor: AppColors.fieldColor40,
                              contentPadding: const EdgeInsets.only(top: 8.0),
                              prefixIcon: SvgPicture.asset(AppIcons.search, fit: BoxFit.scaleDown),
                              constraints: const BoxConstraints(
                                minHeight: 36,
                                maxHeight: 36,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.fieldColor40,
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.fieldColor40,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.fieldColor40,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: height(context) * 0.01),
                        Material(
                          color: Colors.transparent,
                          child: PopupMenuButton(
                            onSelected: (value){
                              if(value=="A-Z"){
                                print("Z-A");
                                Provider.of<BasicProvider>(context,listen: false).sortChampListZtoA(false);
                                // Provider.of<BasicProvider>(context,listen: false).sortCompChampListByAtoZ();
                                // sortByNameReversed();
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: "A-Z",
                                  child: Text("A-Z/Z-A"),

                                ),
                                // const PopupMenuItem(
                                //   value: "Z-A",
                                //   child: Text("Z-A"),
                                //
                                // ),
                                // const PopupMenuItem(
                                //   value:"By Traits",
                                //   child: Text("By Traits"),
                                //
                                // ),
                              ];
                            },
                            child: Center(
                              child: SvgPicture.asset(AppIcons.filter),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// images
              ///
              /// Date 14-May-2023
              ///
              /// Here We are showing two features
              /// 1) If search field is empty, than we are showing data
              ///    from firebase
              ///
              /// 2) If search field is active and is not empty we are
              ///    showing found data in the search
              ///


              Visibility(
                visible: Provider.of<BasicProvider>(context).isVisibleDataFromFirebase,
                child:

                Expanded(
                  child: GridView.builder(
                      controller: _childScrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: Provider.of<BasicProvider>(context).champListFromFirebase.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
                          mainAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
                          crossAxisCount:
                          ResponsiveWidget.isExtraWebScreen(context)?6:
                          ResponsiveWidget.isWebScreen(context)?5:6,
                          childAspectRatio: ResponsiveWidget.isMobileScreen(context)?0.75:
                          ResponsiveWidget.isWebScreen(context)?0.70:0.45
                      ),
                      itemBuilder: (context,i){
                        ChampModel champ=Provider.of<BasicProvider>(context).champListFromFirebase[i];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SmallImageWidget(
                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                              ///
                              ///  16-May-2023
                              /// Fetching new image path
                              ///
                              ///
                              boxHeight: 40,//height(context) * 0.05,
                              boxWidth: 40,//height(context) * 0.05,
                              imageHeight: 40,// height(context) * 0.05,
                              imageWidth: 40,//height(context) * 0.05,
                              imageUrl: Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath,
                              // isBorder: i == 0 || i == 2 ? true : false,
                              // isShadow: i == 0 || i == 2 ? true : false,
                              // isStar: i == 2 || i == 3 ? true : false,
                              ///
                              /// Date : 14-May-2023
                              ///
                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                              ///
                              /// Different border colors of images
                              /// according to the cost of the champion
                              ///
                              /// This color representation is for popular
                              /// category on main screen
                              ///
                              borderColor: champ.champCost=='1'?
                              Colors.grey:champ.champCost=='2'?
                              Colors.green:champ.champCost=='3'?
                              Colors.blue:champ.champCost=='4'?
                              Colors.purple:champ.champCost=='5'?
                              Colors.yellow:Colors.red
                              ,
                              shadowColor: champ.champCost=='1'?
                              const Color(0x609E9E9E):champ.champCost=='2'?
                              const Color(0x604CAF50):champ.champCost=='3'?
                              const Color(0x602196F3):champ.champCost=='4'?
                              const Color(0x609C27B0):champ.champCost=='5'?
                              const Color(0x60FFEB3B):const Color(0x60F44336),
                              isBorder: true ,
                              isShadow:  true ,
                              // isStar: i == 2 || i == 3 ? true : false,
                            ),
                            Text(
                              champ.champName
                                  .length >
                                  5
                                  ? champ.champName
                                  .substring(
                                  0,
                                  5)
                                  : champ.champName,
                              style: TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 9),
                            )
                          ],
                        );
                      }),
                ),
              ),
              // child: Provider.of<SearchProvider>(context).isVisibleDataFromFirebase?
//               Visibility(
//                 visible: Provider.of<BasicProvider>(context).isVisibleDataFromFirebase,
//                 child:
//                 ListView(
//                   shrinkWrap: true,
//                   physics:
//                   NeverScrollableScrollPhysics(),
//                   children: [
//                     // const SizedBox(height: 30),
//                     Wrap(
//                       alignment: WrapAlignment.start,
//                       runAlignment:
//                       WrapAlignment.start,
//                       spacing: 5,
//                       runSpacing: 5,
//                       children: [
//                         // for (int i = 0; i < champListFromFirebase.length; i++)
//                         for (int i = 0;
//                         i <
//                             Provider.of<SearchProvider>(context).champListFromFirebase.length;
//                         i++)
//                         // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
//                         ///
//                           Provider.of<SearchProvider>(context).champListFromFirebase[i]
//                               .champItems
//                               .isNotEmpty
//                               ? Column(
//                             mainAxisSize:
//                             MainAxisSize
//                                 .min,
//                             children: [
//                               Stack(
//                                 alignment: Alignment
//                                     .bottomCenter,
//                                 children: [
//                                   SmallImageWidget(
//                                     // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
//                                     ///
//                                     ///  16-May-2023
//                                     /// Fetching new image path
//                                     ///
//                                     ///
//                                     imageWidth:
//                                     40,
//                                     imageHeight:
//                                     40,
//                                     boxWidth:
//                                     40,
//                                     boxHeight:
//                                     40,
//                                     imageUrl: Provider.of<SearchProvider>(context).champListFromFirebase[
//                                     i]
//                                         .imagePath,
//                                     // isBorder: i == 0 || i == 2 ? true : false,
//                                     // isShadow: i == 0 || i == 2 ? true : false,
//                                     // isStar: i == 2 || i == 3 ? true : false,
//                                     ///
//                                     /// Date : 14-May-2023
//                                     ///
//                                     /// Requirement # 2a, 2b, 2c, 2d, 2e
//                                     ///
//                                     /// Different border colors of images
//                                     /// according to the cost of the champion
//                                     ///
//                                     /// This color representation is for popular
//                                     /// category on main screen
//                                     ///
//                                     borderColor: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost ==
//                                         '1'
//                                         ? Colors
//                                         .grey
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost ==
//                                         '2'
//                                         ? Colors.green
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '3'
//                                         ? Colors.blue
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '4'
//                                         ? Colors.purple
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '5'
//                                         ? Colors.yellow
//                                         : Colors.red,
//                                     shadowColor: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost ==
//                                         '1'
//                                         ? const Color(
//                                         0x609E9E9E)
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost ==
//                                         '2'
//                                         ? const Color(0x604CAF50)
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '3'
//                                         ? const Color(0x602196F3)
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '4'
//                                         ? const Color(0x609C27B0)
//                                         : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost == '5'
//                                         ? const Color(0x60FFEB3B)
//                                         : const Color(0x60F44336),
//                                     isBorder:
//                                     true,
//                                     isShadow:
//                                     true,
//                                     isStar: i ==
//                                         2 ||
//                                         i ==
//                                             3
//                                         ? true
//                                         : false,
//                                   ),
//                                   Row(
//                                     mainAxisSize:
//                                     MainAxisSize
//                                         .min,
//                                     children: List.generate(
//
// Provider.of<BasicProvider>(context).champListFromFirebase[
//                                         i]
//                                             .champItems
//                                             .length,
//                                             (index) {
//                                           printLog(
//                                               "+++++*********=============== Items ");
//                                           // return Image.network(widget.champItems![widget.champList[i].champPositionIndex]![index].itemImageUrl,height: 15,width: 15,);
//
//                                           return Container(
//                                               height:
//                                               15,
//                                               width:
//                                               15,
//                                               decoration:
//                                               BoxDecoration(),
//                                               child:
//                                               Image(image: NetworkImage(Provider.of<BasicProvider>(context).champListFromFirebase[i].champItems[index]["itemImageUrl"])));
//                                           //   SmallImageWidget(
//                                           //     imageHeight: 10,
//                                           //     imageWidth: 10,
//                                           //     boxWidth: 10,
//                                           //     boxHeight: 10,
//                                           //     isBorder: false,
//                                           //     imageUrl: widget.champList[i].champItems[index].itemImageUrl
//                                           //
//                                           // );
//                                         }),
//                                   ),
//                                 ],
//                               ),
//
//
//                               Text(
//
// Provider.of<BasicProvider>(context).champListFromFirebase[
//                                 i]
//                                     .champName
//                                     .length >
//                                     5
//                                     ?
// Provider.of<BasicProvider>(context).champListFromFirebase[
//                                 i]
//                                     .champName
//                                     .substring(
//                                     0,
//                                     5)
//                                     :
// Provider.of<BasicProvider>(context).champListFromFirebase[
//                                 i]
//                                     .champName,
//                                 style: TextStyle(
//                                     color: Colors
//                                         .white),
//                               )
//                             ],
//                           )
//                               : Column(
//                             mainAxisSize:
//                             MainAxisSize
//                                 .min,
//                             children: [
//                               SmallImageWidget(
//                                 // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
//                                 ///
//                                 ///  16-May-2023
//                                 /// Fetching new image path
//                                 ///
//                                 imageHeight: 40,
//                                 imageWidth: 40,
//                                 boxHeight: 40,
//                                 boxWidth: 40,
//                                 imageUrl:
//                                 Provider.of<BasicProvider>(context).champListFromFirebase[
//                                 i]
//                                     .imagePath,
//                                 // isBorder: i == 0 || i == 2 ? true : false,
//                                 // isShadow: i == 0 || i == 2 ? true : false,
//                                 // isStar: i == 2 || i == 3 ? true : false,
//                                 ///
//                                 /// Date : 14-May-2023
//                                 ///
//                                 /// Requirement # 2a, 2b, 2c, 2d, 2e
//                                 ///
//                                 /// Different border colors of images
//                                 /// according to the cost of the champion
//                                 ///
//                                 /// This color representation is for popular
//                                 /// category on main screen
//                                 ///
//                                 borderColor:
//                                 Provider.of<BasicProvider>(context).champListFromFirebase[
//                                 i]
//                                     .champCost ==
//                                     '1'
//                                     ? Colors
//                                     .grey
//                                     : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost ==
//                                     '2'
//                                     ? Colors
//                                     .green
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost ==
//                                     '3'
//                                     ? Colors.blue
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost == '4'
//                                     ? Colors.purple
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost == '5'
//                                     ? Colors.yellow
//                                     : Colors.red,
//                                 shadowColor:
//                                 Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost ==
//                                     '1'
//                                     ? const Color(
//                                     0x609E9E9E)
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost ==
//                                     '2'
//                                     ? const Color(
//                                     0x604CAF50)
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost ==
//                                     '3'
//                                     ? const Color(0x602196F3)
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost == '4'
//                                     ? const Color(0x609C27B0)
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost == '5'
//                                     ? const Color(0x60FFEB3B)
//                                     : const Color(0x60F44336),
//                                 isBorder: true,
//                                 isShadow: true,
//                                 isStar: i ==
//                                     2 ||
//                                     i == 3
//                                     ? true
//                                     : false,
//                               ),
//                               Text(
//                                 Provider.of<BasicProvider>(context).champListFromFirebase[i]
//                                     .champName
//                                     .length >
//                                     5
//                                     ?Provider.of<BasicProvider>(context).champListFromFirebase[i]
//                                     .champName
//                                     .substring(
//                                     0,
//                                     5)
//                                     : Provider.of<BasicProvider>(context).champListFromFirebase[i]
//                                     .champName,
//                                 style: TextStyle(
//                                     color: Colors
//                                         .white),
//                               )
//                             ],
//                           )
//                         //  SmallImageWidget(
//                         //    // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
//                         //    ///
//                         //    ///  16-May-2023
//                         //    /// Fetching new image path
//                         //    ///
//                         //    ///
//                         //    boxHeight: height(context) * 0.06,
//                         //    boxWidth: height(context) * 0.06,
//                         //    imageHeight: height(context) * 0.05,
//                         //    imageWidth: height(context) * 0.05,
//                         //    imageUrl: widget.champList[i].imagePath,
//                         //    // isBorder: i == 0 || i == 2 ? true : false,
//                         //    // isShadow: i == 0 || i == 2 ? true : false,
//                         //    // isStar: i == 2 || i == 3 ? true : false,
//                         //    ///
//                         //    /// Date : 14-May-2023
//                         //    ///
//                         //    /// Requirement # 2a, 2b, 2c, 2d, 2e
//                         //    ///
//                         //    /// Different border colors of images
//                         //    /// according to the cost of the champion
//                         //    ///
//                         //    /// This color representation is for popular
//                         //    /// category on main screen
//                         //    ///
//                         //    borderColor: widget.champList[i].champCost=='1'?
//                         //    Colors.grey:widget.champList[i].champCost=='2'?
//                         //    Colors.green:widget.champList[i].champCost=='3'?
//                         //    Colors.blue:widget.champList[i].champCost=='4'?
//                         //    Colors.purple:widget.champList[i].champCost=='5'?
//                         //    Colors.yellow:Colors.red
//                         //    ,
//                         //    shadowColor: widget.champList[i].champCost=='1'?
//                         //    const Color(0x609E9E9E):widget.champList[i].champCost=='2'?
//                         //    const Color(0x604CAF50):widget.champList[i].champCost=='3'?
//                         //    const Color(0x602196F3):widget.champList[i].champCost=='4'?
//                         //    const Color(0x609C27B0):widget.champList[i].champCost=='5'?
//                         //    const Color(0x60FFEB3B):const Color(0x60F44336),
//                         //    isBorder: true ,
//                         //    isShadow:  true ,
//                         //    // isStar: i == 2 || i == 3 ? true : false,
//                         //  )
//                         ///
//                         //                       Container(
//                         //                         height: height(context) * 0.07,
//                         //                         width: height(context) * 0.07,
//                         //                         decoration: BoxDecoration(
//                         //                           borderRadius: BorderRadius.circular(17),
//                         //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
//                         //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
//                         //                               ? Border.all(
//                         //                                   // color: AppColors.skyBorderColor,
//                         //                             color: Colors.grey,
//                         //                                   width: 2.27,
//                         //                                 )
//                         //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
//                         //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
//                         //                           Border.all(
//                         //                             // color: AppColors.skyBorderColor,
//                         //                             color: Colors.green,
//                         //                             width: 2.27,
//                         //                           )
//                         //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
//                         //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
//                         //                           Border.all(
//                         //                             // color: AppColors.skyBorderColor,
//                         //                             color: Colors.blue,
//                         //                             width: 2.27,
//                         //
//                         //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
//                         //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
//                         //                           Border.all(
//                         //                             // color: AppColors.skyBorderColor,
//                         //                             color: Colors.purple,
//                         //                             width: 2.27,
//                         //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
//                         //                           Border.all(
//                         //                             // color: AppColors.skyBorderColor,
//                         //                             color: Colors.yellow,
//                         //                             width: 2.27,
//                         //                           ):
//                         //                           Border.all(
//                         //                             // color: AppColors.skyBorderColor,
//                         //                             color: Colors.red,
//                         //                             width: 2.27,
//                         //                           ),
//                         //                           boxShadow: [
//                         //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
//                         //                                 ? BoxShadow(
//                         //                                     color: Colors.grey
//                         //                                         .withOpacity(0.6),
//                         //                                     blurRadius: 10,
//                         //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
//                         //                                 ? BoxShadow(
//                         //                               color: Colors.green
//                         //                                   .withOpacity(0.6),
//                         //                               blurRadius: 10,
//                         //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
//                         //                                 ? BoxShadow(
//                         //                               color: Colors.blue
//                         //                                   .withOpacity(0.6),
//                         //                               blurRadius: 10,
//                         //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
//                         //                                 ? BoxShadow(
//                         //                               color: Colors.purple
//                         //                                   .withOpacity(0.6),
//                         //                               blurRadius: 10,
//                         //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
//                         //                                 ? BoxShadow(
//                         //                               color: Colors.yellow
//                         //                                   .withOpacity(0.6),
//                         //                               blurRadius: 10,
//                         //                             ):BoxShadow(
//                         //                               color: Colors.red
//                         //                                   .withOpacity(0.6),
//                         //                               blurRadius: 10,
//                         //                             )
//                         //
//                         //                           ]
//                         // ,
//                         //                           image: DecorationImage(
//                         //                             fit: BoxFit.fill,
//                         //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
//                         //                               ///
//                         //                               ///  16-May-2023
//                         //                               ///  New Image path fetched from firebase
//                         //                               ///  and shown
//                         //                               ///
//                         //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
//                         //
//                         //
//                         //                         ),
//                         //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
//                         //                         // child: Image.network(
//                         //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
//                         //                         //     height: 60,
//                         //                         //     width: 60,
//                         //                         //
//                         //                         //     fit: BoxFit
//                         //                         //         .fill),
//                         //                       )
//                       ],
//                     ),
//                   ],
//                 )
//
//                 // Expanded(
//                 //   child: GridView.builder(
//                 //     shrinkWrap: true,
//                 //     physics: const AlwaysScrollableScrollPhysics(),
//                 //     controller: _childScrollController,
//                 //     padding: const EdgeInsets.all(10),
//                 //     itemCount: champListFromFirebase.length,
//                 //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 //         crossAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
//                 //           mainAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
//                 //           crossAxisCount:
//                 //           ResponsiveWidget.isExtraWebScreen(context)?6:
//                 //               ResponsiveWidget.isWebScreen(context)?5:6,
//                 //         childAspectRatio: ResponsiveWidget.isExtraWebScreen(context)?0.6:65
//                 //           // ResponsiveWidget.isMobileScreen(context)?0.65:0.45
//                 //       ),
//                 //       itemBuilder: (context,i){
//                 //         ChampModel champ=Provider.of<BasicProvider>(context).champListFromFirebase[i];
//                 //         return Column(
//                 //           mainAxisSize: MainAxisSize.min,
//                 //           children: [
//                 //             SmallImageWidget(
//                 //               // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
//                 //               ///
//                 //               ///  16-May-2023
//                 //               /// Fetching new image path
//                 //               ///
//                 //               ///
//                 //               boxHeight: height(context) * 0.05,
//                 //               boxWidth: height(context) * 0.05,
//                 //               imageHeight: height(context) * 0.05,
//                 //               imageWidth: height(context) * 0.05,
//                 //               imageUrl: champ.imagePath,
//                 //               // isBorder: i == 0 || i == 2 ? true : false,
//                 //               // isShadow: i == 0 || i == 2 ? true : false,
//                 //               // isStar: i == 2 || i == 3 ? true : false,
//                 //               ///
//                 //               /// Date : 14-May-2023
//                 //               ///
//                 //               /// Requirement # 2a, 2b, 2c, 2d, 2e
//                 //               ///
//                 //               /// Different border colors of images
//                 //               /// according to the cost of the champion
//                 //               ///
//                 //               /// This color representation is for popular
//                 //               /// category on main screen
//                 //               ///
//                 //               borderColor: champ.champCost=='1'?
//                 //               Colors.grey:champ.champCost=='2'?
//                 //               Colors.green:champ.champCost=='3'?
//                 //               Colors.blue:champ.champCost=='4'?
//                 //               Colors.purple:champ.champCost=='5'?
//                 //               Colors.yellow:Colors.red
//                 //               ,
//                 //               shadowColor: champ.champCost=='1'?
//                 //               const Color(0x609E9E9E):champ.champCost=='2'?
//                 //               const Color(0x604CAF50):champ.champCost=='3'?
//                 //               const Color(0x602196F3):champ.champCost=='4'?
//                 //               const Color(0x609C27B0):champ.champCost=='5'?
//                 //               const Color(0x60FFEB3B):const Color(0x60F44336),
//                 //               isBorder: true ,
//                 //               isShadow:  true ,
//                 //               // isStar: i == 2 || i == 3 ? true : false,
//                 //             ),
//                 //             Text(
//                 //               champ.champName
//                 //                   .length >
//                 //                   5
//                 //                   ?champ.champName
//                 //                   .substring(
//                 //                   0,
//                 //                   5)
//                 //                   : champ.champName,
//                 //               style: TextStyle(
//                 //                   color: Colors
//                 //                       .white,
//                 //                 fontSize: 9
//                 //               ),
//                 //             )
//                 //           ],
//                 //         );
//                 //       }),
//                 // ),
//               ),
              Visibility(
                visible: !Provider.of<BasicProvider>(context).isVisibleDataFromFirebase,
                child:

                Expanded(
                  child: GridView.builder(
                    controller: _childScrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: Provider.of<BasicProvider>(context).foundData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
                          mainAxisSpacing: ResponsiveWidget.isMobileScreen(context)?10:5,
                          crossAxisCount:
                          ResponsiveWidget.isExtraWebScreen(context)?6:
                          ResponsiveWidget.isWebScreen(context)?5:6,
                          childAspectRatio: ResponsiveWidget.isMobileScreen(context)?0.65:0.45
                      ),
                      itemBuilder: (context,i){
                      ChampModel champ=Provider.of<BasicProvider>(context).foundData[i];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SmallImageWidget(
                              // imageUrl: '${baseUrl + champList[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                              ///
                              ///  16-May-2023
                              /// Fetching new image path
                              ///
                              ///
                              // boxHeight: height(context) * 0.05,
                              // boxWidth: height(context) * 0.05,
                              // imageHeight: height(context) * 0.05,
                              // imageWidth: height(context) * 0.05,
                              imageUrl: Provider.of<BasicProvider>(context).foundData[i].imagePath,
                              // isBorder: i == 0 || i == 2 ? true : false,
                              // isShadow: i == 0 || i == 2 ? true : false,
                              // isStar: i == 2 || i == 3 ? true : false,
                              ///
                              /// Date : 14-May-2023
                              ///
                              /// Requirement # 2a, 2b, 2c, 2d, 2e
                              ///
                              /// Different border colors of images
                              /// according to the cost of the champion
                              ///
                              /// This color representation is for popular
                              /// category on main screen
                              ///
                              borderColor: champ.champCost=='1'?
                              Colors.grey:champ.champCost=='2'?
                              Colors.green:champ.champCost=='3'?
                              Colors.blue:champ.champCost=='4'?
                              Colors.purple:champ.champCost=='5'?
                              Colors.yellow:Colors.red
                              ,
                              shadowColor: champ.champCost=='1'?
                              const Color(0x609E9E9E):champ.champCost=='2'?
                              const Color(0x604CAF50):champ.champCost=='3'?
                              const Color(0x602196F3):champ.champCost=='4'?
                              const Color(0x609C27B0):champ.champCost=='5'?
                              const Color(0x60FFEB3B):const Color(0x60F44336),
                              isBorder: true ,
                              isShadow:  true ,
                              // isStar: i == 2 || i == 3 ? true : false,
                            ),
                            Text(
                              champ.champName
                                  .length >
                                  5
                                  ? champ.champName
                                  .substring(
                                  0,
                                  5)
                                  : champ.champName,
                              style: TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize: 9),
                            )
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
