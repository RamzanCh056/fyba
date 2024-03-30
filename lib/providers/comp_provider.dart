



import 'package:flutter/cupertino.dart';

class CompProvider extends ChangeNotifier{
  List<Map<String,dynamic>> popularCompList=[];
  List<Map<String,dynamic>> currentUserCompList=[];

  updateList(List<Map<String,dynamic>> list,bool isPopular){
    if(isPopular){
      popularCompList=list;
    }else{
      currentUserCompList=list;
    }
    notifyListeners();
  }

}