import 'dart:convert';
import 'dart:math';
import 'package:app/consolePrintWithColor.dart';
import 'package:app/screens/main_screen.dart';
import 'package:app/services/Preferences%20%20Services/comp_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/item_model.dart';
import '../../../providers/user_provider.dart';
import '/constants/exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/providers/basic_provider.dart';
import '/services/firestore%20services/firestore_comp_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as https;
import '../../../widgets/buttons/action_button_widget.dart';
import '../../../widgets/responsive_widget.dart';
import '../../../widgets/small_image_widget.dart';
import '../../Admin/Model/api_data_model.dart';
import '../../Admin/admin_homescreen.dart';
import '../app_bar_widget.dart';
import '../neon_tab_button.dart';
import '/screens/Api/custom_widget_for_combview.dart';

class TeamBuilderScreen extends StatefulWidget {

  const TeamBuilderScreen({super.key});
  @override
  State<TeamBuilderScreen> createState() => _TeamBuilderScreenState();
}

class _TeamBuilderScreenState extends State<TeamBuilderScreen> {



  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  ///
  ///         16-May-2023
  /// Image path changed
  ///
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';


  Color caughtColor = Colors.red;

  bool dataFetched=false;

  ///  This work is done by Salih Hayat
  ///
  ///
  /// Following are the variables which I defined for draggable
  ///
  List<ChampModel> chosenTeam= [];  /// Chosen team list is the list of player which were chosen
  List<String> chosenTeamIndexes=[];  /// Here we can store indexes of each player in
  Map<String,List<ItemModel>> champItemsList={};
  /// order to drag player at any index on the target drag
  ///
  // bool dataFetched = false;
  bool isLoading= true;

  void fetchLocalData()async{
    await userProvider!.getUser();
    var champData= await AppPreferencesServices().getChampsPreferences();
    if(champData!=null && champData["champs"]!=null ){
      var champions=await jsonDecode(champData["champs"]);
      for(int i=0;i<champions.length;i++){
        champ.add(ChampModel.fromJson(champions[i]));
      }

      var champItems=await jsonDecode(champData["items"]);
      for(int i=0;i<champItems.length;i++){
        items.add(ItemModel.fromJson(champItems[i]));
        printLog("${items[i].itemImageUrl}");
      }
      // champ=;
      printLog("champs: ${champ.length}");

      printLog("Items: ${items.length}");
      items.sort((a,b)=>a.itemName.compareTo(b.itemName));
      champ.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      Provider.of<BasicProvider>(context,listen: false).updateTeamBuilderChamps(champ);
      Provider.of<BasicProvider>(context,listen: false).updateTeamBuilderItems(items);
      Provider.of<BasicProvider>(context,listen: false).updataDataFetched();
    }
    // else{
    //   Navigator.pushReplacementNamed(context, "/");
    // }
    //


  }


  bool showItems=false;



  List<ChampModel> champ = [];
  List<ItemModel> items=[];

  var setData = [];


  Map<String, dynamic>? limit;
  UserProvider? userProvider;
  void initState() {
    super.initState();
    userProvider=Provider.of<UserProvider>(context,listen:false);

    Future.delayed(const Duration(seconds: 1),(){
      fetchLocalData();
    });

    // setState(() {
    //
    // });
    // getNameData();
  }

  double heightConstraint=900;
  double heightConstraint1100=1100;


  bool reverseSorted=false;

  bool autoGenerateLoader=false;
  autoCompGeneration()async{
    setState(() {
      autoGenerateLoader=true;
    });
    String docId = DateTime.now().microsecondsSinceEpoch.toString();
    String userId=FirebaseAuth.instance.currentUser!.uid;
    List<ChampModel> championsList=Provider.of<BasicProvider>(context,listen:false).teamBuilderChamps;
    List<ItemModel> autoItemsList=Provider.of<BasicProvider>(context,listen:false).teamBuilderItems;
    List<ChampModel> autoChosenTeam=[];
    Map<String,List<ItemModel>> autoChampItemsList={};
    List<String> autoChosenTeamIndexes=[];


    Map<String,List<ItemModel>> champItemsList={};
    for(int i=0;i<9;i++){
      Random random = Random();

      int firstRandom = random.nextInt(4) + 1;
      int secondRandom = random.nextInt(6) + 1;

      String index = '$firstRandom$secondRandom';

      ChampModel randChamp=championsList.elementAt(Random.secure().nextInt(championsList.length-1));
      autoChosenTeamIndexes.add(index);
      List<ItemModel> itemDataList=[];
      randChamp.champPositionIndex=index;
      autoChosenTeam.add(randChamp);
      for(int i=0;i<3;i++){

          printLog("${autoItemsList.length}");

          ItemModel autoItem=autoItemsList.elementAt(Random.secure().nextInt(autoItemsList.length-1));
          printLog("${autoItem.toMap()}");
          itemDataList.add(autoItem);
          autoChosenTeam[autoChosenTeamIndexes.indexOf(index)].champItems.add(autoItem.toMap());
          Map<String,List<ItemModel>> newItem={
            index: List.from(itemDataList)
          };
          autoChampItemsList.addEntries(
              newItem.entries
          );


      }


    }
    print(userId);
    printLog("==========>Champ items list length: ${champItemsList.length}");
    await FirestoreCompServices().addCompToPopularAdmin(userId,docId, autoChosenTeam,autoChampItemsList,autoChosenTeam.length.toString(),context);
    setState(() {
      autoGenerateLoader=true;

    });

  }

  @override
  Widget build(BuildContext context) {
    var provider=Provider.of<BasicProvider>(context);
    var updateProvider=Provider.of<BasicProvider>(context,listen: false);
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/backImage.png',
                ),
                fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ResponsiveWidget.isExtraWebScreen(context)?
              Column(

                mainAxisSize:MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// menu icon
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/");
                            },
                            icon: const MenuIcon(),
                          ),
                          const SizedBox(width: 12.0),

                          /// premium button
                          // PremiumButton(onTap: () {}),
                          // const Spacer(),
                          SizedBox(width: MediaQuery.of(context).size.width*.405),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffFF2D2D),
                            onPressed: () {
                              Navigator.pushNamed(context, "/");
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),

                          /// Save Button
                          /// By Pressing save button data is saved to firestore
                          /// Comp Collection
                          ///
                          Provider.of<BasicProvider>(context).isLoading?const CircularProgressIndicator():MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffF48B19),
                            onPressed: () async{


                              /// Setup for local db
                              if(userProvider!.user!.userName=="Admin"){
                                if(chosenTeam.isNotEmpty){
                                  Provider.of<BasicProvider>(context,listen: false).startLoading();
                                  String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                  await FirestoreCompServices().addCompToPopularAdmin(docId, docId,chosenTeam,champItemsList,champ.length.toString(),context);

                                  DateTime date=DateTime.now();
                                  await FirebaseFirestore.instance.collection("dataUpdate").doc("A7PYFjiHuEqT2jKMivKP").update(

                                      {
                                      "compsUpdate": date.toString()
                                    }
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                  chosenTeam.clear();
                                  chosenTeamIndexes.clear();
                                  Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                  Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                  Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                }
                              }else{
                                if(chosenTeam.isNotEmpty){
                                  Provider.of<BasicProvider>(context,listen: false).startLoading();
                                  setState(() {

                                  });
                                  String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                  String userId=FirebaseAuth.instance.currentUser!.uid;
                                  print(userId);
                                  printLog("==========>Champ items list length: ${champItemsList.length}");
                                  await FirestoreCompServices().addCompToMyTeams(userId,docId, chosenTeam,champItemsList,champ.length.toString(),context);


                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                  chosenTeam.clear();
                                  chosenTeamIndexes.clear();
                                  Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                  Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  setState(() {

                                  });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                  Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                }
                              }



                            },

                            child: Provider.of<BasicProvider>(context).isLoading?
                            const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width:20),
                          userProvider!.user!.userName!="Admin"?SizedBox.shrink():MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xffF48B19),
                            onPressed: ()async{
                              await autoCompGeneration();
                            },

                            child: autoGenerateLoader?
                            const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):const Text(
                              'Auto',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // Spacer(),
                          // MaterialButton(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12)),
                          //   color: Color(0xff00ABDE),
                          //   onPressed: () {
                          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHomeScreen()));
                          //
                          //   },
                          //   child: Text(
                          //     'Create Guide',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 12,
                          // ),
                          // MaterialButton(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12)),
                          //   color: Color(0xffF48B19),
                          //   onPressed: () {},
                          //   child: Text(
                          //     'Share',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 12,
                          // ),
                          // MaterialButton(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(12)),
                          //   color: const Color(0xffFF2D2D),
                          //   onPressed: () {},
                          //   child: const Text(
                          //     'Delete',
                          //     style: TextStyle(color: Colors.white),
                          //   ),
                          // ),
                          // const Spacer(),

                          /// actions icons
                          // ActionButtonWidget(
                          //     onTap: () {}, iconPath: AppIcons.chat),
                          // const SizedBox(width: 8),
                          // ActionButtonWidget(
                          //     onTap: () {}, iconPath: AppIcons.setting),
                          // const SizedBox(width: 8),
                          // ActionButtonWidget(
                          //   onTap: () {},
                          //   iconPath: AppIcons.bell,
                          //   isNotify: true,
                          // ),
                          // const SizedBox(width: 8),
                          //
                          // /// user name and image
                          // // Text('Madeline Goldner',
                          // //   style: poppinsRegular.copyWith(
                          // //     fontSize: 16,
                          // //     color: AppColors.whiteColor,
                          // //   ),
                          // // ),
                          // const CircleAvatar(
                          //   radius: 22,
                          //   backgroundImage:
                          //   AssetImage(AppImages.userImage),
                          // ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: SvgPicture.asset(AppIcons.dotVert),
                          // ),
                        ],
                      ),
                      const Text(
                        'Team Builder',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40),
                      ),
                      const Text(
                        'Drag & Drop players to build your best team,',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 21),
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffF48B19),
                                    const Color(0xffF48B19).withOpacity(0.2),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: height*.04,
                                btnWidth:
                                ResponsiveWidget.isWebScreen(context)
                                    ? width * 0.11
                                    : ResponsiveWidget.isTabletScreen(
                                    context)
                                    ? width * 0.2
                                    : width * 0.5,
                                btnText: 'Synergy',
                              ),
                              Container(
                                width: width*.15,
                                height: height*.4,
                                alignment: Alignment.center,
                                // margin: const EdgeInsets.only(0),
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 10)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const[
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      'Start building your camp',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'to see the synergies.',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Column(
                            children: [
                              SizedBox(
                                height: height*.05,),
                              SizedBox(
                                height: height*.4,
                                // width: 420,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                        children: List.generate(7, (index1) =>
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: SizedBox(
                                                height: height*.1,
                                                width: height*.1,
                                                child: GestureDetector(
                                                  onTap: (){
                                                    printLog("===========>Pressed");
                                                    if(chosenTeamIndexes.contains("1$index1")){

                                                      showDialog(context: context,
                                                          builder: (context){
                                                            return AlertDialog(
                                                              content: const Text("Actions"),
                                                              actions: [
                                                                TextButton(onPressed: (){
                                                                  printLog("===========>Exist");
                                                                  if(champItemsList.containsKey("1$index1")){
                                                                    printLog("=======>Champ items exist");
                                                                    champItemsList.remove("1$index1");
                                                                  }
                                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("1$index1"));
                                                                  chosenTeamIndexes.remove("1$index1");
                                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("1$index1");
                                                                  Navigator.pop(context);
                                                                  setState(() {

                                                                  });
                                                                }, child: Text("Remove")),
                                                                TextButton(onPressed: (){
                                                                  Navigator.pop(context);
                                                                }, child: Text("Cancel"))
                                                              ],
                                                            );
                                                          });

                                                    }else{
                                                      printLog("===========>Not Exist");
                                                    }

                                                  },
                                                  child: DragTarget(
                                                    ///Todo: Extra web screen index 1 team builder
                                                      onAccept: (champ) {
                                                        String index="1$index1";
                                                        ChampModel data;
                                                        ItemModel itemData;
                                                        print(champ);
                                                        // if(champ.isOfExactGenericType(ChampModel)){


                                                        if(champ.runtimeType ==ChampModel){
                                                          data=champ as ChampModel;
                                                          data.champPositionIndex=index;
                                                          print("==================+Champ model+==============");

                                                          /// This work is done by Salih Hayat
                                                          ///
                                                          /// I have created another list for team to be choosed
                                                          /// Also  I created another list of integer in which I store indexes of the players
                                                          /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                          /// already in the team therefore such a player cannot be added again
                                                          if(
                                                          Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                          }else{

                                                            /// If player is not present in team here we can add
                                                            // data.champPositionIndex=index.toString();
                                                            chosenTeam.add(data);
                                                            Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                            chosenTeamIndexes.add(index);

                                                            // setState(() {
                                                            //
                                                            // });
                                                          }
                                                        }
                                                        else if(champ.runtimeType==ItemModel){



                                                          itemData =champ as ItemModel;
                                                          // itemData.itemIndex=index;
                                                          if(
                                                          Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                              !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                          }else{

                                                            if(champItemsList.containsKey(index)){
                                                              List<ItemModel>? itemsData=champItemsList[index];
                                                              if(itemsData!.length>2){
                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                              }else{
                                                                chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                itemsData.add(itemData);
                                                                champItemsList[index]=itemsData;
                                                                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                              }
                                                            }else{
                                                              List<ItemModel> itemDataList=[];
                                                              itemDataList.add(itemData);
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              Map<String,List<ItemModel>> newItem={
                                                                index:itemDataList
                                                              };
                                                              champItemsList.addEntries(
                                                                  newItem.entries
                                                              );
                                                            }
                                                          }


                                                          /// This work is done by Salih Hayat
                                                          ///
                                                          /// I have created another list for team to be choosed
                                                          /// Also  I created another list of integer in which I store indexes of the players
                                                          /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                          /// already in the team therefore such a player cannot be added again

                                                          // setState(() {
                                                          //
                                                          // });

                                                        }


                                                      },
                                                      builder: (
                                                          BuildContext context,
                                                          List<dynamic> accepted,
                                                          List<dynamic> rejected,
                                                          ) {
                                                        // print(text);
                                                        String index="1$index1";
                                                        return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                            ?Stack(
                                                          alignment: Alignment.bottomCenter,
                                                          children: [
                                                            SmallImageWidget(
                                                              isPolygon:true,
                                                              imageHeight: height*.1,
                                                              imageWidth: height*.1,
                                                              boxWidth: height*.1,
                                                              boxHeight: height*.1,
                                                              isBorder: true,
                                                              imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                              borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                              Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                              Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                              Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                              Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                              Colors.yellow:Colors.red
                                                              ,

                                                            ),
                                                            champItemsList.containsKey("1$index1")?
                                                            Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: List.generate(champItemsList["1$index1"]!.length, (index) {

                                                                  return SmallImageWidget(
                                                                    isPolygon: true,
                                                                    imageHeight: height*.03,
                                                                    imageWidth: height*.03,
                                                                    boxWidth: height*.03,
                                                                    boxHeight: height*.03,
                                                                    isBorder: false,
                                                                    imageUrl: champItemsList["1$index1"]![index].itemImageUrl,

                                                                  );
                                                                })
                                                            )
                                                                :const SizedBox()
                                                          ],
                                                        ):
                                                        // ?  Image.network(
                                                        // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        // height: 60,
                                                        // width: 60,
                                                        // fit: BoxFit
                                                        //     .fill):
                                                        SizedBox(
                                                          height: height*.1,
                                                          width: height*.1,

                                                          child: Image.asset(
                                                              'assets/images/Polygon 7.png',
                                                          fit: BoxFit.fill,),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            )
                                        )
                                    ),
                                    Padding(

                                      padding: EdgeInsets.only(top: height*.085,left: height*.1),
                                      child: Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: List.generate(7, (index2) =>
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: SizedBox(
                                                  height:  height*.1,

                                                  width:  height*.1,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      printLog("===========>Pressed");
                                                      if(chosenTeamIndexes.contains("2$index2")){

                                                        showDialog(context: context,
                                                            builder: (context){
                                                              return AlertDialog(
                                                                content: const Text("Actions"),
                                                                actions: [
                                                                  TextButton(onPressed: (){
                                                                    printLog("===========>Exist");
                                                                    if(champItemsList.containsKey("2$index2")){
                                                                      printLog("=======>Champ items exist");
                                                                      champItemsList.remove("2$index2");
                                                                    }
                                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("2$index2"));
                                                                    chosenTeamIndexes.remove("2$index2");
                                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("2$index2");
                                                                    Navigator.pop(context);
                                                                    setState(() {

                                                                    });
                                                                  }, child: Text("Remove")),
                                                                  TextButton(onPressed: (){
                                                                    Navigator.pop(context);
                                                                  }, child: Text("Cancel"))
                                                                ],
                                                              );
                                                            });

                                                      }else{
                                                        printLog("===========>Not Exist");
                                                      }

                                                    },
                                                    child: DragTarget(

                                                      /// Todo: Extra large web screen team builder index2
                                                        onAccept: (champ) {
                                                          String index="2$index2";
                                                          ChampModel data;
                                                          ItemModel itemData;
                                                          print(champ);
                                                          // if(champ.isOfExactGenericType(ChampModel)){

                                                          if(champ.runtimeType ==ChampModel){
                                                            data=champ as ChampModel;
                                                            data.champPositionIndex=index;
                                                            print("==================+Champ model+==============");

                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                            }else{

                                                              /// If player is not present in team here we can add
                                                              // data.champPositionIndex=index.toString();
                                                              chosenTeam.add(data);
                                                              Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                              chosenTeamIndexes.add(index);

                                                              // setState(() {
                                                              //
                                                              // });
                                                            }
                                                          }
                                                          else if(champ.runtimeType==ItemModel){



                                                            itemData =champ as ItemModel;
                                                            // itemData.itemIndex=index;
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                                !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                            }else{

                                                              if(champItemsList.containsKey(index)){
                                                                List<ItemModel>? itemsData=champItemsList[index];
                                                                if(itemsData!.length>2){
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                                }else{
                                                                  chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                  itemsData.add(itemData);
                                                                  champItemsList[index]=itemsData;
                                                                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                                }
                                                              }else{
                                                                List<ItemModel> itemDataList=[];
                                                                itemDataList.add(itemData);
                                                                chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                Map<String,List<ItemModel>> newItem={
                                                                  index:itemDataList
                                                                };
                                                                champItemsList.addEntries(
                                                                    newItem.entries
                                                                );
                                                              }
                                                            }


                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again

                                                            // setState(() {
                                                            //
                                                            // });

                                                          }


                                                        },
                                                        builder: (
                                                            BuildContext context,
                                                            List<dynamic> accepted,
                                                            List<dynamic> rejected,
                                                            ) {
                                                          // print(text);
                                                          String index="2$index2";
                                                          return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                              ?Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: [
                                                              SmallImageWidget(
                                                                isPolygon:true,
                                                                imageHeight: height*.1,
                                                                imageWidth: height*.1,
                                                                boxWidth: height*.1,
                                                                boxHeight: height*.1,
                                                                isBorder: true,
                                                                imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                                borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                                Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                                Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                                Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                                Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                                Colors.yellow:Colors.red
                                                                ,

                                                              ),
                                                              champItemsList.containsKey("2$index2")?
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: List.generate(champItemsList["2$index2"]!.length, (index) {

                                                                    return SmallImageWidget(
                                                                      isPolygon:true,
                                                                      imageHeight: height*.03,
                                                                      imageWidth: height*.03,
                                                                      boxWidth: height*.03,
                                                                      boxHeight: height*.03,
                                                                      isBorder: false,
                                                                      imageUrl: champItemsList["2$index2"]![index].itemImageUrl,

                                                                    );
                                                                  })
                                                              )
                                                                  :const SizedBox()
                                                            ],
                                                          ):
                                                          // ?  Image.network(
                                                          // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          // height: 60,
                                                          // width: 60,
                                                          // fit: BoxFit
                                                          //     .fill):
                                                          SizedBox(
                                                            height: height*.1,
                                                            width: height*.1,

                                                            child: Image.asset(
                                                              'assets/images/Polygon 7.png',
                                                              fit: BoxFit.fill,),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              )
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: height*.17),
                                      child: Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: List.generate(7, (index3) =>
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: SizedBox(
                                                  height:  height*.1,
                                                  width:  height*.1,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      printLog("===========>Pressed");
                                                      if(chosenTeamIndexes.contains("3$index3")){

                                                        showDialog(context: context,
                                                            builder: (context){
                                                              return AlertDialog(
                                                                content: const Text("Actions"),
                                                                actions: [
                                                                  TextButton(onPressed: (){
                                                                    printLog("===========>Exist");
                                                                    if(champItemsList.containsKey("3$index3")){
                                                                      printLog("=======>Champ items exist");
                                                                      champItemsList.remove("3$index3");
                                                                    }
                                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("3$index3"));
                                                                    chosenTeamIndexes.remove("3$index3");
                                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("3$index3");
                                                                    Navigator.pop(context);
                                                                    setState(() {

                                                                    });
                                                                  }, child: Text("Remove")),
                                                                  TextButton(onPressed: (){
                                                                    Navigator.pop(context);
                                                                  }, child: Text("Cancel"))
                                                                ],
                                                              );
                                                            });

                                                      }else{
                                                        printLog("===========>Not Exist");
                                                      }

                                                    },
                                                    child: DragTarget(

                                                      /// Todo: Extra large web screen team builder index3
                                                        onAccept: (champ) {
                                                          String index="3$index3";
                                                          ChampModel data;
                                                          ItemModel itemData;
                                                          print(champ);
                                                          // if(champ.isOfExactGenericType(ChampModel)){

                                                          if(champ.runtimeType ==ChampModel){
                                                            data=champ as ChampModel;
                                                            data.champPositionIndex=index;
                                                            print("==================+Champ model+==============");

                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                            }else{

                                                              /// If player is not present in team here we can add
                                                              // data.champPositionIndex=index.toString();
                                                              chosenTeam.add(data);
                                                              Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                              chosenTeamIndexes.add(index);

                                                              // setState(() {
                                                              //
                                                              // });
                                                            }
                                                          }
                                                          else if(champ.runtimeType==ItemModel){



                                                            itemData =champ as ItemModel;
                                                            // itemData.itemIndex=index;
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                                !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                            }else{

                                                              if(champItemsList.containsKey(index)){
                                                                List<ItemModel>? itemsData=champItemsList[index];
                                                                if(itemsData!.length>2){
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                                }else{
                                                                  chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                  itemsData.add(itemData);
                                                                  champItemsList[index]=itemsData;
                                                                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                                }
                                                              }else{
                                                                List<ItemModel> itemDataList=[];
                                                                itemDataList.add(itemData);
                                                                chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                Map<String,List<ItemModel>> newItem={
                                                                  index:itemDataList
                                                                };
                                                                champItemsList.addEntries(
                                                                    newItem.entries
                                                                );
                                                              }
                                                            }


                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again

                                                            // setState(() {
                                                            //
                                                            // });

                                                          }


                                                        },
                                                        builder: (
                                                            BuildContext context,
                                                            List<dynamic> accepted,
                                                            List<dynamic> rejected,
                                                            ) {
                                                          // print(text);
                                                          String index="3$index3";
                                                          return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                              ?Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: [
                                                              SmallImageWidget(
                                                                isPolygon:true,
                                                                imageHeight: height*.1,
                                                                imageWidth: height*.1,
                                                                boxWidth: height*.1,
                                                                boxHeight: height*.1,
                                                                isBorder: true,
                                                                imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                                borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                                Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                                Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                                Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                                Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                                Colors.yellow:Colors.red
                                                                ,

                                                              ),
                                                              champItemsList.containsKey("3$index3")?
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: List.generate(champItemsList["3$index3"]!.length, (index) {

                                                                    return SmallImageWidget(
                                                                      isPolygon:true,
                                                                      imageHeight: height*.03,
                                                                      imageWidth: height*.03,
                                                                      boxWidth: height*.03,
                                                                      boxHeight: height*.03,
                                                                      isBorder: false,
                                                                      imageUrl: champItemsList["3$index3"]![index].itemImageUrl,

                                                                    );
                                                                  })
                                                              )
                                                                  :const SizedBox()
                                                            ],
                                                          ):
                                                          // ?  Image.network(
                                                          // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          // height: 60,
                                                          // width: 60,
                                                          // fit: BoxFit
                                                          //     .fill):
                                                          SizedBox(
                                                            height:  height*.1,
                                                            width:  height*.1,
                                                            child: Image.asset(
                                                              'assets/images/Polygon 7.png',
                                                              fit: BoxFit.fill,),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              )
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: height*.255,left: height*.1),
                                      child: Row(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: List.generate(7, (index4) =>
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: SizedBox(
                                                  height:  height*.1,
                                                  width:  height*.1,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      printLog("===========>Pressed");
                                                      if(chosenTeamIndexes.contains("4$index4")){

                                                        showDialog(context: context,
                                                            builder: (context){
                                                              return AlertDialog(
                                                                content: const Text("Actions"),
                                                                actions: [
                                                                  TextButton(onPressed: (){
                                                                    printLog("===========>Exist");
                                                                    if(champItemsList.containsKey("4$index4")){
                                                                      printLog("=======>Champ items exist");
                                                                      champItemsList.remove("4$index4");

                                                                      Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("4$index4"));
                                                                      chosenTeamIndexes.remove("4$index4");
                                                                      Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("4$index4");
                                                                      Navigator.pop(context);
                                                                      setState(() {

                                                                      });
                                                                    }
                                                                  }, child: Text("Remove")),
                                                                  TextButton(onPressed: (){
                                                                    Navigator.pop(context);
                                                                  }, child: Text("Cancel"))
                                                                ],
                                                              );
                                                            });

                                                      }else{
                                                        printLog("===========>Not Exist");
                                                      }

                                                    },
                                                    child: DragTarget(
                                                      /// Todo: Extra large web screen team builder index4
                                                        onAccept: (champ) {
                                                          String index="4$index4";
                                                          ChampModel data;
                                                          ItemModel itemData;
                                                          print(champ);
                                                          // if(champ.isOfExactGenericType(ChampModel)){

                                                          if(champ.runtimeType ==ChampModel){
                                                            data=champ as ChampModel;
                                                            data.champPositionIndex=index;
                                                            print("==================+Champ model+==============");

                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                            }else{

                                                              /// If player is not present in team here we can add
                                                              // data.champPositionIndex=index.toString();
                                                              chosenTeam.add(data);

                                                              Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                              chosenTeamIndexes.add(index);

                                                              // setState(() {
                                                              //
                                                              // });
                                                            }
                                                          }
                                                          else if(champ.runtimeType==ItemModel){



                                                            itemData =champ as ItemModel;
                                                            // itemData.itemIndex=index;
                                                            if(
                                                            Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                                !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                            }else{

                                                              if(champItemsList.containsKey(index)){
                                                                List<ItemModel>? itemsData=champItemsList[index];
                                                                if(itemsData!.length>2){
                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                                }else{
                                                                  itemsData.add(itemData);
                                                                  chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                  champItemsList[index]=itemsData;
                                                                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                                }
                                                              }else{
                                                                List<ItemModel> itemDataList=[];
                                                                itemDataList.add(itemData);
                                                                chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                Map<String,List<ItemModel>> newItem={
                                                                  index:itemDataList
                                                                };
                                                                champItemsList.addEntries(
                                                                    newItem.entries
                                                                );
                                                              }
                                                            }


                                                            /// This work is done by Salih Hayat
                                                            ///
                                                            /// I have created another list for team to be choosed
                                                            /// Also  I created another list of integer in which I store indexes of the players
                                                            /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                            /// already in the team therefore such a player cannot be added again

                                                            // setState(() {
                                                            //
                                                            // });

                                                          }


                                                        },
                                                        builder: (
                                                            BuildContext context,
                                                            List<dynamic> accepted,
                                                            List<dynamic> rejected,
                                                            ) {
                                                          // print(text);
                                                          String index="4$index4";
                                                          return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                              ?Stack(
                                                            alignment: Alignment.bottomCenter,
                                                            children: [
                                                              SmallImageWidget(
                                                                isPolygon:true,
                                                                imageHeight: height*.1,
                                                                imageWidth: height*.1,
                                                                boxWidth: height*.1,
                                                                boxHeight: height*.1,
                                                                isBorder: true,
                                                                imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                                borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                                Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                                Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                                Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                                Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                                Colors.yellow:Colors.red
                                                                ,

                                                              ),
                                                              champItemsList.containsKey("4$index4")?
                                                              Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: List.generate(champItemsList["4$index4"]!.length, (index) {

                                                                    return SmallImageWidget(
                                                                      isPolygon:true,
                                                                      imageHeight: height*.03,
                                                                      imageWidth: height*.03,
                                                                      boxWidth: height*.03,
                                                                      boxHeight: height*.03,
                                                                      isBorder: false,
                                                                      imageUrl: champItemsList["4$index4"]![index].itemImageUrl,

                                                                    );
                                                                  })
                                                              )
                                                                  :const SizedBox()
                                                            ],
                                                          ):
                                                          // ?  Image.network(
                                                          // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                          // height: 60,
                                                          // width: 60,
                                                          // fit: BoxFit
                                                          //     .fill):
                                                          SizedBox(
                                                            height:  height*.1,
                                                            width:  height*.1,
                                                            child: Image.asset(
                                                                'assets/images/Polygon 7.png',
                                                            fit: BoxFit.fill,),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              )
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF48B19),
                                    Color(0x20F48B19),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: height*.04,
                                btnWidth:
                                ResponsiveWidget.isWebScreen(context)
                                    ? width * 0.11
                                    : ResponsiveWidget.isTabletScreen(
                                    context)
                                    ? width * 0.2
                                    : width * 0.5,
                                btnText: 'Core Champs',
                              ),
                              Container(
                                width: width*.15,
                                height: height*.4,
                                // margin: const EdgeInsets.only(0),
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 20)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: const[
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                      'Double click a champ on',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'field to add them as',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'core champion for the',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'team comp.',
                                      style:
                                      TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*.01,
                  ),
                  Container(
                    height:MediaQuery.of(context).size.height*.35,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1, color: Color(0xffF48B19))),
                    child: Column(

                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 220,
                              child: TextField(
                                onChanged: (value) {
                                  Provider.of<BasicProvider>(context,listen: false).runFilter(value,true,false);
                                  setState(() {

                                  });
                                } ,
                                style: TextStyle(color: Colors.grey),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.grey),
                                  fillColor: Color(0xff191741),
                                  filled: true,
                                  hintText: 'Search champion',
                                  hintStyle:
                                  TextStyle(color: Colors.grey),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: (){
                                provider.sortChampList(true);
                                reverseSorted=false;
                                setState(() {

                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xff191741),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: reverseSorted?null:Border.all(
                                        width: 1,
                                        color: const Color(0xffF48B19)
                                    )
                                ),
                                child: const Text(
                                  'A-Z',
                                  style:
                                  TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: (){
                                provider.sortChampListZtoA(true);
                                reverseSorted=true;
                                setState(() {

                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xff191741),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: reverseSorted?Border.all(
                                        width: 1,
                                        color: const Color(0xffF48B19)
                                    ):null
                                ),
                                child: Text(
                                  'Z-A',
                                  style: TextStyle(
                                      color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff191741),
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                      "assets/images/Layer 2.png"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Any Synergy',
                                    style: TextStyle(
                                        color:
                                        Colors.grey.shade300),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Clear Filter",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const Spacer(),
                            Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff191741),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    MaterialButton(
                                        height: 35,
                                        shape:
                                        showItems?null:RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8)),
                                        color: showItems?Colors.transparent:const Color(0xffF48B19),
                                        onPressed: () {
                                          printLog("${provider.teamBuilderChamps.length}");
                                          setState(() {
                                            showItems=false;
                                          });
                                        },
                                        child: Text(
                                          'Champions',
                                          style: TextStyle(
                                              color: showItems?Colors.grey:Colors.white),
                                        )),
                                    MaterialButton(
                                        height: 35,
                                        shape:showItems?
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8)):null,
                                        color: showItems?const Color(0xffF48B19):Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            showItems=true;
                                          });
                                        },
                                        child: Text(
                                          'Items',
                                          style: TextStyle(
                                              color: showItems?Colors.white:Colors.grey),
                                        ))
                                  ],
                                )),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                        Visibility(
                          visible: showItems==false,
                          child: Container(
                              padding: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height*.28,
                              child:  Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData?
                              SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    for(int index=0;index<provider.foundData.length;index++)...[
                                      Column(
                                        children: [
                                          Draggable(
                                            data: provider.foundData[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: SmallImageWidget(
                                              boxWidth: 70,
                                              boxHeight: 70,
                                              imageHeight: 70,
                                              imageWidth: 70,
                                              isBorder: true,
                                              imageUrl: provider.foundData[index].imagePath,
                                              borderColor: provider.foundData[index].champCost=='1'?
                                              Colors.grey:provider.foundData[index].champCost=='2'?
                                              Colors.green:provider.foundData[index].champCost=='3'?
                                              Colors.blue:provider.foundData[index].champCost=='4'?
                                              Colors.purple:provider.foundData[index].champCost=='5'?
                                              Colors.yellow:Colors.red
                                              ,

                                            ),
                                            child: Column(
                                              children: [
                                                SmallImageWidget(
                                                  boxWidth: 70,
                                                  boxHeight: 70,
                                                  imageHeight: 70,
                                                  imageWidth: 70,
                                                  isBorder: true,
                                                  imageUrl: provider.foundData[index].imagePath,
                                                  borderColor: provider.foundData[index].champCost=='1'?
                                                  Colors.grey:provider.foundData[index].champCost=='2'?
                                                  Colors.green:provider.foundData[index].champCost=='3'?
                                                  Colors.blue:provider.foundData[index].champCost=='4'?
                                                  Colors.purple:provider.foundData[index].champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,

                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  provider.foundData[index].champName,
                                                  style: const TextStyle(
                                                      color:
                                                      Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                    ,
                                  ],
                                ),
                              ):
                              Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData==false?
                              SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    for(int index=0;index<provider.teamBuilderChamps.length;index++)...[
                                      Draggable(
                                        data: provider.teamBuilderChamps[index],
                                        onDraggableCanceled:
                                            (velocity, offset) {},
                                        feedback: SmallImageWidget(
                                          boxWidth: 70,
                                          boxHeight: 70,
                                          imageHeight: 70,
                                          imageWidth: 70,
                                          isBorder: true,
                                          imageUrl: provider.teamBuilderChamps[index].imagePath,
                                          borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                          Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                          Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                          Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                          Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                          Colors.yellow:Colors.red
                                          ,

                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SmallImageWidget(
                                              boxWidth: 70,
                                              boxHeight: 70,
                                              imageHeight: 70,
                                              imageWidth: 70,
                                              isBorder: true,
                                              imageUrl: provider.teamBuilderChamps[index].imagePath,
                                              borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                              Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                              Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                              Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                              Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                              Colors.yellow:Colors.red
                                              ,

                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              provider.teamBuilderChamps[index].champName,
                                              style: const TextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]

                                  ],
                                ),
                              ):
                              const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                          ),
                        ),
                        Visibility(
                          visible: showItems,
                          child: Container(
                            height: MediaQuery.of(context).size.height*.28,
                              child:  Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData?
                              SingleChildScrollView(
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: width*.01,
                                  runSpacing: width*.01,
                                  children: [
                                    for(int index=0;index<provider.foundItems.length;index++)...[
                                      Column(

                                        mainAxisSize:MainAxisSize.min,
                                        children: [
                                          Draggable(
                                            data: provider.foundItems[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: SmallImageWidget(
                                              boxWidth: height*.1,
                                              boxHeight: height*.1,
                                              imageHeight: height*.1,
                                              imageWidth: height*.1,
                                              isBorder: true,
                                              imageUrl: provider.foundItems[index].itemImageUrl.toString().toLowerCase(),


                                            ),
                                            child: Container(
                                                child: Column(
                                                  children: [
                                                    SmallImageWidget(
                                                      boxWidth: height*.1,
                                                      boxHeight: height*.1,
                                                      imageHeight: height*.1,
                                                      imageWidth: height*.1,
                                                      isBorder: true,
                                                      imageUrl: provider.foundItems[index].itemImageUrl,


                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      provider.foundItems[index].itemName,
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ]

                                  ],
                                ),
                              ):
                              Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData==false?
                              SingleChildScrollView(
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: width*.01,
                                  runSpacing: width*.01,
                                  children: [
                                    for(int index=0;index<provider.teamBuilderItems.length;index++)...[
                                      Column(
                                        children: [
                                          Draggable(
                                            data: provider.teamBuilderItems[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: SmallImageWidget(
                                              boxWidth: height*.1,
                                              boxHeight: height*.1,
                                              imageHeight: height*.1,
                                              imageWidth: height*.1,
                                              isBorder: true,
                                              imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SmallImageWidget(
                                                  boxWidth: height*.1,
                                                  boxHeight: height*.1,
                                                  imageHeight: height*.1,
                                                  imageWidth: height*.1,
                                                  isBorder: true,
                                                  imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  provider.teamBuilderItems[index].itemName.length>14?provider.teamBuilderItems[index].itemName.substring(0,15):
                                                  provider.teamBuilderItems[index].itemName,
                                                  style: const TextStyle(
                                                      color:
                                                      Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                    ,
                                  ],
                                ),
                              ):
                              const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ):
              ResponsiveWidget.isWebScreen(context)
                  ? Column(
                children: [
                  SizedBox(
                    height: height>800?height*.5:height*.7,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// menu icon
                            IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/");
                              },
                              icon: const MenuIcon(),
                            ),
                            const SizedBox(width: 12.0),
                            /// premium button
                            // PremiumButton(onTap: () {}),
                            // const Spacer(),

                            SizedBox(width: MediaQuery.of(context).size.width*.27),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: const Color(0xffFF2D2D),
                              onPressed: () {
                                Navigator.pushNamed(context, "/");
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12.0),
                            // const SizedBox(
                            //   width: 12,
                            // ),

                            /// Save Button
                            /// By Pressing save button data is saved to firestore
                            /// Comp Collection
                            ///
                            Provider.of<BasicProvider>(context).isLoading?const CircularProgressIndicator():MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: const Color(0xffF48B19),
                              onPressed: () async{

                                printLog("user name: ${userProvider!.user!.userName=="Admin"}");
                                /// Setup for local db
                                if(userProvider!.user!.userName=="Admin"){
                                  if(chosenTeam.isNotEmpty){
                                    Provider.of<BasicProvider>(context,listen: false).startLoading();
                                    String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                    await FirestoreCompServices().addCompToPopularAdmin(docId, docId,chosenTeam,champItemsList,champ.length.toString(),context);
                                    DateTime date=DateTime.now();
                                    await FirebaseFirestore.instance.collection("dataUpdate").doc("A7PYFjiHuEqT2jKMivKP").update(

                                        {
                                          "compsUpdate": date.toString()
                                        }
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                    chosenTeam.clear();
                                    chosenTeamIndexes.clear();
                                    Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }
                                }else{
                                  if(chosenTeam.isNotEmpty){
                                    Provider.of<BasicProvider>(context,listen: false).startLoading();
                                    setState(() {

                                    });
                                    String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                    String userId=FirebaseAuth.instance.currentUser!.uid;
                                    print(userId);
                                    printLog("==========>Champ items list length: ${champItemsList.length}");
                                    await FirestoreCompServices().addCompToMyTeams(userId,docId, chosenTeam,champItemsList,champ.length.toString(),context);


                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                    chosenTeam.clear();
                                    chosenTeamIndexes.clear();
                                    Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                    setState(() {

                                    });
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }
                                }



                              },
                              child: Provider.of<BasicProvider>(context).isLoading?
                                  const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            SizedBox(width:20),
                            userProvider!.user!.userName!="Admin"?SizedBox.shrink():MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: const Color(0xffF48B19),
                              onPressed: ()async{
                                await autoCompGeneration();
                              },

                              child: autoGenerateLoader?
                              const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):const Text(
                                'Auto',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            // Spacer(),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(12)),
                            //   color: Color(0xff00ABDE),
                            //   onPressed: () {
                            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminHomeScreen()));
                            //
                            //   },
                            //   child: Text(
                            //     'Create Guide',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 12,
                            // ),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(12)),
                            //   color: Color(0xffF48B19),
                            //   onPressed: () {},
                            //   child: Text(
                            //     'Share',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 12,
                            // ),
                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(12)),
                            //   color: const Color(0xffFF2D2D),
                            //   onPressed: () {},
                            //   child: const Text(
                            //     'Delete',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            // const Spacer(),

                            /// actions icons
                            // ActionButtonWidget(
                            //     onTap: () {}, iconPath: AppIcons.chat),
                            // const SizedBox(width: 8),
                            // ActionButtonWidget(
                            //     onTap: () {}, iconPath: AppIcons.setting),
                            // const SizedBox(width: 8),
                            // ActionButtonWidget(
                            //   onTap: () {},
                            //   iconPath: AppIcons.bell,
                            //   isNotify: true,
                            // ),
                            // const SizedBox(width: 8),
                            //
                            // /// user name and image
                            // // Text('Madeline Goldner',
                            // //   style: poppinsRegular.copyWith(
                            // //     fontSize: 16,
                            // //     color: AppColors.whiteColor,
                            // //   ),
                            // // ),
                            // const CircleAvatar(
                            //   radius: 22,
                            //   backgroundImage:
                            //   AssetImage(AppImages.userImage),
                            // ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: SvgPicture.asset(AppIcons.dotVert),
                            // ),
                          ],
                        ),
                        const Text(
                          'Team Builder',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 40),
                        ),
                        const Text(
                          'Drag & Drop players to build your best team,',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 21),
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                NeonTabButtonWidget(
                                  onTap: null,
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xffF48B19),
                                      const Color(0xffF48B19).withOpacity(0.2),
                                      const Color(0xffF48B19).withOpacity(0.0),
                                      const Color(0xffF48B19).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  btnHeight: 35,
                                  btnWidth:
                                  ResponsiveWidget.isWebScreen(context)
                                      ? width * 0.11
                                      : ResponsiveWidget.isTabletScreen(
                                      context)
                                      ? width * 0.2
                                      : width * 0.3,
                                  btnText: 'Synergy',
                                ),
                                Container(
                                  width: 200,

                                  // margin: const EdgeInsets.only(0),
                                  padding:
                                  ResponsiveWidget.isWebScreen(context)
                                      ? const EdgeInsets.symmetric(
                                      horizontal: 10)
                                      : const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  decoration:
                                  ImagePageBoxDecoration(context),
                                  child: Column(
                                    children: const [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      Text(
                                        'Start building your camp',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        'to see the synergies.',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            SizedBox(
                              // height: height>heightConstraint?height*.3:height*.44,
                              // width: 420,
                              child: Stack(
                                children: [
                                  Row(
                                    children: List.generate(7, (index1) =>
                                        SizedBox(
                                          height: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                          width: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                          child: GestureDetector(
                                            onTap: (){
                                              printLog("===========>Pressed");
                                              if(chosenTeamIndexes.contains("1$index1")){

                                                showDialog(context: context,
                                                    builder: (context){
                                                  return AlertDialog(
                                                    content: const Text("Actions"),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        printLog("===========>Exist");
                                                        if(champItemsList.containsKey("1$index1")){
                                                          printLog("=======>Champ items exist");
                                                          champItemsList.remove("1$index1");
                                                        }
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("1$index1"));
                                                        chosenTeamIndexes.remove("1$index1");
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("1$index1");
                                                        Navigator.pop(context);
                                                        setState(() {

                                                        });
                                                      }, child: Text("Remove")),
                                                      TextButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: Text("Cancel"))
                                                    ],
                                                  );
                                                    });

                                              }else{
                                                printLog("===========>Not Exist");
                                              }

                                            },
                                            child: DragTarget(
                                              /// Todo: web screen team builder index1
                                                onAccept: (champ) {
                                                  String index="1$index1";
                                                  ChampModel data;
                                                  ItemModel itemData;
                                                  print(champ);
                                                  // if(champ.isOfExactGenericType(ChampModel)){


                                                  if(champ.runtimeType ==ChampModel){
                                                    data=champ as ChampModel;
                                                    data.champPositionIndex=index;
                                                    print("==================+Champ model+==============");

                                                    /// This work is done by Salih Hayat
                                                    ///
                                                    /// I have created another list for team to be choosed
                                                    /// Also  I created another list of integer in which I store indexes of the players
                                                    /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                    /// already in the team therefore such a player cannot be added again
                                                    if(
                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                    }else{

                                                      /// If player is not present in team here we can add
                                                      // data.champPositionIndex=index.toString();
                                                      chosenTeam.add(data);
                                                      Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                      chosenTeamIndexes.add(index);

                                                      // setState(() {
                                                      //
                                                      // });
                                                    }
                                                  }
                                                  else if(champ.runtimeType==ItemModel){



                                                    itemData =champ as ItemModel;
                                                    // itemData.itemIndex=index;
                                                    if(
                                                    Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                    !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                    }else{

                                                      if(champItemsList.containsKey(index)){
                                                        List<ItemModel>? itemsData=champItemsList[index];
                                                        if(itemsData!.length>2){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                        }else{
                                                          chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                          itemsData.add(itemData);
                                                          champItemsList[index]=itemsData;
                                                          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                        }
                                                      }else{
                                                        List<ItemModel> itemDataList=[];
                                                        itemDataList.add(itemData);
                                                        chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                        Map<String,List<ItemModel>> newItem={
                                                          index:itemDataList
                                                        };
                                                        champItemsList.addEntries(
                                                            newItem.entries
                                                        );
                                                      }
                                                    }


                                                    /// This work is done by Salih Hayat
                                                    ///
                                                    /// I have created another list for team to be choosed
                                                    /// Also  I created another list of integer in which I store indexes of the players
                                                    /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                    /// already in the team therefore such a player cannot be added again

                                                    // setState(() {
                                                    //
                                                    // });

                                                  }


                                                },
                                                builder: (
                                                    BuildContext context,
                                                    List<dynamic> accepted,
                                                    List<dynamic> rejected,
                                                    ) {
                                                  // print(text);
                                                  String index="1$index1";
                                                  return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                      ?Stack(
                                                    alignment: Alignment.bottomCenter,
                                                    children: [
                                                      SmallImageWidget(
                                                        isPolygon: true,
                                                        imageWidth: height*.12,
                                                        imageHeight: height*.12,
                                                        boxHeight: height*.12,
                                                        boxWidth: height*.12,
                                                        isBorder: true,
                                                        imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                        borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                        Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                        Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                        Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                        Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                        Colors.yellow:Colors.red
                                                        ,

                                                      ),
                                                      champItemsList.containsKey("1$index1")?
                                                      Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: List.generate(champItemsList["1$index1"]!.length, (index) {

                                                            return SmallImageWidget(
                                                              isPolygon: true,
                                                              imageHeight: height*.04,
                                                              imageWidth: height*.04,
                                                              boxWidth: height*.04,
                                                              boxHeight: height*.04,
                                                              isBorder: false,
                                                              imageUrl: champItemsList["1$index1"]![index].itemImageUrl,

                                                            );
                                                          })
                                                      )
                                                          :const SizedBox()
                                                    ],
                                                  ):
                                                  // ?  Image.network(
                                                  // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  // height: 60,
                                                  // width: 60,
                                                  // fit: BoxFit
                                                  //     .fill):
                                                  Image.asset(
                                                      'assets/images/Polygon 7.png');
                                                }),
                                          ),
                                        )
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: height>heightConstraint?height*.075:height*.1,left: height>heightConstraint?height*.04:height*.06),
                                    child: Row(
                                        children: List.generate(7, (index2) =>
                                            SizedBox(
                                              height: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              width: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("2$index2")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("2$index2")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("2$index2");
                                                                }
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("2$index2"));
                                                                chosenTeamIndexes.remove("2$index2");
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("2$index2");
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(
                                                  /// Todo:  web screen team builder index2
                                                    onAccept: (champ) {
                                                      String index="2$index2";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                        if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);
                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                        else if(champ.runtimeType==ItemModel){



                                                          itemData =champ as ItemModel;
                                                          // itemData.itemIndex=index;
                                                          if(
                                                          Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                              !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                          }else{

                                                            if(champItemsList.containsKey(index)){
                                                              List<ItemModel>? itemsData=champItemsList[index];
                                                              if(itemsData!.length>2){
                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                              }else{
                                                                chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                                itemsData.add(itemData);
                                                                champItemsList[index]=itemsData;
                                                                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                              }
                                                            }else{
                                                              List<ItemModel> itemDataList=[];
                                                              itemDataList.add(itemData);
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              Map<String,List<ItemModel>> newItem={
                                                                index:itemDataList
                                                              };
                                                              champItemsList.addEntries(
                                                                  newItem.entries
                                                              );
                                                            }
                                                          }


                                                          /// This work is done by Salih Hayat
                                                          ///
                                                          /// I have created another list for team to be choosed
                                                          /// Also  I created another list of integer in which I store indexes of the players
                                                          /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                          /// already in the team therefore such a player cannot be added again

                                                          // setState(() {
                                                          //
                                                          // });

                                                        }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="2$index2";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isPolygon: true,
                                                            imageHeight: height*.12,
                                                            imageWidth: height*.12,
                                                            boxWidth: height*.12,
                                                            boxHeight: height*.12,
                                                            isBorder: true,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("2$index2")?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["2$index2"]!.length, (index) {

                                                                return SmallImageWidget(
                                                                  isPolygon: true,
                                                                  imageHeight: height*.04,
                                                                  imageWidth: height*.04,
                                                                  boxWidth: height*.04,
                                                                  boxHeight: height*.04,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["2$index2"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: height>heightConstraint?height*.15:height>heightConstraint1100?height*.12:height*.2),
                                    child: Row(
                                        children: List.generate(7, (index3) =>
                                            SizedBox(
                                              height: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              width: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("3$index3")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("3$index3")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("3$index3");
                                                                }
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("3$index3"));
                                                                chosenTeamIndexes.remove("3$index3");
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("3$index3");
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(
                                                  /// Todo:  web screen team builder index3
                                                    onAccept: (champ) {
                                                      String index="3$index3";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                      if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);
                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                      else if(champ.runtimeType==ItemModel){



                                                        itemData =champ as ItemModel;
                                                        // itemData.itemIndex=index;
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                            !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                        }else{

                                                          if(champItemsList.containsKey(index)){
                                                            List<ItemModel>? itemsData=champItemsList[index];
                                                            if(itemsData!.length>2){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                            }else{
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              itemsData.add(itemData);
                                                              champItemsList[index]=itemsData;
                                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                            }
                                                          }else{
                                                            List<ItemModel> itemDataList=[];
                                                            itemDataList.add(itemData);
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            Map<String,List<ItemModel>> newItem={
                                                              index:itemDataList
                                                            };
                                                            champItemsList.addEntries(
                                                                newItem.entries
                                                            );
                                                          }
                                                        }


                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again

                                                        // setState(() {
                                                        //
                                                        // });

                                                      }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="3$index3";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isPolygon: true,
                                                            imageHeight: height*.12,
                                                            imageWidth: height*.12,
                                                            boxWidth: height*.12,
                                                            boxHeight: height*.12,
                                                            isBorder: true,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("3$index3")?
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["3$index3"]!.length, (index) {

                                                                return SmallImageWidget(
                                                                  isPolygon: true,
                                                                  imageHeight: height*.04,
                                                                  imageWidth: height*.04,
                                                                  boxWidth: height*.04,
                                                                  boxHeight: height*.04,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["3$index3"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: height>heightConstraint?height*.225:height*.3,left: height>heightConstraint?height*.04:height*.06),
                                    child: Row(
                                        children: List.generate(7, (index4) =>
                                            SizedBox(
                                              height: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              width: height>heightConstraint&&height<heightConstraint1100?height*.09:height>heightConstraint1100?height*.075:height*.12,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("4$index4")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("4$index4")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("4$index4");

                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("4$index4"));
                                                                chosenTeamIndexes.remove("4$index4");
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("4$index4");
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              }
                                                                }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(
                                                  /// Todo:  web screen team builder index4
                                                    onAccept: (champ) {
                                                      String index="4$index4";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                      if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);

                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                      else if(champ.runtimeType==ItemModel){



                                                        itemData =champ as ItemModel;
                                                        // itemData.itemIndex=index;
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                            !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                        }else{

                                                          if(champItemsList.containsKey(index)){
                                                            List<ItemModel>? itemsData=champItemsList[index];
                                                            if(itemsData!.length>2){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                            }else{
                                                              itemsData.add(itemData);
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              champItemsList[index]=itemsData;
                                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                            }
                                                          }else{
                                                            List<ItemModel> itemDataList=[];
                                                            itemDataList.add(itemData);
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            Map<String,List<ItemModel>> newItem={
                                                              index:itemDataList
                                                            };
                                                            champItemsList.addEntries(
                                                                newItem.entries
                                                            );
                                                          }
                                                        }


                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again

                                                        // setState(() {
                                                        //
                                                        // });

                                                      }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="4$index4";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isPolygon: true,
                                                            imageHeight: height*.12,
                                                            imageWidth: height*.12,
                                                            boxWidth: height*.12,
                                                            boxHeight: height*.12,
                                                            isBorder: true,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("4$index4")?
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["4$index4"]!.length, (index) {

                                                                return SmallImageWidget(
                                                                  isPolygon: true,
                                                                  imageHeight: height*.04,
                                                                  imageWidth: height*.04,
                                                                  boxWidth: height*.04,
                                                                  boxHeight: height*.04,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["4$index4"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Spacer(),
                            Column(
                              children: [
                                NeonTabButtonWidget(
                                  onTap: null,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffF48B19),
                                      Color(0x20F48B19),
                                      // Color(0xffF48B19).withOpacity(0.0),
                                      // Color(0xffF48B19).withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  btnHeight: 35,
                                  btnWidth:
                                  ResponsiveWidget.isWebScreen(context)
                                      ? width * 0.11
                                      : ResponsiveWidget.isTabletScreen(
                                      context)
                                      ? width * 0.2
                                      : width * 0.3,
                                  btnText: 'Core Champs',
                                ),
                                Container(
                                  width: 200,
                                  
                                  // margin: const EdgeInsets.only(0),
                                  padding:
                                  ResponsiveWidget.isWebScreen(context)
                                      ? const EdgeInsets.symmetric(
                                      horizontal: 20)
                                      : const EdgeInsets.symmetric(
                                      horizontal: 8),
                                  decoration:
                                  ImagePageBoxDecoration(context),
                                  child: Column(
                                    children: const [
                                      SizedBox(
                                        height: 80,
                                      ),
                                      Text(
                                        'Double click a champ on',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),

                                      Text(
                                        'field to add them as',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        'core champion for the',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        'team comp.',
                                        style:
                                        TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(
                                        height: 70,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height:MediaQuery.of(context).size.height*.23,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            width: 1, color: Color(0xffF48B19))),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const SizedBox(width: 12),
                            Container(
                              width: 220,
                              child: TextField(
                                onChanged: (value) {
                                  Provider.of<BasicProvider>(context,listen: false).runFilter(value,true,false);
                                  setState(() {

                                  });
                                } ,
                                style: TextStyle(color: Colors.grey),
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.grey),
                                  fillColor: Color(0xff191741),
                                  filled: true,
                                  hintText: 'Search champion',
                                  hintStyle:
                                  TextStyle(color: Colors.grey),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 20.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.mainColor,
                                        width: 2.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: (){
                                provider.sortChampList(true);
                                reverseSorted=false;
                                setState(() {

                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: const Color(0xff191741),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: reverseSorted?null:Border.all(
                                        width: 1,
                                        color: const Color(0xffF48B19)
                                    )
                                ),
                                child: const Text(
                                  'A-Z',
                                  style:
                                  TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: (){
                                provider.sortChampListZtoA(true);
                                reverseSorted=true;
                                setState(() {

                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color(0xff191741),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                    border: reverseSorted?Border.all(
                                        width: 1,
                                        color: const Color(0xffF48B19)
                                    ):null
                                ),
                                child: Text(
                                  'Z-A',
                                  style: TextStyle(
                                      color: Colors.grey.shade300),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xff191741),
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                      "assets/images/Layer 2.png"),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Any Synergy',
                                    style: TextStyle(
                                        color:
                                        Colors.grey.shade300),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Clear Filter",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                            const Spacer(),
                            Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xff191741),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    MaterialButton(
                                        height: 35,
                                        shape:
                                        showItems?null:RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8)),
                                        color: showItems?Colors.transparent:const Color(0xffF48B19),
                                        onPressed: () {
                                          printLog("${provider.teamBuilderChamps.length}");
                                          setState(() {
                                            showItems=false;
                                          });
                                        },
                                        child: Text(
                                          'Champions',
                                          style: TextStyle(
                                              color: showItems?Colors.grey:Colors.white),
                                        )),
                                    MaterialButton(
                                        height: 35,
                                        shape:showItems?
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                8)):null,
                                        color: showItems?const Color(0xffF48B19):Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            showItems=true;
                                          });
                                        },
                                        child: Text(
                                          'Items',
                                          style: TextStyle(
                                              color: showItems?Colors.white:Colors.grey),
                                        ))
                                  ],
                                )),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                        Visibility(
                          visible: showItems==false,
                          child: Expanded(
                            child: Container(
                              // height: MediaQuery.of(context).size.height*.175,
                              child:  Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData?
                              GridView.builder(
                                  physics: const ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 12,
                                      mainAxisExtent: 85,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 10,
                                  ),
                                  itemCount: provider.foundData.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          /*****************************************************************************8
                                           * Draggable  widget
                                           *******************************************************************************/

                                          child: Draggable(
                                            data: provider.foundData[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(12),
                                                child:SmallImageWidget(
                                                  isBorder: true,
                                                  imageUrl: provider.foundData[index].imagePath,
                                                  borderColor: provider.foundData[index].champCost=='1'?
                                                  Colors.grey:provider.foundData[index].champCost=='2'?
                                                  Colors.green:provider.foundData[index].champCost=='3'?
                                                  Colors.blue:provider.foundData[index].champCost=='4'?
                                                  Colors.purple:provider.foundData[index].champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,

                                                )
                                              // child: Image.network(
                                              //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              //     height: 70,
                                              //     width: 70,
                                              //     fit: BoxFit.fill),
                                            ),
                                            child: Container(
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12),
                                                      child: SmallImageWidget(
                                                        isBorder: true,
                                                        imageUrl: provider.foundData[index].imagePath,
                                                        borderColor: provider.foundData[index].champCost=='1'?
                                                        Colors.grey:provider.foundData[index].champCost=='2'?
                                                        Colors.green:provider.foundData[index].champCost=='3'?
                                                        Colors.blue:provider.foundData[index].champCost=='4'?
                                                        Colors.purple:provider.foundData[index].champCost=='5'?
                                                        Colors.yellow:Colors.red
                                                        ,

                                                      ),
                                                      // child: Image.network(
                                                      //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      //     height: 60,
                                                      //     width: 60,
                                                      //     fit: BoxFit
                                                      //         .fill),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      provider.foundData[index].champName,
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                                  }):
                              Provider.of<BasicProvider>(context).dataFetched &&
                                  provider.visibleSearchData==false?
                              GridView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 20,
                                      mainAxisExtent: 90,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 15,
                                    bottom: 10,
                                  ),
                                  itemCount: provider.teamBuilderChamps.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          /*****************************************************************************8
                                           * Draggable  widget
                                           *******************************************************************************/

                                          child: Draggable(
                                            data: provider.teamBuilderChamps[index],
                                            onDraggableCanceled:
                                                (velocity, offset) {},
                                            feedback: ClipRRect(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(12),
                                                child:SmallImageWidget(
                                                  isBorder: true,
                                                  imageUrl: provider.teamBuilderChamps[index].imagePath,
                                                  borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                  Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                  Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                  Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                  Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                  Colors.yellow:Colors.red
                                                  ,

                                                )
                                              // child: Image.network(
                                              //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                              //     height: 70,
                                              //     width: 70,
                                              //     fit: BoxFit.fill),
                                            ),
                                            child: Container(
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12),
                                                      child: SmallImageWidget(
                                                        isBorder: true,
                                                        imageUrl: provider.teamBuilderChamps[index].imagePath,
                                                        borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                        Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                        Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                        Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                        Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                        Colors.yellow:Colors.red
                                                        ,

                                                      ),
                                                      // child: Image.network(
                                                      //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      //     height: 60,
                                                      //     width: 60,
                                                      //     fit: BoxFit
                                                      //         .fill),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      provider.teamBuilderChamps[index].champName,
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      ],
                                    );
                                  }):
                              const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showItems,
                          child: Expanded(
                            child: Container(
                              // height: MediaQuery.of(context).size.height*.175,
                                child:  Provider.of<BasicProvider>(context).dataFetched &&
                                    provider.visibleSearchData?
                                GridView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 12,
                                        mainAxisExtent: 85,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                    padding: const EdgeInsets.only(
                                      top: 15,
                                      bottom: 10,
                                    ),
                                    itemCount: provider.foundItems.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            /*****************************************************************************8
                                             * Draggable  widget
                                             *******************************************************************************/

                                            child: Draggable(
                                              data: provider.foundItems[index],
                                              onDraggableCanceled:
                                                  (velocity, offset) {},
                                              feedback: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  child:SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: provider.foundItems[index].itemImageUrl.toString().toLowerCase(),


                                                  )
                                                // child: Image.network(
                                                //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                //     height: 70,
                                                //     width: 70,
                                                //     fit: BoxFit.fill),
                                              ),
                                              child: Container(
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            12),
                                                        child: SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.foundItems[index].itemImageUrl,


                                                        ),
                                                        // child: Image.network(
                                                        //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        //     height: 60,
                                                        //     width: 60,
                                                        //     fit: BoxFit
                                                        //         .fill),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        provider.foundItems[index].itemName,
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      );
                                    }):
                                Provider.of<BasicProvider>(context).dataFetched &&
                                    provider.visibleSearchData==false?
                                GridView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 12,
                                        mainAxisExtent: 85,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    itemCount: provider.teamBuilderItems.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Expanded(
                                            /*****************************************************************************8
                                             * Draggable  widget
                                             *******************************************************************************/

                                            child: Draggable(
                                              data: provider.teamBuilderItems[index],
                                              onDraggableCanceled:
                                                  (velocity, offset) {},
                                              feedback: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  child:SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                                  )
                                                // child: Image.network(
                                                //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                //     height: 70,
                                                //     width: 70,
                                                //     fit: BoxFit.fill),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        12),
                                                    child: SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                                    ),
                                                    // child: Image.network(
                                                    //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                    //     height: 60,
                                                    //     width: 60,
                                                    //     fit: BoxFit
                                                    //         .fill),
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    provider.teamBuilderItems[index].itemName.length>14?provider.teamBuilderItems[index].itemName.substring(0,15):
                                                    provider.teamBuilderItems[index].itemName,
                                                    style: const TextStyle(
                                                        color:
                                                        Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }):
                                const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              )
              ///
              ///
              ///  Below code is for Mobile and Tablet
              ///
              ///
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// menu icon
                            IconButton(
                              onPressed: () {
                                // getNameData();
                              },
                              icon: MenuIcon(),
                            ),
                            SizedBox(width: 12.0),

                            /// premium button
                            // PremiumButton(onTap: () {}),
                            const SizedBox(
                              width: 12,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              color: Color(0xffFF2D2D),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Provider.of<BasicProvider>(context).isLoading?const CircularProgressIndicator():MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              color: const Color(0xffF48B19),
                              onPressed: () async{

                                /// Setup for local db
                                if(userProvider!.user!.userName=="Admin"){
                                  if(chosenTeam.isNotEmpty){
                                    Provider.of<BasicProvider>(context,listen: false).startLoading();
                                    String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                    await FirestoreCompServices().addCompToPopularAdmin(docId, docId,chosenTeam,champItemsList,champ.length.toString(),context);
                                    DateTime date=DateTime.now();
                                    await FirebaseFirestore.instance.collection("dataUpdate").doc("A7PYFjiHuEqT2jKMivKP").update(

                                        {
                                          "compsUpdate": date.toString()
                                        }
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                    chosenTeam.clear();
                                    chosenTeamIndexes.clear();
                                    Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }
                                }else{
                                  if(chosenTeam.isNotEmpty){
                                    Provider.of<BasicProvider>(context,listen: false).startLoading();
                                    setState(() {

                                    });
                                    String docId = DateTime.now().microsecondsSinceEpoch.toString();
                                    String userId=FirebaseAuth.instance.currentUser!.uid;
                                    print(userId);
                                    printLog("==========>Champ items list length: ${champItemsList.length}");
                                    await FirestoreCompServices().addCompToMyTeams(userId,docId, chosenTeam,champItemsList,champ.length.toString(),context);


                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved successfully")));
                                    chosenTeam.clear();
                                    chosenTeamIndexes.clear();
                                    Provider.of<BasicProvider>(context,listen: false).resetChosenTeam();
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                    setState(() {

                                    });
                                  }else{
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("List is empty")));
                                    Provider.of<BasicProvider>(context,listen: false).stopLoading();
                                  }
                                }



                              },
                              child: Provider.of<BasicProvider>(context).isLoading?
                              const Center(child: SizedBox(height:20,width:20,child: CircularProgressIndicator())):const Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            // MaterialButton(
                            //   shape: RoundedRectangleBorder(
                            //       borderRadius:
                            //       BorderRadius.circular(12)),
                            //   color: const Color(0xffF48B19),
                            //   onPressed: () {},
                            //   child: const Text(
                            //     'Save',
                            //     style: TextStyle(color: Colors.white),
                            //   ),
                            // ),
                            const SizedBox(
                              width: 12,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              color: Color(0xff00ABDE),
                              onPressed: () {},
                              child: const Text(
                                'Create Guide',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              color: Color(0xffF48B19),
                              onPressed: () {},
                              child: const Text(
                                'Share',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(12)),
                              color: Color(0xffFF2D2D),
                              onPressed: () {},
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),

                            /// actions icons
                            ActionButtonWidget(
                                onTap: () {}, iconPath: AppIcons.chat),
                            const SizedBox(width: 8),
                            ActionButtonWidget(
                                onTap: () {},
                                iconPath: AppIcons.setting),
                            const SizedBox(width: 8),
                            ActionButtonWidget(
                              onTap: () {},
                              iconPath: AppIcons.bell,
                              isNotify: true,
                            ),
                            SizedBox(width: 8),

                            const CircleAvatar(
                              radius: 22,
                              backgroundImage:
                              AssetImage(AppImages.userImage),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(AppIcons.dotVert),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Center(
                        child: Text(
                          'Team Builder',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Drag & Drop players to build your best team,',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MediaQuery.of(context).size.width>600
                              &&MediaQuery.of(context).size.width<=1200?Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xffF48B19),
                                    const Color(0xffF48B19).withOpacity(0.2),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                    const Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: 35,
                                btnWidth: width * 0.2,
                                btnText: 'Synergy',
                              ),
                              Container(
                                width: width*.22,
                                height: 170,
                                alignment: Alignment.center,

                                // margin: const EdgeInsets.only(0),
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 10)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: const Text(
                                  'Start building your camp to see the synergies.',
                                    textAlign:TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ):
                      SizedBox.shrink(),

                          Center(
                            child:
                            SizedBox(
                              height: 170,
                              width: 300,
                              child: Stack(
                                children: [
                                  Row(
                                      children: List.generate(7, (index1) =>
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: GestureDetector(
                                              onTap: (){
                                                printLog("===========>Pressed");
                                                if(chosenTeamIndexes.contains("1$index1")){

                                                  showDialog(context: context,
                                                      builder: (context){
                                                        return AlertDialog(
                                                          content: const Text("Actions"),
                                                          actions: [
                                                            TextButton(onPressed: (){
                                                              printLog("===========>Exist");
                                                              if(champItemsList.containsKey("1$index1")){
                                                                printLog("=======>Champ items exist");
                                                                champItemsList.remove("1$index1");
                                                              }
                                                              Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("1$index1"));
                                                              chosenTeamIndexes.remove("1$index1");
                                                              Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("1$index1");
                                                              Navigator.pop(context);
                                                              setState(() {

                                                              });
                                                            }, child: Text("Remove")),
                                                            TextButton(onPressed: (){
                                                              Navigator.pop(context);
                                                            }, child: Text("Cancel"))
                                                          ],
                                                        );
                                                      });

                                                }else{
                                                  printLog("===========>Not Exist");
                                                }

                                              },
                                              child: DragTarget(
                                                ///Todo: tablet or mobile index 1
                                                  onAccept: (champ) {
                                                    String index="1$index1";
                                                    ChampModel data;
                                                    ItemModel itemData;
                                                    print(champ);
                                                    // if(champ.isOfExactGenericType(ChampModel)){


                                                    if(champ.runtimeType ==ChampModel){
                                                      data=champ as ChampModel;
                                                      data.champPositionIndex=index;
                                                      print("==================+Champ model+==============");

                                                      /// This work is done by Salih Hayat
                                                      ///
                                                      /// I have created another list for team to be choosed
                                                      /// Also  I created another list of integer in which I store indexes of the players
                                                      /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                      /// already in the team therefore such a player cannot be added again
                                                      if(
                                                      Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                      }else{

                                                        /// If player is not present in team here we can add
                                                        // data.champPositionIndex=index.toString();
                                                        chosenTeam.add(data);
                                                        Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                        chosenTeamIndexes.add(index);

                                                        // setState(() {
                                                        //
                                                        // });
                                                      }
                                                    }
                                                    else if(champ.runtimeType==ItemModel){



                                                      itemData =champ as ItemModel;
                                                      // itemData.itemIndex=index;
                                                      if(
                                                      Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                          !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                      }else{

                                                        if(champItemsList.containsKey(index)){
                                                          List<ItemModel>? itemsData=champItemsList[index];
                                                          if(itemsData!.length>2){
                                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                          }else{
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            itemsData.add(itemData);
                                                            champItemsList[index]=itemsData;
                                                            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                          }
                                                        }else{
                                                          List<ItemModel> itemDataList=[];
                                                          itemDataList.add(itemData);
                                                          chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                          Map<String,List<ItemModel>> newItem={
                                                            index:itemDataList
                                                          };
                                                          champItemsList.addEntries(
                                                              newItem.entries
                                                          );
                                                        }
                                                      }


                                                      /// This work is done by Salih Hayat
                                                      ///
                                                      /// I have created another list for team to be choosed
                                                      /// Also  I created another list of integer in which I store indexes of the players
                                                      /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                      /// already in the team therefore such a player cannot be added again

                                                      // setState(() {
                                                      //
                                                      // });

                                                    }


                                                  },
                                                  builder: (
                                                      BuildContext context,
                                                      List<dynamic> accepted,
                                                      List<dynamic> rejected,
                                                      ) {
                                                    // print(text);
                                                    String index="1$index1";
                                                    return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                        ?Stack(
                                                      alignment: Alignment.bottomCenter,
                                                      children: [
                                                        SmallImageWidget(
                                                          isPolygon: true,
                                                          imageHeight: 40,
                                                          imageWidth: 40,
                                                          boxWidth: 40,
                                                          boxHeight: 40,
                                                          isBorder: true,
                                                          imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                          borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                          Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                          Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                          Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                          Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,

                                                        ),
                                                        champItemsList.containsKey("1$index1")?
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: List.generate(champItemsList["1$index1"]!.length, (index) {

                                                              return SmallImageWidget(

                                                                imageHeight: 10,
                                                                imageWidth: 10,
                                                                boxWidth: 10,
                                                                boxHeight: 10,
                                                                isBorder: false,
                                                                imageUrl: champItemsList["1$index1"]![index].itemImageUrl,

                                                              );
                                                            })
                                                        )
                                                            :const SizedBox()
                                                      ],
                                                    ):
                                                    // ?  Image.network(
                                                    // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                    // height: 60,
                                                    // width: 60,
                                                    // fit: BoxFit
                                                    //     .fill):
                                                    Image.asset(
                                                        'assets/images/Polygon 7.png');
                                                  }),
                                            ),
                                          )
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0,left: 20),
                                    child: Row(
                                        children: List.generate(7, (index2) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("2$index2")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("2$index2")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("2$index2");
                                                                }
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("2$index2"));
                                                                chosenTeamIndexes.remove("2$index2");
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("2$index2");
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(

                                                  ///Todo: tablet or mobile index2
                                                    onAccept: (champ) {
                                                      String index="2$index2";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                      if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);
                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                      else if(champ.runtimeType==ItemModel){



                                                        itemData =champ as ItemModel;
                                                        // itemData.itemIndex=index;
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                            !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                        }else{

                                                          if(champItemsList.containsKey(index)){
                                                            List<ItemModel>? itemsData=champItemsList[index];
                                                            if(itemsData!.length>2){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                            }else{
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              itemsData.add(itemData);
                                                              champItemsList[index]=itemsData;
                                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                            }
                                                          }else{
                                                            List<ItemModel> itemDataList=[];
                                                            itemDataList.add(itemData);
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            Map<String,List<ItemModel>> newItem={
                                                              index:itemDataList
                                                            };
                                                            champItemsList.addEntries(
                                                                newItem.entries
                                                            );
                                                          }
                                                        }


                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again

                                                        // setState(() {
                                                        //
                                                        // });

                                                      }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="2$index2";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isBorder: true,
                                                            isPolygon: true,
                                                            imageHeight: 40,
                                                            imageWidth: 40,
                                                            boxWidth: 40,
                                                            boxHeight: 40,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("2$index2")?
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["2$index2"]!.length, (index) {

                                                                return SmallImageWidget(

                                                                  imageHeight: 10,
                                                                  imageWidth: 10,
                                                                  boxWidth: 10,
                                                                  boxHeight: 10,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["2$index2"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 80.0),
                                    child: Row(
                                        children: List.generate(7, (index3) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("3$index3")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("3$index3")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("3$index3");
                                                                }
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("3$index3"));
                                                                chosenTeamIndexes.remove("3$index3");
                                                                Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("3$index3");
                                                                Navigator.pop(context);
                                                                setState(() {

                                                                });
                                                              }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(
                                                  ///Todo: tablet or mobile index3
                                                    onAccept: (champ) {
                                                      String index="3$index3";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                      if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);
                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                      else if(champ.runtimeType==ItemModel){



                                                        itemData =champ as ItemModel;
                                                        // itemData.itemIndex=index;
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                            !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                        }else{

                                                          if(champItemsList.containsKey(index)){
                                                            List<ItemModel>? itemsData=champItemsList[index];
                                                            if(itemsData!.length>2){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                            }else{
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              itemsData.add(itemData);
                                                              champItemsList[index]=itemsData;
                                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                            }
                                                          }else{
                                                            List<ItemModel> itemDataList=[];
                                                            itemDataList.add(itemData);
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            Map<String,List<ItemModel>> newItem={
                                                              index:itemDataList
                                                            };
                                                            champItemsList.addEntries(
                                                                newItem.entries
                                                            );
                                                          }
                                                        }


                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again

                                                        // setState(() {
                                                        //
                                                        // });

                                                      }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="3$index3";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isBorder: true,
                                                            isPolygon: true,
                                                            imageHeight: 40,
                                                            imageWidth: 40,
                                                            boxWidth: 40,
                                                            boxHeight: 40,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("3$index3")?
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["3$index3"]!.length, (index) {

                                                                return SmallImageWidget(

                                                                  imageHeight: 10,
                                                                  imageWidth: 10,
                                                                  boxWidth: 10,
                                                                  boxHeight: 10,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["3$index3"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 120.0,left: 20),
                                    child: Row(
                                        children: List.generate(7, (index4) =>
                                            SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: GestureDetector(
                                                onTap: (){
                                                  printLog("===========>Pressed");
                                                  if(chosenTeamIndexes.contains("4$index4")){

                                                    showDialog(context: context,
                                                        builder: (context){
                                                          return AlertDialog(
                                                            content: const Text("Actions"),
                                                            actions: [
                                                              TextButton(onPressed: (){
                                                                printLog("===========>Exist");
                                                                if(champItemsList.containsKey("4$index4")){
                                                                  printLog("=======>Champ items exist");
                                                                  champItemsList.remove("4$index4");

                                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeam.removeAt(chosenTeamIndexes.indexOf("4$index4"));
                                                                  chosenTeamIndexes.remove("4$index4");
                                                                  Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.remove("4$index4");
                                                                  Navigator.pop(context);
                                                                  setState(() {

                                                                  });
                                                                }
                                                              }, child: Text("Remove")),
                                                              TextButton(onPressed: (){
                                                                Navigator.pop(context);
                                                              }, child: Text("Cancel"))
                                                            ],
                                                          );
                                                        });

                                                  }else{
                                                    printLog("===========>Not Exist");
                                                  }

                                                },
                                                child: DragTarget(
                                                  ///Todo: tablet or mobile index4
                                                    onAccept: (champ) {
                                                      String index="4$index4";
                                                      ChampModel data;
                                                      ItemModel itemData;
                                                      print(champ);
                                                      // if(champ.isOfExactGenericType(ChampModel)){

                                                      if(champ.runtimeType ==ChampModel){
                                                        data=champ as ChampModel;
                                                        data.champPositionIndex=index;
                                                        print("==================+Champ model+==============");

                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));

                                                        }else{

                                                          /// If player is not present in team here we can add
                                                          // data.champPositionIndex=index.toString();
                                                          chosenTeam.add(data);

                                                          Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                                                          chosenTeamIndexes.add(index);

                                                          // setState(() {
                                                          //
                                                          // });
                                                        }
                                                      }
                                                      else if(champ.runtimeType==ItemModel){



                                                        itemData =champ as ItemModel;
                                                        // itemData.itemIndex=index;
                                                        if(
                                                        Provider.of<BasicProvider>(context,listen: false).chosenTeam.isEmpty ||
                                                            !Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.contains(index)){
                                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Can't add item unless champ is not added")));

                                                        }else{

                                                          if(champItemsList.containsKey(index)){
                                                            List<ItemModel>? itemsData=champItemsList[index];
                                                            if(itemsData!.length>2){
                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                                                            }else{
                                                              itemsData.add(itemData);
                                                              chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                              champItemsList[index]=itemsData;
                                                              // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));

                                                            }
                                                          }else{
                                                            List<ItemModel> itemDataList=[];
                                                            itemDataList.add(itemData);
                                                            chosenTeam[chosenTeamIndexes.indexOf(index)].champItems.add(itemData.toMap());
                                                            Map<String,List<ItemModel>> newItem={
                                                              index:itemDataList
                                                            };
                                                            champItemsList.addEntries(
                                                                newItem.entries
                                                            );
                                                          }
                                                        }


                                                        /// This work is done by Salih Hayat
                                                        ///
                                                        /// I have created another list for team to be choosed
                                                        /// Also  I created another list of integer in which I store indexes of the players
                                                        /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                                                        /// already in the team therefore such a player cannot be added again

                                                        // setState(() {
                                                        //
                                                        // });

                                                      }


                                                    },
                                                    builder: (
                                                        BuildContext context,
                                                        List<dynamic> accepted,
                                                        List<dynamic> rejected,
                                                        ) {
                                                      // print(text);
                                                      String index="4$index4";
                                                      return Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                                                          ?Stack(
                                                        alignment: Alignment.bottomCenter,
                                                        children: [
                                                          SmallImageWidget(
                                                            isBorder: true,
                                                            isPolygon: true,
                                                            imageHeight: 40,
                                                            imageWidth: 40,
                                                            boxWidth: 40,
                                                            boxHeight: 40,
                                                            imageUrl: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath,
                                                            borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                                                            Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                                                            Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                                                            Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                                                            Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                                                            Colors.yellow:Colors.red
                                                            ,

                                                          ),
                                                          champItemsList.containsKey("4$index4")?
                                                          Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(champItemsList["4$index4"]!.length, (index) {

                                                                return SmallImageWidget(

                                                                  imageHeight: 10,
                                                                  imageWidth: 10,
                                                                  boxWidth: 10,
                                                                  boxHeight: 10,
                                                                  isBorder: false,
                                                                  imageUrl: champItemsList["4$index4"]![index].itemImageUrl,

                                                                );
                                                              })
                                                          )
                                                              :const SizedBox()
                                                        ],
                                                      ):
                                                      // ?  Image.network(
                                                      // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      // height: 60,
                                                      // width: 60,
                                                      // fit: BoxFit
                                                      //     .fill):
                                                      Image.asset(
                                                          'assets/images/Polygon 7.png');
                                                    }),
                                              ),
                                            )
                                        )
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            // SizedBox(
                            //   height: 170,
                            //   width: 300,
                            //   child: Stack(
                            //     alignment: Alignment.topCenter,
                            //     children: [
                            //       Row(
                            //           children: List.generate(7, (index1) =>
                            //               SizedBox(
                            //                 height: 40,
                            //                 width: 40,
                            //                 child: DragTarget(
                            //                     onAccept: (ChampModel data) {
                            //                       data.champPositionIndex="1$index1";
                            //                       /// This work is done by Salih Hayat
                            //                       ///
                            //                       /// I have created another list for team to be choosed
                            //                       /// Also  I created another list of integer in which I store indexes of the players
                            //                       /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                            //                       /// already in the team therefore such a player cannot be added again
                            //                       if(
                            //                       Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                            //                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));
                            //
                            //                       }else{
                            //
                            //                         /// If player is not present in team here we can add
                            //                         // data.champPositionIndex=index.toString();
                            //                         chosenTeam.add(data);
                            //                         String index="1$index1";
                            //                         Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                            //                         chosenTeamIndexes.add(index);
                            //
                            //                         // setState(() {
                            //                         //
                            //                         // });
                            //                       }
                            //
                            //                     }, builder: (
                            //                     BuildContext context,
                            //                     List<dynamic> accepted,
                            //                     List<dynamic> rejected,
                            //                     ) {
                            //                   // print(text);
                            //                   String index="1$index1";
                            //                   return Center(
                            //                     child: ClipRRect(
                            //                       borderRadius:
                            //                       BorderRadius
                            //                           .circular(12),
                            //                       // child
                            //                       /// Here I used chosen team indexes for reference if the player exist in team
                            //                       /// We will show the icon of player else will show blank polygon icon
                            //                       child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                            //                           ?SmallImageWidget(
                            //                         isBorder: true,
                            //                         imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                            //                         borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                            //                         Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                            //                         Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                            //                         Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                            //                         Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                            //                         Colors.yellow:Colors.red
                            //                         ,
                            //
                            //                       ):
                            //                       // ?  Image.network(
                            //                       // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                            //                       // height: 60,
                            //                       // width: 60,
                            //                       // fit: BoxFit
                            //                       //     .fill):
                            //                       Image.asset(
                            //                           'assets/images/Polygon 7.png')
                            //
                            //                       ,
                            //                     ),
                            //                   );
                            //                 }),
                            //               ))
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 40.0,left: 20),
                            //         child: Row(
                            //             children: List.generate(7, (index2) =>
                            //                 SizedBox(
                            //                   height: 40,
                            //                   width: 40,
                            //                   child: DragTarget(
                            //
                            //                       onAccept: (champ) {
                            //                         String index="2$index2";
                            //                         ChampModel data;
                            //                         ItemModel itemData;
                            //                         print(champ);
                            //                         if(champ.isOfExactGenericTypeAs(ChampModel)){
                            //                           data=champ as ChampModel;
                            //                           data.champPositionIndex=index;
                            //
                            //                           /// This work is done by Salih Hayat
                            //                           ///
                            //                           /// I have created another list for team to be choosed
                            //                           /// Also  I created another list of integer in which I store indexes of the players
                            //                           /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                            //                           /// already in the team therefore such a player cannot be added again
                            //                           if(
                            //                           Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                            //                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));
                            //
                            //                           }else{
                            //
                            //                             /// If player is not present in team here we can add
                            //                             // data.champPositionIndex=index.toString();
                            //                             chosenTeam.add(data);
                            //                             Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                            //                             chosenTeamIndexes.add(index);
                            //
                            //                             // setState(() {
                            //                             //
                            //                             // });
                            //                           }
                            //                         }
                            //                         else if(champ.isOfExactGenericTypeAs(ItemModel)){
                            //                           itemData =champ as ItemModel;
                            //                           // itemData.itemIndex=index;
                            //
                            //                           if(champItemsList.containsKey(index)){
                            //                             List<ItemModel>? itemsData=champItemsList[index];
                            //                             if(itemsData!.length>3){
                            //                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This champs items quota is full")));
                            //                             }else{
                            //                               itemsData.add(itemData);
                            //                               champItemsList[index]=itemsData;
                            //                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added successfully")));
                            //
                            //                             }
                            //                           }else{
                            //                             List<ItemModel> itemDataList=[];
                            //                             itemDataList.add(itemData);
                            //                             Map<String,List<ItemModel>> newItem={
                            //                               index:itemDataList
                            //                             };
                            //                             champItemsList.addEntries(
                            //                               newItem.entries
                            //                             );
                            //                           }
                            //
                            //                           /// This work is done by Salih Hayat
                            //                           ///
                            //                           /// I have created another list for team to be choosed
                            //                           /// Also  I created another list of integer in which I store indexes of the players
                            //                           /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                            //                           /// already in the team therefore such a player cannot be added again
                            //
                            //                             // setState(() {
                            //                             //
                            //                             // });
                            //
                            //                         }
                            //
                            //
                            //                       },
                            //                       builder: (
                            //                       BuildContext context,
                            //                       List<dynamic> accepted,
                            //                       List<dynamic> rejected,
                            //                       ) {
                            //                     // print(text);
                            //                     String index="2$index2";
                            //                     return Center(
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                         BorderRadius
                            //                             .circular(12),
                            //                         // child
                            //                         /// Here I used chosen team indexes for reference if the player exist in team
                            //                         /// We will show the icon of player else will show blank polygon icon
                            //                         child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                            //                             ?Column(
                            //                               children: [
                            //                                 SmallImageWidget(
                            //                           isBorder: true,
                            //                           imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                            //                           borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                            //                           Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                            //                           Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                            //                           Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                            //                           Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                            //                           Colors.yellow:Colors.red
                            //                           ,
                            //
                            //                         ),
                            //                                 champItemsList.containsKey("2$index2")?
                            //                                 Row(
                            //                                   children: List.generate(champItemsList["2$index2"]!.length, (index) {
                            //
                            //                                       return SmallImageWidget(
                            //                                         imageHeight: 10,
                            //                                           imageWidth: 10,
                            //                                           boxWidth: 10,
                            //                                           boxHeight: 10,
                            //                                           isBorder: false,
                            //                                           imageUrl: champItemsList["2$index2"]![index].itemImageUrl,
                            //
                            //                                       );
                            //                                   })
                            //                                 )
                            //                                     :const SizedBox()
                            //                               ],
                            //                             ):
                            //                         // ?  Image.network(
                            //                         // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                            //                         // height: 60,
                            //                         // width: 60,
                            //                         // fit: BoxFit
                            //                         //     .fill):
                            //                         Image.asset(
                            //                             'assets/images/Polygon 7.png')
                            //
                            //                         ,
                            //                       ),
                            //                     );
                            //                   }),
                            //                 ))
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 80.0),
                            //         child: Row(
                            //             children: List.generate(7, (index3) =>
                            //                 SizedBox(
                            //                   height: 40,
                            //                   width: 40,
                            //                   child: DragTarget(
                            //                       onAccept: (ChampModel data) {
                            //                         String index="3$index3";
                            //                         data.champPositionIndex=index;
                            //                         /// This work is done by Salih Hayat
                            //                         ///
                            //                         /// I have created another list for team to be choosed
                            //                         /// Also  I created another list of integer in which I store indexes of the players
                            //                         /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                            //                         /// already in the team therefore such a player cannot be added again
                            //                         if(
                            //                         Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                            //                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));
                            //
                            //                         }else{
                            //
                            //                           /// If player is not present in team here we can add
                            //                           // data.champPositionIndex=index.toString();
                            //                           chosenTeam.add(data);
                            //                           Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                            //                           chosenTeamIndexes.add(index);
                            //
                            //                           // setState(() {
                            //                           //
                            //                           // });
                            //                         }
                            //
                            //                       }, builder: (
                            //                       BuildContext context,
                            //                       List<dynamic> accepted,
                            //                       List<dynamic> rejected,
                            //                       ) {
                            //                     // print(text);
                            //                     String index="3$index3";
                            //                     return Center(
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                         BorderRadius
                            //                             .circular(12),
                            //                         // child
                            //                         /// Here I used chosen team indexes for reference if the player exist in team
                            //                         /// We will show the icon of player else will show blank polygon icon
                            //                         child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                            //                             ?SmallImageWidget(
                            //                           isBorder: true,
                            //                           imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                            //                           borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                            //                           Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                            //                           Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                            //                           Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                            //                           Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                            //                           Colors.yellow:Colors.red
                            //                           ,
                            //
                            //                         ):
                            //                         // ?  Image.network(
                            //                         // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                            //                         // height: 60,
                            //                         // width: 60,
                            //                         // fit: BoxFit
                            //                         //     .fill):
                            //                         Image.asset(
                            //                             'assets/images/Polygon 7.png')
                            //
                            //                         ,
                            //                       ),
                            //                     );
                            //                   }),
                            //                 ))
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 120.0,left: 20),
                            //         child: Row(
                            //             children: List.generate(7, (index4) =>
                            //                 SizedBox(
                            //                   height: 40,
                            //                   width: 40,
                            //                   child: DragTarget(
                            //                       onAccept: (ChampModel data) {
                            //                         data.champPositionIndex="4$index4";
                            //                         /// This work is done by Salih Hayat
                            //                         ///
                            //                         /// I have created another list for team to be choosed
                            //                         /// Also  I created another list of integer in which I store indexes of the players
                            //                         /// If chosen Team contains data or chosenTeamIndexes contains index than player is
                            //                         /// already in the team therefore such a player cannot be added again
                            //                         if(
                            //                         Provider.of<BasicProvider>(context,listen: false).chosenTeam.contains(data)){
                            //                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("This Player is already in Team")));
                            //
                            //                         }else{
                            //
                            //                           /// If player is not present in team here we can add
                            //                           // data.champPositionIndex=index.toString();
                            //                           chosenTeam.add(data);
                            //                           String index="4$index4";
                            //                           Provider.of<BasicProvider>(context,listen: false).updateChosenTeam(data, index);
                            //                           chosenTeamIndexes.add(index);
                            //
                            //                           // setState(() {
                            //                           //
                            //                           // });
                            //                         }
                            //
                            //                       }, builder: (
                            //                       BuildContext context,
                            //                       List<dynamic> accepted,
                            //                       List<dynamic> rejected,
                            //                       ) {
                            //                     // print(text);
                            //                     String index="4$index4";
                            //                     return Center(
                            //                       child: ClipRRect(
                            //                         borderRadius:
                            //                         BorderRadius
                            //                             .circular(12),
                            //                         // child
                            //                         /// Here I used chosen team indexes for reference if the player exist in team
                            //                         /// We will show the icon of player else will show blank polygon icon
                            //                         child: Provider.of<BasicProvider>(context).chosenTeamIndexes.contains(index)
                            //                             ?SmallImageWidget(
                            //                           isBorder: true,
                            //                           imageUrl: apiImageUrl + Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase(),
                            //                           borderColor: Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='1'?
                            //                           Colors.grey:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='2'?
                            //                           Colors.green:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='3'?
                            //                           Colors.blue:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='4'?
                            //                           Colors.purple:Provider.of<BasicProvider>(context,listen: false).chosenTeam[Provider.of<BasicProvider>(context,listen: false).chosenTeamIndexes.indexOf(index)].champCost=='5'?
                            //                           Colors.yellow:Colors.red
                            //                           ,
                            //
                            //                         ):
                            //                         // ?  Image.network(
                            //                         // baseUrl + chosenTeam[chosenTeamIndexes.indexOf(index)].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                            //                         // height: 60,
                            //                         // width: 60,
                            //                         // fit: BoxFit
                            //                         //     .fill):
                            //                         Image.asset(
                            //                             'assets/images/Polygon 7.png')
                            //
                            //                         ,
                            //                       ),
                            //                     );
                            //                   }),
                            //                 ))
                            //         ),
                            //       ),
                            //
                            //     ],
                            //   ),
                            // ),
                          ),
                          MediaQuery.of(context).size.width>600
                              && MediaQuery.of(context).size.width<=1200?Column(
                            children: [
                              NeonTabButtonWidget(
                                onTap: null,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xffF48B19),
                                    Color(0x20F48B19),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                    // Color(0xffF48B19).withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                btnHeight: 35,
                                btnWidth:
                                width * 0.2,
                                btnText: 'Core Champs',
                              ),
                              Container(
                                width: width*.22,
                                height:170,
                                // margin: const EdgeInsets.only(0)
                                alignment:Alignment.center,
                                padding:
                                ResponsiveWidget.isWebScreen(context)
                                    ? const EdgeInsets.symmetric(
                                    horizontal: 20)
                                    : const EdgeInsets.symmetric(
                                    horizontal: 8),
                                decoration:
                                ImagePageBoxDecoration(context),
                                child: const Text(
                                  'Double click a champ on field to add them as core champion for the team comp.',
                                  textAlign:TextAlign.center
                                  ,style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ):
                          const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),



                      Container(
                        height: height*.35,
                        // width: width(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                width: 1, color: Color(0xffF48B19))),
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 220,
                                    child: TextField(
                                      onChanged: (value) {
                                        Provider.of<BasicProvider>(context,listen: false).runFilter(value,true,true);
                                        setState(() {

                                        });
                                      } ,
                                      style: TextStyle(color: Colors.grey),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.grey),
                                        fillColor: Color(0xff191741),
                                        filled: true,
                                        hintText: 'Search champion',
                                        hintStyle:
                                        TextStyle(color: Colors.grey),
                                        contentPadding:
                                        EdgeInsets.symmetric(
                                            vertical: 10.0,
                                            horizontal: 20.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.mainColor,
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      provider.sortChampList(true);
                                      reverseSorted=false;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff191741),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          border: reverseSorted?null:Border.all(
                                              width: 1,
                                              color: const Color(0xffF48B19)
                                          )
                                      ),
                                      child: const Text(
                                        'A-Z',
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: (){
                                      provider.sortChampListZtoA(true);
                                      reverseSorted=true;
                                      setState(() {

                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff191741),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          border: reverseSorted?Border.all(
                                              width: 1,
                                              color: const Color(0xffF48B19)
                                          ):null
                                      ),
                                      child: Text(
                                        'Z-A',
                                        style: TextStyle(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff191741),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          MaterialButton(
                                              height: 35,
                                              shape:
                                              showItems?null:RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8)),
                                              color: showItems?Colors.transparent:const Color(0xffF48B19),
                                              onPressed: () {
                                                printLog("${provider.teamBuilderChamps.length}");
                                                setState(() {
                                                  showItems=false;
                                                });
                                              },
                                              child: Text(
                                                'Champions',
                                                style: TextStyle(
                                                    color: showItems?Colors.grey:Colors.white),
                                              )),
                                          MaterialButton(
                                              height: 35,
                                              shape:showItems?
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      8)):null,
                                              color: showItems?const Color(0xffF48B19):Colors.transparent,
                                              onPressed: () {
                                                setState(() {
                                                  showItems=true;
                                                });
                                              },
                                              child: Text(
                                                'Items',
                                                style: TextStyle(
                                                    color: showItems?Colors.white:Colors.grey),
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ),

                            Visibility(
                              visible: !showItems,
                              child: Column(
                                children: [
                                  Provider.of<BasicProvider>(context).dataFetched &&
                                      provider.visibleSearchData?
                                  SizedBox(
                                    height: height*.22,
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: [
                                          // for (int i = 0; i < champListFromFirebase.length; i++)
                                          for (int index = 0; index < Provider.of<BasicProvider>(context).foundData.length; index++)
                                          // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                                            Draggable(
                                              data: provider.foundData[index],
                                              onDraggableCanceled:
                                                  (velocity, offset) {},
                                              feedback: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(12),
                                                  child:SmallImageWidget(
                                                    isBorder: true,
                                                    imageUrl: provider.foundData[index].imagePath,
                                                    borderColor: provider.foundData[index].champCost=='1'?
                                                    Colors.grey:provider.foundData[index].champCost=='2'?
                                                    Colors.green:provider.foundData[index].champCost=='3'?
                                                    Colors.blue:provider.foundData[index].champCost=='4'?
                                                    Colors.purple:provider.foundData[index].champCost=='5'?
                                                    Colors.yellow:Colors.red
                                                    ,
                                                    imageHeight: 30,
                                                    imageWidth: 30,
                                                  )
                                                // child: Image.network(
                                                //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                //     height: 70,
                                                //     width: 70,
                                                //     fit: BoxFit.fill),
                                              ),
                                              child: Container(
                                                  child: Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            12),
                                                        child: SmallImageWidget(
                                                          isBorder: true,
                                                          imageUrl: provider.foundData[index].imagePath,
                                                          borderColor: provider.foundData[index].champCost=='1'?
                                                          Colors.grey:provider.foundData[index].champCost=='2'?
                                                          Colors.green:provider.foundData[index].champCost=='3'?
                                                          Colors.blue:provider.foundData[index].champCost=='4'?
                                                          Colors.purple:provider.foundData[index].champCost=='5'?
                                                          Colors.yellow:Colors.red
                                                          ,
                                                          imageHeight: 30,
                                                          imageWidth: 30,
                                                        ),
                                                        // child: Image.network(
                                                        //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                        //     height: 60,
                                                        //     width: 60,
                                                        //     fit: BoxFit
                                                        //         .fill),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        provider.foundData[index].champName.length<8?provider.foundData[index].champName:provider.foundData[index].champName.substring(0,6),
                                                        style: const TextStyle(
                                                            color:
                                                            Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  )),
                                            )
                                          //                       Container(
                                          //                         height: height(context) * 0.07,
                                          //                         width: height(context) * 0.07,
                                          //                         decoration: BoxDecoration(
                                          //                           borderRadius: BorderRadius.circular(17),
                                          //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                               ? Border.all(
                                          //                                   // color: AppColors.skyBorderColor,
                                          //                             color: Colors.grey,
                                          //                                   width: 2.27,
                                          //                                 )
                                          //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                          //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.green,
                                          //                             width: 2.27,
                                          //                           )
                                          //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                          //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.blue,
                                          //                             width: 2.27,
                                          //
                                          //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                          //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.purple,
                                          //                             width: 2.27,
                                          //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.yellow,
                                          //                             width: 2.27,
                                          //                           ):
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.red,
                                          //                             width: 2.27,
                                          //                           ),
                                          //                           boxShadow: [
                                          //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                                 ? BoxShadow(
                                          //                                     color: Colors.grey
                                          //                                         .withOpacity(0.6),
                                          //                                     blurRadius: 10,
                                          //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.green
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.blue
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.purple
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.yellow
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):BoxShadow(
                                          //                               color: Colors.red
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             )
                                          //
                                          //                           ]
                                          // ,
                                          //                           image: DecorationImage(
                                          //                             fit: BoxFit.fill,
                                          //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                          //                               ///
                                          //                               ///  16-May-2023
                                          //                               ///  New Image path fetched from firebase
                                          //                               ///  and shown
                                          //                               ///
                                          //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
                                          //
                                          //
                                          //                         ),
                                          //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                                          //                         // child: Image.network(
                                          //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                          //                         //     height: 60,
                                          //                         //     width: 60,
                                          //                         //
                                          //                         //     fit: BoxFit
                                          //                         //         .fill),
                                          //                       )
                                        ],
                                      ),
                                    ),
                                  ):
                                  Provider.of<BasicProvider>(context).dataFetched &&
                                      provider.visibleSearchData==false?
                                  SizedBox(
                                    height: height*.22,
                                    child: SingleChildScrollView(
                                         child: Wrap(
                                        alignment: WrapAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: [
                                          // for (int i = 0; i < champListFromFirebase.length; i++)
                                          for (int index = 0; index < Provider.of<BasicProvider>(context).teamBuilderChamps.length; index++)
                                          // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                                            Draggable(
                                              data: provider.teamBuilderChamps[index],
                                              onDraggableCanceled:
                                                  (velocity, offset) {},
                                              feedback: SmallImageWidget(
                                                isBorder: true,
                                                imageUrl: provider.teamBuilderChamps[index].imagePath,
                                                borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                Colors.yellow:Colors.red
                                                ,
                                                imageHeight: 30,
                                                imageWidth: 30,
                                              ),
                                              child: SizedBox(
                                                height: 50,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SmallImageWidget(
                                                      boxHeight: 30,
                                                      boxWidth: 30,
                                                      isBorder: true,
                                                      imageUrl: provider.teamBuilderChamps[index].imagePath,
                                                      borderColor: provider.teamBuilderChamps[index].champCost=='1'?
                                                      Colors.grey:provider.teamBuilderChamps[index].champCost=='2'?
                                                      Colors.green:provider.teamBuilderChamps[index].champCost=='3'?
                                                      Colors.blue:provider.teamBuilderChamps[index].champCost=='4'?
                                                      Colors.purple:provider.teamBuilderChamps[index].champCost=='5'?
                                                      Colors.yellow:Colors.red
                                                      ,
                                                      imageHeight: 30,
                                                      imageWidth: 30,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      provider.teamBuilderChamps[index].champName.length<8?provider.teamBuilderChamps[index].champName:provider.teamBuilderChamps[index].champName.substring(0,6),
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          //                       Container(
                                          //                         height: height(context) * 0.07,
                                          //                         width: height(context) * 0.07,
                                          //                         decoration: BoxDecoration(
                                          //                           borderRadius: BorderRadius.circular(17),
                                          //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                               ? Border.all(
                                          //                                   // color: AppColors.skyBorderColor,
                                          //                             color: Colors.grey,
                                          //                                   width: 2.27,
                                          //                                 )
                                          //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                          //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.green,
                                          //                             width: 2.27,
                                          //                           )
                                          //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                          //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.blue,
                                          //                             width: 2.27,
                                          //
                                          //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                          //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.purple,
                                          //                             width: 2.27,
                                          //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.yellow,
                                          //                             width: 2.27,
                                          //                           ):
                                          //                           Border.all(
                                          //                             // color: AppColors.skyBorderColor,
                                          //                             color: Colors.red,
                                          //                             width: 2.27,
                                          //                           ),
                                          //                           boxShadow: [
                                          //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                          //                                 ? BoxShadow(
                                          //                                     color: Colors.grey
                                          //                                         .withOpacity(0.6),
                                          //                                     blurRadius: 10,
                                          //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.green
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.blue
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.purple
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                          //                                 ? BoxShadow(
                                          //                               color: Colors.yellow
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             ):BoxShadow(
                                          //                               color: Colors.red
                                          //                                   .withOpacity(0.6),
                                          //                               blurRadius: 10,
                                          //                             )
                                          //
                                          //                           ]
                                          // ,
                                          //                           image: DecorationImage(
                                          //                             fit: BoxFit.fill,
                                          //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                          //                               ///
                                          //                               ///  16-May-2023
                                          //                               ///  New Image path fetched from firebase
                                          //                               ///  and shown
                                          //                               ///
                                          //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
                                          //
                                          //
                                          //                         ),
                                          //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                                          //                         // child: Image.network(
                                          //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                          //                         //     height: 60,
                                          //                         //     width: 60,
                                          //                         //
                                          //                         //     fit: BoxFit
                                          //                         //         .fill),
                                          //                       )
                                        ],
                                      ),
                                    ),
                                  ):
                                  const Text("No data found",style: TextStyle(color:Color(0xffffffff)),),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: showItems,
                              child: Expanded(
                                child: Container(
                                  // height: MediaQuery.of(context).size.height*.175,
                                    child:
                                    Provider.of<BasicProvider>(context).dataFetched &&
                                        provider.visibleSearchData==false?
                                    SizedBox(
                                      height: height*.22,
                                      child: SingleChildScrollView(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          runAlignment: WrapAlignment.center,
                                          spacing: 5,
                                          runSpacing: 5,
                                          children: [
                                            // for (int i = 0; i < champListFromFirebase.length; i++)
                                            for (int index = 0; index < Provider.of<BasicProvider>(context).teamBuilderItems.length; index++)
                                            // for (int i = 0; i < Provider.of<SearchProvider>(context).champListFromFirebase.length; i++)
                                              Draggable(
                                                data: provider.teamBuilderItems[index],
                                                onDraggableCanceled:
                                                    (velocity, offset) {},
                                                feedback: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(12),
                                                    child:SmallImageWidget(
                                                      isBorder: true,
                                                      imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                                    )
                                                  // child: Image.network(
                                                  //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                  //     height: 70,
                                                  //     width: 70,
                                                  //     fit: BoxFit.fill),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          12),
                                                      child: SmallImageWidget(
                                                        isBorder: true,
                                                        imageUrl: provider.teamBuilderItems[index].itemImageUrl,


                                                      ),
                                                      // child: Image.network(
                                                      //     baseUrl + champ[index].imagePath.toString().toLowerCase().replaceAll('.dds', '.png'),
                                                      //     height: 60,
                                                      //     width: 60,
                                                      //     fit: BoxFit
                                                      //         .fill),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      provider.teamBuilderItems[index].itemName.length>14?provider.teamBuilderItems[index].itemName.substring(0,15):
                                                      provider.teamBuilderItems[index].itemName,
                                                      style: const TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            //                       Container(
                                            //                         height: height(context) * 0.07,
                                            //                         width: height(context) * 0.07,
                                            //                         decoration: BoxDecoration(
                                            //                           borderRadius: BorderRadius.circular(17),
                                            //                           border: Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                            //                             // border: Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='1'
                                            //                               ? Border.all(
                                            //                                   // color: AppColors.skyBorderColor,
                                            //                             color: Colors.grey,
                                            //                                   width: 2.27,
                                            //                                 )
                                            //                               : Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'?
                                            //                               // : Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='2'?
                                            //                           Border.all(
                                            //                             // color: AppColors.skyBorderColor,
                                            //                             color: Colors.green,
                                            //                             width: 2.27,
                                            //                           )
                                            //                               :Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'?
                                            //                               // :Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='3'?
                                            //                           Border.all(
                                            //                             // color: AppColors.skyBorderColor,
                                            //                             color: Colors.blue,
                                            //                             width: 2.27,
                                            //
                                            //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'?
                                            //                              // ):Provider.of<SearchProvider>(context).champListFromFirebase[i].champCost=='4'?
                                            //                           Border.all(
                                            //                             // color: AppColors.skyBorderColor,
                                            //                             color: Colors.purple,
                                            //                             width: 2.27,
                                            //                           ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'?
                                            //                           Border.all(
                                            //                             // color: AppColors.skyBorderColor,
                                            //                             color: Colors.yellow,
                                            //                             width: 2.27,
                                            //                           ):
                                            //                           Border.all(
                                            //                             // color: AppColors.skyBorderColor,
                                            //                             color: Colors.red,
                                            //                             width: 2.27,
                                            //                           ),
                                            //                           boxShadow: [
                                            //                             Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='1'
                                            //                                 ? BoxShadow(
                                            //                                     color: Colors.grey
                                            //                                         .withOpacity(0.6),
                                            //                                     blurRadius: 10,
                                            //                                   ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='2'
                                            //                                 ? BoxShadow(
                                            //                               color: Colors.green
                                            //                                   .withOpacity(0.6),
                                            //                               blurRadius: 10,
                                            //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='3'
                                            //                                 ? BoxShadow(
                                            //                               color: Colors.blue
                                            //                                   .withOpacity(0.6),
                                            //                               blurRadius: 10,
                                            //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='4'
                                            //                                 ? BoxShadow(
                                            //                               color: Colors.purple
                                            //                                   .withOpacity(0.6),
                                            //                               blurRadius: 10,
                                            //                             ):Provider.of<BasicProvider>(context).champListFromFirebase[i].champCost=='5'
                                            //                                 ? BoxShadow(
                                            //                               color: Colors.yellow
                                            //                                   .withOpacity(0.6),
                                            //                               blurRadius: 10,
                                            //                             ):BoxShadow(
                                            //                               color: Colors.red
                                            //                                   .withOpacity(0.6),
                                            //                               blurRadius: 10,
                                            //                             )
                                            //
                                            //                           ]
                                            // ,
                                            //                           image: DecorationImage(
                                            //                             fit: BoxFit.fill,
                                            //                               // image: NetworkImage('${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}'))
                                            //                               ///
                                            //                               ///  16-May-2023
                                            //                               ///  New Image path fetched from firebase
                                            //                               ///  and shown
                                            //                               ///
                                            //                               image: NetworkImage(apiImageUrl + Provider.of<BasicProvider>(context).champListFromFirebase[i].imagePath.toString().toLowerCase()))
                                            //
                                            //
                                            //                         ),
                                            //                         // child: Text(Provider.of<BasicProvider>(context).champListFromFirebase[i].champName,style: const TextStyle(color: Colors.white),),
                                            //                         // child: Image.network(
                                            //                         //     '${baseUrl + champListFromFirebase[i].imagePath.toString().toLowerCase().replaceAll('.dds', '.png')}',
                                            //                         //     height: 60,
                                            //                         //     width: 60,
                                            //                         //
                                            //                         //     fit: BoxFit
                                            //                         //         .fill),
                                            //                       )
                                          ],
                                        ),
                                      ),
                                    ):
                                    const Text("No data found",style: TextStyle(color:Color(0xffffffff)),)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
