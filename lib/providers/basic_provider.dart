
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/item_model.dart';
import '/screens/Admin/Model/api_data_model.dart';

class BasicProvider with ChangeNotifier{
  String baseUrl = 'https://raw.communitydragon.org/latest/game/';
  String apiImageUrl =  'https://raw.communitydragon.org/pbe/plugins/rcp-be-lol-game-data/global/default/assets/characters/';
  bool isLoading=false;
  bool firebaseDataDeleted = false;
  bool firebaseDataAdded = false;
  bool dataFetched=false;
  List<ChampModel> chosenTeam=[];
  List<List<ItemModel>> choseTeamItemsList=[];
  List<String> chosenTeamIndexes=[];
  List<ChampModel> teamBuilderChamps=[];
  List<ItemModel> teamBuilderItems=[];


  List<ChampModel> pinnedCompChamps=[];
  fetchCurrentPinnedComp()async{
    var data= await FirebaseFirestore.instance.collection(pinnedCompCollection).doc("0123").get();
    if(data.exists){
      var pinnedData=jsonDecode(data["compId"]);
      for(int i=0;i<pinnedData.length;i++){
        pinnedCompChamps.add(ChampModel.fromJson(pinnedData[i]));
      }
      // pinnedCompChamps=data["compId"] as List
      // <ChampModel>;
      notifyListeners();
    }
  }
  
  updateTeamBuilderItems(List<ItemModel> items){
    teamBuilderItems = items;
    notifyListeners();
  }

  updateTeamBuilderChamps(List<ChampModel> champ){
    teamBuilderChamps = champ;
    notifyListeners();
  }

  List<List<ChampModel>> compChampList=[];
  updateCompChampList(List<List<ChampModel>> compChampionsList){
    compChampList.clear();
    compChampList=compChampionsList;
    notifyListeners();
  }

  List<List<ChampModel>> myTeamsCompChampList=[];
  updateMyTeamsCompChampList(List<List<ChampModel>> compChampionsList){
    myTeamsCompChampList.clear();
    myTeamsCompChampList=compChampionsList;
    notifyListeners();
  }

  sortChampList(bool isTeamBuilder){
    if(isTeamBuilder){
      print("Sorting in reverse");
      teamBuilderChamps.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      // teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      // teamBuilderChamps=teamBuilderChamps.reversed.toList();
    }else{
      print("Sorting");
      teamBuilderChamps.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      // champListFromFirebase=champListFromFirebase.reversed.toList();
    }

    notifyListeners();
  }


  sortChampListZtoA(bool isTeamBuilder){
    if(isTeamBuilder){
      print("Sorting in reverse");
      // teamBuilderChamps.sort((a,b)=>(a.champName+a.champCost).compareTo(b.champName+b.champCost));
      teamBuilderChamps=teamBuilderChamps.reversed.toList();
    }else{
      print("Sorting");
      // teamBuilderChamps.sort((a,b)=>int.parse(a.champCost).compareTo(int.parse(b.champCost)));
      champListFromFirebase=champListFromFirebase.reversed.toList();
    }

    notifyListeners();
  }


  sortCompChampListByAtoZ(){
    List<List<ChampModel>> temporaryCompChampList=[];
    for(int i=0; i<compChampList.length;i++){
      List<ChampModel> temporaryChampList=compChampList[i].reversed.toList();
      temporaryCompChampList.add(temporaryChampList);
    }
    compChampList=temporaryCompChampList;
    notifyListeners();
  }



  updataDataFetched(){
    dataFetched=true;
    notifyListeners();
  }

  updateChosenTeam(ChampModel champ,String index){
    chosenTeam.add(champ);
    chosenTeamIndexes.add(index);
    notifyListeners();
  }

  resetChosenTeam(){
    chosenTeam.clear();
    chosenTeamIndexes.clear();
    notifyListeners();
  }


  startLoading(){
    isLoading= true;
    notifyListeners();
  }

  stopLoading(){
    isLoading= false;
    notifyListeners();
  }

  updateFirebaseDataDeleted(){
    firebaseDataDeleted=true;
    notifyListeners();
  }

  resetFirebaseDataDeleted(){
    firebaseDataDeleted=false;
    notifyListeners();
  }

  updateFirebaseDataAdded(){
    firebaseDataAdded=true;
    notifyListeners();
  }

  resetFirebaseDataAdded(){
    firebaseDataAdded=true;
    notifyListeners();
  }




  /// ************************************************************
///

  ///       ======> Code for optimization of left side widget <======
  ///

  List<ChampModel> champListFromFirebase =[];
  List<ChampModel> foundData =[];
  List<ItemModel> foundItems=[];

  TextEditingController searchController=TextEditingController();
  bool visibleSearchData = false;
  bool isVisibleDataFromFirebase=false;

  updateVisibleFromFirebase(){
    foundData.clear();
    foundItems.clear();
    visibleSearchData=false;
    isVisibleDataFromFirebase=true;
    notifyListeners();
  }

  void runFilter(String enteredKeyword,bool isTeamBuilder,bool isItems) {

    List<ItemModel> itemResults=[];
    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      isVisibleDataFromFirebase=true;
      visibleSearchData=false;
      notifyListeners();
    } else {
      isVisibleDataFromFirebase=false;
      visibleSearchData=true;
      if(isTeamBuilder && isItems==false){
        results = teamBuilderChamps.where((user) =>
            user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();

      }else  if(isTeamBuilder && isItems==true){
        itemResults = teamBuilderItems.where((item) =>
            item.itemName.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();

      }{
        results = champListFromFirebase.where((user) =>
            user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      }

    }
    if(isItems) {
      foundItems=itemResults;
    }else{
      foundData=results;
    }
    notifyListeners();
  }

  updateFirebaseDataFetchedLeftSideWidget(List<ChampModel> champList){
    champListFromFirebase.clear();
    champListFromFirebase=champList;
    isVisibleDataFromFirebase=true;
    notifyListeners();
  }



  List<ChampModel> localChampsList=[];
  List<ItemModel> localItemsList=[];

  updateChampList(List<ChampModel> champList){
    localChampsList=champList;
    notifyListeners();
  }

  updateItemsList(List<ItemModel> itemList){
    localItemsList=itemList;
    notifyListeners();
  }

  List<Map<String,dynamic>> popularCompList=[];
  List<Map<String,dynamic>> currentUserCompList=[];
  List<Map<String,dynamic>> searchedPopularCompList=[];
  List<Map<String,dynamic>> searchedCurrentUserCompList=[];
  searchComp(){

  }


}
