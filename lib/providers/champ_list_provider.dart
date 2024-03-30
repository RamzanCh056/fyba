


import 'package:flutter/material.dart';

import '../screens/Admin/Model/api_data_model.dart';

class ChampListProvider with ChangeNotifier{
  List<ChampModel> champList=[];

  updateChampList(List<ChampModel> newList){
    champList=newList;
    notifyListeners();
  }


}