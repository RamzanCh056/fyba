import 'package:flutter/material.dart';

import '../screens/Admin/Model/api_data_model.dart';
import 'basic_provider.dart';

class SearchProvider extends ChangeNotifier{


  List<ChampModel> champListFromFirebase =[];
  List<ChampModel> foundData =[];

  TextEditingController searchController=TextEditingController();
  bool visibleSearchData = false;
  bool isVisibleDataFromFirebase=false;

  void runFilter(String enteredKeyword) {

    List<ChampModel> results = [];
    if (enteredKeyword.isEmpty) {
      print("showing data from firebase");
      // if the search field is empty or only contains white-space, we'll display all users
      // results = champListFromFirebase;
      results=champListFromFirebase;
      isVisibleDataFromFirebase=true;
      visibleSearchData=false;
      notifyListeners();
    } else {
      isVisibleDataFromFirebase=false;
      visibleSearchData=true;
      print("showing data from search");
      results = champListFromFirebase.where((user) =>
          user.champName.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // results = champListFromFirebase.where((user) =>
      //     user.champName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
      //     .toList();
    }
    foundData=results;
    print(foundData);
    notifyListeners();
  }


  updateFirebaseDataFetchedLeftSideWidget(List<ChampModel> champList){
    champListFromFirebase.clear();
    champListFromFirebase=champList;
    isVisibleDataFromFirebase=true;
    notifyListeners();
  }


}